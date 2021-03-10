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
// This module synchronizes a single-bit level trigger and optionally a set of
// data, across two different clock domains.  It is guaranteed that the pulse
// generated in the source clock domain is propogated to the destination clock
// domain with the same width.  A common usecase is to synchronize counter
// increment signal from a different clock domain.
// 
// The implementation uses an asynchronous FIFO.  The depth should be large
// enough so that no event in the source domain will be missed.  When
// `src_valid` is asserted while the FIFO is full, `src_miss` will be asserted
// indicating the event is missed.
module level_trigger_cdc #(
  parameter int DATA_W     = 32,
  parameter int FIFO_DEPTH = 64
) (
  input               src_valid,
  input  [DATA_W-1:0] src_data,
  output              src_miss,
  output              dst_valid,
  output [DATA_W-1:0] dst_data,

  input               src_clk,
  input               dst_clk,
  input               src_rstn
);

  localparam C_FIFO_DATA_W = (DATA_W == 0) ? 1 : DATA_W;

  wire                     fifo_wr_en;
  wire [C_FIFO_DATA_W-1:0] fifo_din;
  wire                     fifo_rd_en;
  wire [C_FIFO_DATA_W-1:0] fifo_dout;
  wire                     fifo_empty;
  wire                     fifo_full;

  xpm_fifo_async #(
    .DOUT_RESET_VALUE    ("0"),
    .ECC_MODE            ("no_ecc"),
    .FIFO_MEMORY_TYPE    ("auto"),
    .FIFO_READ_LATENCY   (0),
    .FIFO_WRITE_DEPTH    (FIFO_DEPTH),
    .READ_DATA_WIDTH     (C_FIFO_DATA_W),
    .READ_MODE           ("fwft"),
    .WRITE_DATA_WIDTH    (C_FIFO_DATA_W),
    .CDC_SYNC_STAGES     (2)
  ) fifo_inst (
    .wr_en         (fifo_wr_en),
    .din           (fifo_din),
    .wr_ack        (),
    .rd_en         (fifo_rd_en),
    .data_valid    (),
    .dout          (fifo_dout),

    .wr_data_count (),
    .rd_data_count (),

    .empty         (fifo_empty),
    .full          (fifo_full),
    .almost_empty  (),
    .almost_full   (),
    .overflow      (),
    .underflow     (),
    .prog_empty    (),
    .prog_full     (),
    .sleep         (1'b0),

    .sbiterr       (),
    .dbiterr       (),
    .injectsbiterr (1'b0),
    .injectdbiterr (1'b0),

    .wr_clk        (src_clk),
    .rd_clk        (dst_clk),
    .rst           (~src_rstn),
    .rd_rst_busy   (),
    .wr_rst_busy   ()
  );

  assign fifo_wr_en = src_valid;
  assign fifo_din   = (DATA_W == 0) ? 1'b0 : src_data;
  assign fifo_rd_en = ~fifo_empty;
  assign src_miss   = fifo_full & src_valid;
  assign dst_valid  = ~fifo_empty;
  assign dst_data   = (DATA_W == 0) ? 1'b0 : fifo_dout;

endmodule: level_trigger_cdc
