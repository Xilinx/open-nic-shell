// *************************************************************************
//
// Copyright 2020 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// *************************************************************************
// This module implements Toeplitz function to hash n-tuple of input packets.
//
// [TODO]
// - Add VLAN support
`timescale 1ns/1ps
module qdma_subsystem_hash (
  input         p_axis_tvalid,
  input [511:0] p_axis_tdata,
  input         p_axis_tlast,
  input         p_axis_tready,

  input [319:0] hash_key,
  output reg    hash_result_valid,
  output [31:0] hash_result,

  input         aclk,
  input         aresetn
);

  localparam S_S1_IDLE                = 2'd0;
  localparam S_S1_MORE                = 2'd1;
  localparam S_S1_PASS                = 2'd2;

  localparam C_MIN_ETH_HDR_LEN        = 14;
  localparam C_MAX_ETH_HDR_LEN        = 18;
  localparam C_MIN_IP4_HDR_LEN        = 20;
  localparam C_MAX_IP4_HDR_LEN        = 60;
  localparam C_TCPUDP_HDR_PART_LEN    = 4;
  localparam C_MAX_ETH_PAYLOAD_LEN    = C_MAX_IP4_HDR_LEN + C_TCPUDP_HDR_PART_LEN;
  localparam C_MAX_IP4_PAYLOAD_LEN    = C_TCPUDP_HDR_PART_LEN;

  localparam C_ETH_TYPE_8021Q         = 16'h0081;
  localparam C_ETH_TYPE_IP4           = 16'h0008;

  localparam C_ETH_TYPE_OFFSET        = 12;
  localparam C_ETH_TYPE_LEN           = 2;
  localparam C_ETH_8021Q_TCI_OFFSET   = 14;
  localparam C_ETH_8021Q_TCI_LEN      = 2;
  localparam C_ETH_8021Q_TYPE_OFFSET  = 16;
  localparam C_ETH_8021Q_TYPE_LEN     = 2;
  localparam C_ETH_8021Q_VID_MASK     = 16'h0FFF;

  localparam C_IP4_PROTO_TCP          = 8'h06;
  localparam C_IP4_PROTO_UDP          = 8'h11;
  
  localparam C_IP4_IHL_OFFSET         = 0;
  localparam C_IP4_IHL_LEN            = 1;
  localparam C_IP4_IHL_MASK           = 8'h0F;
  localparam C_IP4_PROTO_OFFSET       = 9;
  localparam C_IP4_PROTO_LEN          = 1;
  localparam C_IP4_SRC_ADDR_OFFSET    = 12;
  localparam C_IP4_SRC_ADDR_LEN       = 4;
  localparam C_IP4_DST_ADDR_OFFSET    = 16;
  localparam C_IP4_DST_ADDR_LEN       = 4;

  localparam C_TCPUDP_SRC_PORT_OFFSET = 0;
  localparam C_TCPUDP_SRC_PORT_LEN    = 2;
  localparam C_TCPUDP_DST_PORT_OFFSET = 2;
  localparam C_TCPUDP_DST_PORT_LEN    = 2;

  reg                         [1:0] s1_state;
  reg                         [1:0] next_s1_state;

  reg                        [11:0] vid_shift_reg[0:1];
  reg                               eth_payload_valid;
  reg [C_MAX_ETH_PAYLOAD_LEN*8-1:0] eth_payload;
  reg                               eth_is_8021q;
  reg                               eth_type_is_ip4;

  reg                        [11:0] next_vid_shift_reg[0:1];
  reg [C_MAX_ETH_PAYLOAD_LEN*8-1:0] next_eth_payload;
  reg                               next_eth_payload_valid;
  reg                               next_eth_is_8021q;
  reg                               next_eth_type_is_ip4;

  wire                       [15:0] eth_type;
  wire                       [15:0] eth_8021q_type;
  wire                       [11:0] eth_8021q_vid;

  reg                               ip4_payload_valid;
  reg [C_MAX_IP4_PAYLOAD_LEN*8-1:0] ip4_payload;
  reg                         [7:0] ip4_proto;
  reg                        [31:0] ip4_src_addr;
  reg                        [31:0] ip4_dst_addr;
  wire                        [3:0] ip4_ihl;
  wire                       [71:0] ip4_tuple;

  reg                        [31:0] vid_hash;
  reg                        [31:0] ip4_hash[0:3];
  reg                        [31:0] port_hash[0:1];

  // Stage 1: save the Ethernet payload up to the interested length and extract
  // VLAN ID if Ethernet header contains VLAN tagging
  always @(*) begin
    next_vid_shift_reg[0]  = 0;
    next_vid_shift_reg[1]  = 0;
    next_eth_payload_valid = 1'b0;
    next_eth_payload       = eth_payload;
    next_eth_type_is_ip4   = eth_type_is_ip4;
    next_eth_is_8021q      = eth_is_8021q;
    next_s1_state          = s1_state;

    case (s1_state)
      S_S1_IDLE: begin
        // First beat
        if (p_axis_tvalid && p_axis_tready) begin
          case (eth_type)
            C_ETH_TYPE_IP4: begin
              // Without VLAN, Ethernet header is 14 bytes, yielding a payload
              // of 50 bytes in the first beat
              next_vid_shift_reg[0]         = 0;
              next_eth_payload[0 +: (50*8)] = p_axis_tdata[(14*8) +: (50*8)];
              next_eth_type_is_ip4          = 1'b1;
              next_eth_is_8021q             = 1'b0;
            end
            C_ETH_TYPE_8021Q: begin
              // With VLAN, an additional 4 bytes are inserted into Ethernet
              // header, leaving a payload of 46 bytes in the first beat
              next_vid_shift_reg[0]         = eth_8021q_vid;
              next_eth_payload[0 +: (46*8)] = p_axis_tdata[(18*8) +: (46*8)];
              next_eth_type_is_ip4          = (eth_8021q_type == C_ETH_TYPE_IP4);
              next_eth_is_8021q             = 1'b1;
            end
            default: begin
              // No VLAN tag and not IPv4 packets
              next_vid_shift_reg[0] = 0;
              next_eth_payload      = 0;
              next_eth_type_is_ip4  = 1'b0;
              next_eth_is_8021q     = 1'b0;
            end
          endcase

          if (p_axis_tlast) begin
            // Packet has no more than 64 bytes
            next_vid_shift_reg[1]  = vid_shift_reg[0];
            next_eth_payload_valid = 1'b1;
            next_s1_state          = S_S1_IDLE;
          end
          else begin
            // Packet has more than 64 bytes
            next_vid_shift_reg[1] = vid_shift_reg[1];
            next_s1_state         = S_S1_MORE;
          end
        end
      end

      S_S1_MORE: begin
        // Second beat
        if (p_axis_tvalid && p_axis_tready) begin
          if (~eth_is_8021q) begin
            // Saved 50 bytes, need at most 14 bytes (60 bytes IP header plus 4
            // bytes TCP/UDP ports)
            next_eth_payload[(50*8) +: (14*8)] = p_axis_tdata[0 +: (14*8)];
          end
          else begin
            // Saved 46 bytes, need at most 18 bytes (60 bytes IP header plus 4
            // bytes TCP/UDP ports)
            next_eth_payload[(46*8) +: (18*8)] = p_axis_tdata[0 +: (18*8)];
          end
        end

        next_vid_shift_reg[1]  = vid_shift_reg[0];
        next_eth_payload_valid = 1'b1;
        next_s1_state          = (p_axis_tlast) ? S_S1_IDLE : S_S1_PASS;
      end

      S_S1_PASS: begin
        if (p_axis_tvalid && p_axis_tlast && p_axis_tready) begin
          next_s1_state = S_S1_IDLE;
        end
      end
    endcase
  end

  always @(posedge aclk) begin
    if (~aresetn) begin
      vid_shift_reg[0]  <= 0;
      vid_shift_reg[1]  <= 0;
      eth_payload       <= 0;
      eth_payload_valid <= 1'b0;
      eth_type_is_ip4   <= 1'b0;
      eth_is_8021q      <= 1'b0;
      s1_state          <= S_S1_IDLE;
    end
    else begin
      vid_shift_reg[0]  <= next_vid_shift_reg[0];
      vid_shift_reg[1]  <= next_vid_shift_reg[1];
      eth_payload       <= next_eth_payload;
      eth_payload_valid <= next_eth_payload_valid;
      eth_type_is_ip4   <= next_eth_type_is_ip4;
      eth_is_8021q      <= next_eth_is_8021q;
      s1_state          <= next_s1_state;
    end
  end

  assign eth_type       = p_axis_tdata[(C_ETH_TYPE_OFFSET * 8) +: (C_ETH_TYPE_LEN * 8)];
  assign eth_8021q_type = p_axis_tdata[(C_ETH_8021Q_TYPE_OFFSET * 8) +: (C_ETH_8021Q_TYPE_LEN * 8)];
  assign eth_8021q_vid  = p_axis_tdata[(C_ETH_8021Q_TCI_OFFSET * 8) +: (C_ETH_8021Q_TCI_LEN * 8)] & C_ETH_8021Q_VID_MASK;

  // Stage 2: extract source/destination IP addresses and value of transport
  // layer protocol
  always @(posedge aclk) begin
    if (~aresetn) begin
      ip4_payload_valid <= 1'b0;
      ip4_payload       <= 0;
      ip4_proto         <= 0;
      ip4_src_addr      <= 0;
      ip4_dst_addr      <= 0;
    end
    else if (eth_payload_valid) begin
      ip4_payload_valid <= 1'b1;

      if (eth_type_is_ip4) begin
        ip4_proto    <= eth_payload[(C_IP4_PROTO_OFFSET * 8) +: (C_IP4_PROTO_LEN * 8)];
        ip4_src_addr <= eth_payload[(C_IP4_SRC_ADDR_OFFSET * 8) +: (C_IP4_SRC_ADDR_LEN * 8)];
        ip4_dst_addr <= eth_payload[(C_IP4_DST_ADDR_OFFSET * 8) +: (C_IP4_DST_ADDR_LEN * 8)];
      end
      else begin
        ip4_proto    <= 0;
        ip4_src_addr <= 0;
        ip4_dst_addr <= 0;
      end

      case (ip4_ihl)
        4'd5: begin
          ip4_payload <= eth_payload[(5*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd6: begin
          ip4_payload <= eth_payload[(6*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd7: begin
          ip4_payload <= eth_payload[(7*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd8: begin
          ip4_payload <= eth_payload[(8*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd9: begin
          ip4_payload <= eth_payload[(9*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd10: begin
          ip4_payload <= eth_payload[(10*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd11: begin
          ip4_payload <= eth_payload[(11*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd12: begin
          ip4_payload <= eth_payload[(12*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd13: begin
          ip4_payload <= eth_payload[(13*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd14: begin
          ip4_payload <= eth_payload[(14*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        4'd15: begin
          ip4_payload <= eth_payload[(15*32) +: (C_MAX_IP4_PAYLOAD_LEN*8)];
        end
        default: begin
          ip4_payload <= 0;
        end
      endcase
    end
    else begin
      ip4_payload_valid <= 1'b0;
    end
  end

  assign ip4_ihl   = eth_payload[(C_IP4_IHL_OFFSET * 8) +: (C_IP4_IHL_LEN * 8)] & C_IP4_IHL_MASK;
  assign ip4_tuple = {ip4_dst_addr, ip4_src_addr, ip4_proto};

  // Input to the Toeplitz hash function is organized as follows.
  //
  // MSB                                       LSB
  // DST_PORT SRC_PORT DST_ADDR SRC_ADDR PROTO VID
  //
  // Within each field, network byte order is used to avoid conversion.  Any
  // unmatched field will have a value of 0.  The computation starts as soon as
  // VID becomes available.
  // 
  // Offset of 32-bit window in hash key:
  //
  // VID      : 0  - 3
  // PROTO    : 4  - 11
  // SRC_ADDR : 12 - 43
  // DST_ADDR : 44 - 75
  // SRC_PORT : 76 - 91
  // DST_ADDR : 92 - 107

  function [31:0] get_hash_window;
    input         valid;
    input [319:0] key;
    input   [7:0] offset;
    begin
      get_hash_window = (valid) ? key[offset +: 32] : 0;
    end
  endfunction: get_hash_window

  always @(posedge aclk) begin
    if (~aresetn) begin
      vid_hash <= 0;
    end
    else if (ip4_payload_valid) begin
      vid_hash <= get_hash_window(vid_shift_reg[1][0], hash_key, 0) ^
                  get_hash_window(vid_shift_reg[1][1], hash_key, 1) ^
                  get_hash_window(vid_shift_reg[1][2], hash_key, 2) ^
                  get_hash_window(vid_shift_reg[1][3], hash_key, 3);
    end
  end

  always @(posedge aclk) begin
    if (~aresetn) begin
      ip4_hash[0] <= 0;
      ip4_hash[1] <= 0;
      ip4_hash[2] <= 0;
      ip4_hash[3] <= 0;
    end
    else if (ip4_payload_valid) begin
      ip4_hash[0] <= get_hash_window(ip4_tuple[0 + 0*18], hash_key, 4 + 0 + 0*18) ^
                     get_hash_window(ip4_tuple[1 + 0*18], hash_key, 4 + 1 + 0*18) ^
                     get_hash_window(ip4_tuple[2 + 0*18], hash_key, 4 + 2 + 0*18) ^
                     get_hash_window(ip4_tuple[3 + 0*18], hash_key, 4 + 3 + 0*18) ^
                     get_hash_window(ip4_tuple[4 + 0*18], hash_key, 4 + 4 + 0*18) ^
                     get_hash_window(ip4_tuple[5 + 0*18], hash_key, 4 + 5 + 0*18) ^
                     get_hash_window(ip4_tuple[6 + 0*18], hash_key, 4 + 6 + 0*18) ^
                     get_hash_window(ip4_tuple[7 + 0*18], hash_key, 4 + 7 + 0*18) ^
                     get_hash_window(ip4_tuple[8 + 0*18], hash_key, 4 + 8 + 0*18) ^
                     get_hash_window(ip4_tuple[9 + 0*18], hash_key, 4 + 9 + 0*18) ^
                     get_hash_window(ip4_tuple[10 + 0*18], hash_key, 4 + 10 + 0*18) ^
                     get_hash_window(ip4_tuple[11 + 0*18], hash_key, 4 + 11 + 0*18) ^
                     get_hash_window(ip4_tuple[12 + 0*18], hash_key, 4 + 12 + 0*18) ^
                     get_hash_window(ip4_tuple[13 + 0*18], hash_key, 4 + 13 + 0*18) ^
                     get_hash_window(ip4_tuple[14 + 0*18], hash_key, 4 + 14 + 0*18) ^
                     get_hash_window(ip4_tuple[15 + 0*18], hash_key, 4 + 15 + 0*18) ^
                     get_hash_window(ip4_tuple[16 + 0*18], hash_key, 4 + 16 + 0*18) ^
                     get_hash_window(ip4_tuple[17 + 0*18], hash_key, 4 + 17 + 0*18);
      ip4_hash[1] <= get_hash_window(ip4_tuple[0 + 1*18], hash_key, 4 + 0 + 1*18) ^
                     get_hash_window(ip4_tuple[1 + 1*18], hash_key, 4 + 1 + 1*18) ^
                     get_hash_window(ip4_tuple[2 + 1*18], hash_key, 4 + 2 + 1*18) ^
                     get_hash_window(ip4_tuple[3 + 1*18], hash_key, 4 + 3 + 1*18) ^
                     get_hash_window(ip4_tuple[4 + 1*18], hash_key, 4 + 4 + 1*18) ^
                     get_hash_window(ip4_tuple[5 + 1*18], hash_key, 4 + 5 + 1*18) ^
                     get_hash_window(ip4_tuple[6 + 1*18], hash_key, 4 + 6 + 1*18) ^
                     get_hash_window(ip4_tuple[7 + 1*18], hash_key, 4 + 7 + 1*18) ^
                     get_hash_window(ip4_tuple[8 + 1*18], hash_key, 4 + 8 + 1*18) ^
                     get_hash_window(ip4_tuple[9 + 1*18], hash_key, 4 + 9 + 1*18) ^
                     get_hash_window(ip4_tuple[10 + 1*18], hash_key, 4 + 10 + 1*18) ^
                     get_hash_window(ip4_tuple[11 + 1*18], hash_key, 4 + 11 + 1*18) ^
                     get_hash_window(ip4_tuple[12 + 1*18], hash_key, 4 + 12 + 1*18) ^
                     get_hash_window(ip4_tuple[13 + 1*18], hash_key, 4 + 13 + 1*18) ^
                     get_hash_window(ip4_tuple[14 + 1*18], hash_key, 4 + 14 + 1*18) ^
                     get_hash_window(ip4_tuple[15 + 1*18], hash_key, 4 + 15 + 1*18) ^
                     get_hash_window(ip4_tuple[16 + 1*18], hash_key, 4 + 16 + 1*18) ^
                     get_hash_window(ip4_tuple[17 + 1*18], hash_key, 4 + 17 + 1*18);
      ip4_hash[2] <= get_hash_window(ip4_tuple[0 + 2*18], hash_key, 4 + 0 + 2*18) ^
                     get_hash_window(ip4_tuple[1 + 2*18], hash_key, 4 + 1 + 2*18) ^
                     get_hash_window(ip4_tuple[2 + 2*18], hash_key, 4 + 2 + 2*18) ^
                     get_hash_window(ip4_tuple[3 + 2*18], hash_key, 4 + 3 + 2*18) ^
                     get_hash_window(ip4_tuple[4 + 2*18], hash_key, 4 + 4 + 2*18) ^
                     get_hash_window(ip4_tuple[5 + 2*18], hash_key, 4 + 5 + 2*18) ^
                     get_hash_window(ip4_tuple[6 + 2*18], hash_key, 4 + 6 + 2*18) ^
                     get_hash_window(ip4_tuple[7 + 2*18], hash_key, 4 + 7 + 2*18) ^
                     get_hash_window(ip4_tuple[8 + 2*18], hash_key, 4 + 8 + 2*18) ^
                     get_hash_window(ip4_tuple[9 + 2*18], hash_key, 4 + 9 + 2*18) ^
                     get_hash_window(ip4_tuple[10 + 2*18], hash_key, 4 + 10 + 2*18) ^
                     get_hash_window(ip4_tuple[11 + 2*18], hash_key, 4 + 11 + 2*18) ^
                     get_hash_window(ip4_tuple[12 + 2*18], hash_key, 4 + 12 + 2*18) ^
                     get_hash_window(ip4_tuple[13 + 2*18], hash_key, 4 + 13 + 2*18) ^
                     get_hash_window(ip4_tuple[14 + 2*18], hash_key, 4 + 14 + 2*18) ^
                     get_hash_window(ip4_tuple[15 + 2*18], hash_key, 4 + 15 + 2*18) ^
                     get_hash_window(ip4_tuple[16 + 2*18], hash_key, 4 + 16 + 2*18) ^
                     get_hash_window(ip4_tuple[17 + 2*18], hash_key, 4 + 17 + 2*18);
      ip4_hash[3] <= get_hash_window(ip4_tuple[0 + 3*18], hash_key, 4 + 0 + 3*18) ^
                     get_hash_window(ip4_tuple[1 + 3*18], hash_key, 4 + 1 + 3*18) ^
                     get_hash_window(ip4_tuple[2 + 3*18], hash_key, 4 + 2 + 3*18) ^
                     get_hash_window(ip4_tuple[3 + 3*18], hash_key, 4 + 3 + 3*18) ^
                     get_hash_window(ip4_tuple[4 + 3*18], hash_key, 4 + 4 + 3*18) ^
                     get_hash_window(ip4_tuple[5 + 3*18], hash_key, 4 + 5 + 3*18) ^
                     get_hash_window(ip4_tuple[6 + 3*18], hash_key, 4 + 6 + 3*18) ^
                     get_hash_window(ip4_tuple[7 + 3*18], hash_key, 4 + 7 + 3*18) ^
                     get_hash_window(ip4_tuple[8 + 3*18], hash_key, 4 + 8 + 3*18) ^
                     get_hash_window(ip4_tuple[9 + 3*18], hash_key, 4 + 9 + 3*18) ^
                     get_hash_window(ip4_tuple[10 + 3*18], hash_key, 4 + 10 + 3*18) ^
                     get_hash_window(ip4_tuple[11 + 3*18], hash_key, 4 + 11 + 3*18) ^
                     get_hash_window(ip4_tuple[12 + 3*18], hash_key, 4 + 12 + 3*18) ^
                     get_hash_window(ip4_tuple[13 + 3*18], hash_key, 4 + 13 + 3*18) ^
                     get_hash_window(ip4_tuple[14 + 3*18], hash_key, 4 + 14 + 3*18) ^
                     get_hash_window(ip4_tuple[15 + 3*18], hash_key, 4 + 15 + 3*18) ^
                     get_hash_window(ip4_tuple[16 + 3*18], hash_key, 4 + 16 + 3*18) ^
                     get_hash_window(ip4_tuple[17 + 3*18], hash_key, 4 + 17 + 3*18);
    end
  end

  always @(posedge aclk) begin
    if (~aresetn) begin
      port_hash[0] <= 0;
      port_hash[1] <= 0;
    end
    else if (ip4_payload_valid) begin
      port_hash[0] <= get_hash_window(ip4_payload[0 + 0*16], hash_key, 76 + 0 + 0*16) ^
                      get_hash_window(ip4_payload[1 + 0*16], hash_key, 76 + 1 + 0*16) ^
                      get_hash_window(ip4_payload[2 + 0*16], hash_key, 76 + 2 + 0*16) ^
                      get_hash_window(ip4_payload[3 + 0*16], hash_key, 76 + 3 + 0*16) ^
                      get_hash_window(ip4_payload[4 + 0*16], hash_key, 76 + 4 + 0*16) ^
                      get_hash_window(ip4_payload[5 + 0*16], hash_key, 76 + 5 + 0*16) ^
                      get_hash_window(ip4_payload[6 + 0*16], hash_key, 76 + 6 + 0*16) ^
                      get_hash_window(ip4_payload[7 + 0*16], hash_key, 76 + 7 + 0*16) ^
                      get_hash_window(ip4_payload[8 + 0*16], hash_key, 76 + 8 + 0*16) ^
                      get_hash_window(ip4_payload[9 + 0*16], hash_key, 76 + 9 + 0*16) ^
                      get_hash_window(ip4_payload[10 + 0*16], hash_key, 76 + 10 + 0*16) ^
                      get_hash_window(ip4_payload[11 + 0*16], hash_key, 76 + 11 + 0*16) ^
                      get_hash_window(ip4_payload[12 + 0*16], hash_key, 76 + 12 + 0*16) ^
                      get_hash_window(ip4_payload[13 + 0*16], hash_key, 76 + 13 + 0*16) ^
                      get_hash_window(ip4_payload[14 + 0*16], hash_key, 76 + 14 + 0*16) ^
                      get_hash_window(ip4_payload[15 + 0*16], hash_key, 76 + 15 + 0*16);
      port_hash[1] <= get_hash_window(ip4_payload[0 + 1*16], hash_key, 76 + 0 + 1*16) ^
                      get_hash_window(ip4_payload[1 + 1*16], hash_key, 76 + 1 + 1*16) ^
                      get_hash_window(ip4_payload[2 + 1*16], hash_key, 76 + 2 + 1*16) ^
                      get_hash_window(ip4_payload[3 + 1*16], hash_key, 76 + 3 + 1*16) ^
                      get_hash_window(ip4_payload[4 + 1*16], hash_key, 76 + 4 + 1*16) ^
                      get_hash_window(ip4_payload[5 + 1*16], hash_key, 76 + 5 + 1*16) ^
                      get_hash_window(ip4_payload[6 + 1*16], hash_key, 76 + 6 + 1*16) ^
                      get_hash_window(ip4_payload[7 + 1*16], hash_key, 76 + 7 + 1*16) ^
                      get_hash_window(ip4_payload[8 + 1*16], hash_key, 76 + 8 + 1*16) ^
                      get_hash_window(ip4_payload[9 + 1*16], hash_key, 76 + 9 + 1*16) ^
                      get_hash_window(ip4_payload[10 + 1*16], hash_key, 76 + 10 + 1*16) ^
                      get_hash_window(ip4_payload[11 + 1*16], hash_key, 76 + 11 + 1*16) ^
                      get_hash_window(ip4_payload[12 + 1*16], hash_key, 76 + 12 + 1*16) ^
                      get_hash_window(ip4_payload[13 + 1*16], hash_key, 76 + 13 + 1*16) ^
                      get_hash_window(ip4_payload[14 + 1*16], hash_key, 76 + 14 + 1*16) ^
                      get_hash_window(ip4_payload[15 + 1*16], hash_key, 76 + 15 + 1*16);
    end
  end

  // Hash result will be ready one cycle after extracting IPv4 payload, and is
  // used to query the indirection table
  always @(posedge aclk) begin
    if (~aresetn) begin
      hash_result_valid <= 1'b0;
    end
    else begin
      hash_result_valid <= ip4_payload_valid;
    end
  end

  assign hash_result = vid_hash ^ ip4_hash[0] ^ ip4_hash[1] ^ ip4_hash[2] ^ ip4_hash[3] ^ port_hash[0] ^ port_hash[1];

endmodule: qdma_subsystem_hash
