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
// This module delays the input stream for a single cycle.  It provides two
// working mode: fully-registered mode and forward-only mode, specified using
// the mode string "full" and "forward" respectively.
//
// The fully-registered mode completely isolates the slave and master interface
// from a timing perspective.  It uses two sets of registers, one of which
// buffers data when back-pressure happens.  All the output signals are driven
// by flip-flops.
//
// The forward-only mode uses only one set of registers.  Its `s_axis_tready` is
// driven by combinational logic derived from `m_axis_tready` and internal
// state.  This mode makes it more likely to create a long, timing-critical,
// combinational path on `m_axis_tready`.  Hence, it probably should be used in
// regions with relaxed slack, or in the case that a single cycle delay is
// needed for synchronization purpose.
`timescale 1ns/1ps
module axi_stream_register_slice #(
  parameter int TDATA_W = 512,
  parameter int TID_W   = 8,
  parameter int TDEST_W = 4,
  parameter int TUSER_W = 8,
  parameter     MODE    = "full"
) (
  input                    s_axis_tvalid,
  input      [TDATA_W-1:0] s_axis_tdata,
  input  [(TDATA_W/8)-1:0] s_axis_tkeep,
  input                    s_axis_tlast,
  input        [TID_W-1:0] s_axis_tid,
  input      [TDEST_W-1:0] s_axis_tdest,
  input      [TUSER_W-1:0] s_axis_tuser,
  output                   s_axis_tready,

  output                   m_axis_tvalid,
  output     [TDATA_W-1:0] m_axis_tdata,
  output [(TDATA_W/8)-1:0] m_axis_tkeep,
  output                   m_axis_tlast,
  output       [TID_W-1:0] m_axis_tid,
  output     [TDEST_W-1:0] m_axis_tdest,
  output     [TUSER_W-1:0] m_axis_tuser,
  input                    m_axis_tready,

  input                    aclk,
  input                    aresetn
);

  // Parameter DRC
  initial begin
    if (MODE != "full" && MODE != "forward") begin
      $fatal("[%m] Unknown mode %s", MODE);
    end
  end

  generate if (MODE == "forward") begin: forward_mode
    reg     [TDATA_W-1:0] axis_tdata;
    reg [(TDATA_W/8)-1:0] axis_tkeep;
    reg                   axis_tlast;
    reg     [TUSER_W-1:0] axis_tuser;
    reg       [TID_W-1:0] axis_tid;
    reg     [TDEST_W-1:0] axis_tdest;

    reg                   filled;

    assign s_axis_tready = ~filled || m_axis_tready;
    assign m_axis_tvalid = filled;
    assign m_axis_tdata  = axis_tdata;
    assign m_axis_tkeep  = axis_tkeep;
    assign m_axis_tlast  = axis_tlast;
    assign m_axis_tuser  = axis_tuser;
    assign m_axis_tid    = axis_tid;
    assign m_axis_tdest  = axis_tdest;

    always @(posedge aclk) begin
      if (~aresetn) begin
        axis_tdata <= 0;
        axis_tkeep <= 0;
        axis_tlast <= 1'b0;
        axis_tuser <= 0;
        axis_tid   <= 0;
        axis_tdest <= 0;

        filled     <= 1'b0;
      end
      else begin
        case (filled)
          1'b0: begin
            if (s_axis_tvalid) begin
              axis_tdata <= s_axis_tdata;
              axis_tkeep <= s_axis_tkeep;
              axis_tlast <= s_axis_tlast;
              axis_tuser <= s_axis_tuser;
              axis_tid   <= s_axis_tid;
              axis_tdest <= s_axis_tdest;
              filled     <= 1'b1;
            end
          end

          1'b1: begin
            if (s_axis_tvalid && m_axis_tready) begin
              axis_tdata <= s_axis_tdata;
              axis_tkeep <= s_axis_tkeep;
              axis_tlast <= s_axis_tlast;
              axis_tuser <= s_axis_tuser;
              axis_tid   <= s_axis_tid;
              axis_tdest <= s_axis_tdest;
            end
            else if (~s_axis_tvalid && m_axis_tready) begin
              filled <= 1'b0;
            end
          end
        endcase
      end
    end
  end: forward_mode
  else begin: full_mode
    reg     [TDATA_W-1:0] axis_tdata[0:1];
    reg [(TDATA_W/8)-1:0] axis_tkeep[0:1];
    reg                   axis_tlast[0:1];
    reg     [TUSER_W-1:0] axis_tuser[0:1];
    reg       [TID_W-1:0] axis_tid[0:1];
    reg     [TDEST_W-1:0] axis_tdest[0:1];

    reg             [1:0] filled;
    
    assign s_axis_tready = ~filled[1];
    assign m_axis_tvalid = filled[0];
    assign m_axis_tdata  = axis_tdata[0];
    assign m_axis_tkeep  = axis_tkeep[0];
    assign m_axis_tlast  = axis_tlast[0];
    assign m_axis_tuser  = axis_tuser[0];
    assign m_axis_tid    = axis_tid[0];
    assign m_axis_tdest  = axis_tdest[0];

    always @(posedge aclk) begin
      if (~aresetn) begin
        axis_tdata[0] <= 0;
        axis_tkeep[0] <= 0;
        axis_tlast[0] <= 1'b0;
        axis_tuser[0] <= 0;
        axis_tid[0]   <= 0;
        axis_tdest[0] <= 0;

        axis_tdata[1] <= 0;
        axis_tkeep[1] <= 0;
        axis_tlast[1] <= 1'b0;
        axis_tuser[1] <= 0;
        axis_tid[1]   <= 0;
        axis_tdest[1] <= 0;

        filled <= 2'b00;
      end
      else begin
        case (filled)
          2'b00: begin
            if (s_axis_tvalid) begin
              axis_tdata[0] <= s_axis_tdata;
              axis_tkeep[0] <= s_axis_tkeep;
              axis_tlast[0] <= s_axis_tlast;
              axis_tuser[0] <= s_axis_tuser;
              axis_tid[0]   <= s_axis_tid;
              axis_tdest[0] <= s_axis_tdest;
              filled        <= 2'b01;
            end
          end

          2'b01: begin
            if (s_axis_tvalid && m_axis_tready) begin
              axis_tdata[0] <= s_axis_tdata;
              axis_tkeep[0] <= s_axis_tkeep;
              axis_tlast[0] <= s_axis_tlast;
              axis_tuser[0] <= s_axis_tuser;
              axis_tid[0]   <= s_axis_tid;
              axis_tdest[0] <= s_axis_tdest;
            end
            else if (s_axis_tvalid && ~m_axis_tready) begin
              axis_tdata[1] <= s_axis_tdata;
              axis_tkeep[1] <= s_axis_tkeep;
              axis_tlast[1] <= s_axis_tlast;
              axis_tuser[1] <= s_axis_tuser;
              axis_tid[1]   <= s_axis_tid;
              axis_tdest[1] <= s_axis_tdest;
              filled        <= 2'b11;
            end
            else if (~s_axis_tvalid && m_axis_tready) begin
              filled <= 2'b00;
            end
          end

          2'b11: begin
            if (m_axis_tready) begin
              axis_tdata[0] <= axis_tdata[1];
              axis_tkeep[0] <= axis_tkeep[1];
              axis_tlast[0] <= axis_tlast[1];
              axis_tuser[0] <= axis_tuser[1];
              axis_tid[0]   <= axis_tid[1];
              axis_tdest[0] <= axis_tdest[1];
              filled        <= 2'b01;
            end
          end

          default: begin
            filled <= 2'b00;
          end
        endcase
      end
    end
  end
  endgenerate

endmodule: axi_stream_register_slice
