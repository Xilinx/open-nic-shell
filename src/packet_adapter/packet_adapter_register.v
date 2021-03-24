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
// Address range:
//   - 0x3000 - 0x3FFF (CMAC0)
//   - 0x7000 - 0x7FFF (CMAC1)
// Address width: 12-bit
//
// Register description
// -----------------------------------------------------------------------------
//  Address | Mode |  Description
// -----------------------------------------------------------------------------
//   0x000  |  RO  |  Number of TX packets sent
//   0x004  |      |
// -----------------------------------------------------------------------------
//   0x008  |  RO  |  Number of TX bytes sent
//   0x00C  |      |
// -----------------------------------------------------------------------------
//   0x010  |  RO  |  Number of TX packets dropped
//   0x014  |      |
// -----------------------------------------------------------------------------
//   0x018  |  RO  |  Number of TX bytes dropped
//   0x01C  |      |
// -----------------------------------------------------------------------------
//   0x020  |  RO  |  Number of RX packets received
//   0x024  |      |
// -----------------------------------------------------------------------------
//   0x028  |  RO  |  Number of RX bytes received
//   0x02C  |      |
// -----------------------------------------------------------------------------
//   0x030  |  RO  |  Number of RX packets dropped
//   0x034  |      |
// -----------------------------------------------------------------------------
//   0x038  |  RO  |  Number of RX bytes dropped
//   0x03C  |      |
// -----------------------------------------------------------------------------
//   0x040  |  RO  |  Number of RX packets marked with error
//   0x044  |      |
// -----------------------------------------------------------------------------
//   0x048  |  RO  |  Number of RX bytes marked with error
//   0x04C  |      |
// -----------------------------------------------------------------------------
`timescale 1ns/1ps
module packet_adapter_register (
  input         s_axil_awvalid,
  input  [31:0] s_axil_awaddr,
  output        s_axil_awready,
  input         s_axil_wvalid,
  input  [31:0] s_axil_wdata,
  output        s_axil_wready,
  output        s_axil_bvalid,
  output  [1:0] s_axil_bresp,
  input         s_axil_bready,
  input         s_axil_arvalid,
  input  [31:0] s_axil_araddr,
  output        s_axil_arready,
  output        s_axil_rvalid,
  output [31:0] s_axil_rdata,
  output  [1:0] s_axil_rresp,
  input         s_axil_rready,

  // Synchronized to axis_aclk
  input         tx_pkt_sent,
  input         tx_pkt_drop,
  input  [15:0] tx_bytes,

  // Synchronized to axis_aclk
  input         rx_pkt_recv,
  input         rx_pkt_drop,
  input         rx_pkt_err,
  input  [15:0] rx_bytes,

  input         axil_aclk,
  input         axis_aclk,
  input         axil_aresetn
);

  localparam C_ADDR_W = 12;

  // Register address
  localparam REG_TX_PKTS_SENT_LOWER  = 12'h000;
  localparam REG_TX_PKTS_SENT_UPPER  = 12'h004;
  localparam REG_TX_BYTES_SENT_LOWER = 12'h008;
  localparam REG_TX_BYTES_SENT_UPPER = 12'h00C;

  localparam REG_TX_PKTS_DROP_LOWER  = 12'h010;
  localparam REG_TX_PKTS_DROP_UPPER  = 12'h014;
  localparam REG_TX_BYTES_DROP_LOWER = 12'h018;
  localparam REG_TX_BYTES_DROP_UPPER = 12'h01C;

  localparam REG_RX_PKTS_RECV_LOWER  = 12'h020;
  localparam REG_RX_PKTS_RECV_UPPER  = 12'h024;
  localparam REG_RX_BYTES_RECV_LOWER = 12'h028;
  localparam REG_RX_BYTES_RECV_UPPER = 12'h02C;

  localparam REG_RX_PKTS_DROP_LOWER  = 12'h030;
  localparam REG_RX_PKTS_DROP_UPPER  = 12'h034;
  localparam REG_RX_BYTES_DROP_LOWER = 12'h038;
  localparam REG_RX_BYTES_DROP_UPPER = 12'h03C;

  localparam REG_RX_PKTS_ERR_LOWER   = 12'h040;
  localparam REG_RX_PKTS_ERR_UPPER   = 12'h044;
  localparam REG_RX_BYTES_ERR_LOWER  = 12'h048;
  localparam REG_RX_BYTES_ERR_UPPER  = 12'h04C;

  reg          [63:0] reg_tx_pkts_sent;
  reg          [63:0] reg_tx_bytes_sent;
  reg          [63:0] reg_tx_pkts_drop;
  reg          [63:0] reg_tx_bytes_drop;
  reg          [63:0] reg_rx_pkts_recv;
  reg          [63:0] reg_rx_bytes_recv;
  reg          [63:0] reg_rx_pkts_drop;
  reg          [63:0] reg_rx_bytes_drop;
  reg          [63:0] reg_rx_pkts_err;
  reg          [63:0] reg_rx_bytes_err;

  wire                reg_en;
  wire                reg_we;
  wire [C_ADDR_W-1:0] reg_addr;
  wire         [31:0] reg_din;
  reg          [31:0] reg_dout;

  axi_lite_register #(
    .CLOCKING_MODE ("common_clock"),
    .ADDR_W        (C_ADDR_W),
    .DATA_W        (32)
  ) axil_reg_inst (
    .s_axil_awvalid (s_axil_awvalid),
    .s_axil_awaddr  (s_axil_awaddr),
    .s_axil_awready (s_axil_awready),
    .s_axil_wvalid  (s_axil_wvalid),
    .s_axil_wdata   (s_axil_wdata),
    .s_axil_wready  (s_axil_wready),
    .s_axil_bvalid  (s_axil_bvalid),
    .s_axil_bresp   (s_axil_bresp),
    .s_axil_bready  (s_axil_bready),
    .s_axil_arvalid (s_axil_arvalid),
    .s_axil_araddr  (s_axil_araddr),
    .s_axil_arready (s_axil_arready),
    .s_axil_rvalid  (s_axil_rvalid),
    .s_axil_rdata   (s_axil_rdata),
    .s_axil_rresp   (s_axil_rresp),
    .s_axil_rready  (s_axil_rready),

    .reg_en         (reg_en),
    .reg_we         (reg_we),
    .reg_addr       (reg_addr),
    .reg_din        (reg_din),
    .reg_dout       (reg_dout),

    .axil_aclk      (axil_aclk),
    .axil_aresetn   (axil_aresetn),
    .reg_clk        (axil_aclk),
    .reg_rstn       (axil_aresetn)
  );

  always @(posedge axil_aclk) begin
    if (~axil_aresetn) begin
      reg_dout <= 0;
    end
    else if (reg_en && ~reg_we) begin
      case (reg_addr)
        REG_TX_PKTS_SENT_LOWER: begin
          reg_dout <= reg_tx_pkts_sent[31:0];
        end
        REG_TX_PKTS_SENT_UPPER: begin
          reg_dout <= reg_tx_pkts_sent[63:32];
        end
        REG_TX_BYTES_SENT_LOWER: begin
          reg_dout <= reg_tx_bytes_sent[31:0];
        end
        REG_TX_BYTES_SENT_UPPER: begin
          reg_dout <= reg_tx_bytes_sent[63:32];
        end
        REG_TX_PKTS_DROP_LOWER: begin
          reg_dout <= reg_tx_pkts_drop[31:0];
        end
        REG_TX_PKTS_DROP_UPPER: begin
          reg_dout <= reg_tx_pkts_drop[63:32];
        end
        REG_TX_BYTES_DROP_LOWER: begin
          reg_dout <= reg_tx_bytes_drop[31:0];
        end
        REG_TX_BYTES_DROP_UPPER: begin
          reg_dout <= reg_tx_bytes_drop[63:32];
        end
        REG_RX_PKTS_RECV_LOWER: begin
          reg_dout <= reg_rx_pkts_recv[31:0];
        end
        REG_RX_PKTS_RECV_UPPER: begin
          reg_dout <= reg_rx_pkts_recv[63:32];
        end
        REG_RX_BYTES_RECV_LOWER: begin
          reg_dout <= reg_rx_bytes_recv[31:0];
        end
        REG_RX_BYTES_RECV_UPPER: begin
          reg_dout <= reg_rx_bytes_recv[63:32];
        end
        REG_RX_PKTS_DROP_LOWER: begin
          reg_dout <= reg_rx_pkts_drop[31:0];
        end
        REG_RX_PKTS_DROP_UPPER: begin
          reg_dout <= reg_rx_pkts_drop[63:32];
        end
        REG_RX_BYTES_DROP_LOWER: begin
          reg_dout <= reg_rx_bytes_drop[31:0];
        end
        REG_RX_BYTES_DROP_UPPER: begin
          reg_dout <= reg_rx_bytes_drop[63:32];
        end
        REG_RX_PKTS_ERR_LOWER: begin
          reg_dout <= reg_rx_pkts_err[31:0];
        end
        REG_RX_PKTS_ERR_UPPER: begin
          reg_dout <= reg_rx_pkts_err[63:32];
        end
        REG_RX_BYTES_ERR_LOWER: begin
          reg_dout <= reg_rx_bytes_err[31:0];
        end
        REG_RX_BYTES_ERR_UPPER: begin
          reg_dout <= reg_rx_bytes_err[63:32];
        end
        default: begin
          reg_dout <= 32'hDEADBEEF;
        end
      endcase
    end
  end

  always @(posedge axis_aclk) begin
    if (~axil_aresetn) begin
      reg_tx_pkts_sent  <= 0;
      reg_tx_bytes_sent <= 0;
    end
    else if (tx_pkt_sent) begin
      reg_tx_pkts_sent  <= reg_tx_pkts_sent + 1;
      reg_tx_bytes_sent <= reg_tx_bytes_sent + tx_bytes;
    end
  end

  always @(posedge axis_aclk) begin
    if (~axil_aresetn) begin
      reg_tx_pkts_drop  <= 0;
      reg_tx_bytes_drop <= 0;
    end
    else if (tx_pkt_drop) begin
      reg_tx_pkts_drop  <= reg_tx_pkts_drop + 1;
      reg_tx_bytes_drop <= reg_tx_bytes_drop + tx_bytes;
    end
  end

  always @(posedge axis_aclk) begin
    if (~axil_aresetn) begin
      reg_rx_pkts_recv  <= 0;
      reg_rx_bytes_recv <= 0;
    end
    else if (rx_pkt_recv) begin
      reg_rx_pkts_recv  <= reg_rx_pkts_recv + 1;
      reg_rx_bytes_recv <= reg_rx_bytes_recv + rx_bytes;
    end
  end

  always @(posedge axis_aclk) begin
    if (~axil_aresetn) begin
      reg_rx_pkts_drop  <= 0;
      reg_rx_bytes_drop <= 0;
    end
    else if (rx_pkt_drop) begin
      reg_rx_pkts_drop  <= reg_rx_pkts_drop + 1;
      reg_rx_bytes_drop <= reg_rx_bytes_drop + rx_bytes;
    end
  end

  always @(posedge axis_aclk) begin
    if (~axil_aresetn) begin
      reg_rx_pkts_err  <= 0;
      reg_rx_bytes_err <= 0;
    end
    else if (rx_pkt_err) begin
      reg_rx_pkts_err  <= reg_rx_pkts_err + 1;
      reg_rx_bytes_err <= reg_rx_bytes_err + rx_bytes;
    end
  end

endmodule: packet_adapter_register
