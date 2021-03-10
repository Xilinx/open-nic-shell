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
`timescale 1ns/1ps
module axi_stream_packet_fifo #(
  parameter     CLOCKING_MODE       = "common_clock",
  parameter     FIFO_MEMORY_TYPE    = "auto",
  parameter int FIFO_DEPTH          = 2048,
  parameter int TDATA_WIDTH         = 32,
  parameter int TID_WIDTH           = 1,
  parameter int TDEST_WIDTH         = 1,
  parameter int TUSER_WIDTH         = 1,
  parameter int SIM_ASSERT_CHK      = 0,
  parameter int CASCADE_HEIGHT      = 0,
  parameter     ECC_MODE            = "no_ecc",
  parameter int RELATED_CLOCKS      = 0,
  parameter     USE_ADV_FEATURES    = "1000",
  parameter int WR_DATA_COUNT_WIDTH = 1,
  parameter int RD_DATA_COUNT_WIDTH = 1,
  parameter int PROG_FULL_THRESH    = 10,
  parameter int PROG_EMPTY_THRESH   = 10,
  parameter int CDC_SYNC_STAGES     = 2
) (
  input                            s_axis_tvalid,
  output                           s_axis_tready,
  input          [TDATA_WIDTH-1:0] s_axis_tdata,
  input        [TDATA_WIDTH/8-1:0] s_axis_tstrb,
  input        [TDATA_WIDTH/8-1:0] s_axis_tkeep,
  input                            s_axis_tlast,
  input            [TID_WIDTH-1:0] s_axis_tid,
  input          [TDEST_WIDTH-1:0] s_axis_tdest,
  input          [TUSER_WIDTH-1:0] s_axis_tuser,
  
  output                           m_axis_tvalid,
  input                            m_axis_tready,
  output         [TDATA_WIDTH-1:0] m_axis_tdata,
  output       [TDATA_WIDTH/8-1:0] m_axis_tstrb,
  output       [TDATA_WIDTH/8-1:0] m_axis_tkeep,
  output                           m_axis_tlast,
  output           [TID_WIDTH-1:0] m_axis_tid,
  output         [TDEST_WIDTH-1:0] m_axis_tdest,
  output         [TUSER_WIDTH-1:0] m_axis_tuser,
  
  output                           prog_full_axis,
  output [WR_DATA_COUNT_WIDTH-1:0] wr_data_count_axis,
  output                           almost_full_axis,
  output                           prog_empty_axis,
  output [RD_DATA_COUNT_WIDTH-1:0] rd_data_count_axis,
  output                           almost_empty_axis,

  input                            injectsbiterr_axis,
  input                            injectdbiterr_axis,
  output                           sbiterr_axis,
  output                           dbiterr_axis,

  input                            s_aresetn,
  input                            s_aclk,
  input                            m_aclk
);

  wire                       axis_tvalid;
  wire                       axis_tready;
  wire     [TDATA_WIDTH-1:0] axis_tdata;
  wire   [TDATA_WIDTH/8-1:0] axis_tstrb;
  wire   [TDATA_WIDTH/8-1:0] axis_tkeep;
  wire                       axis_tlast;
  wire       [TID_WIDTH-1:0] axis_tid;
  wire     [TDEST_WIDTH-1:0] axis_tdest;
  wire     [TUSER_WIDTH-1:0] axis_tuser;

  wire                       m_aresetn;

  wire                       enq_pkt;
  wire                       enq_pkt_sync;
  wire                       deq_pkt;
  reg [$clog2(FIFO_DEPTH):0] pkt_cnt;

  xpm_fifo_axis #(
    .CLOCKING_MODE       (CLOCKING_MODE),
    .FIFO_MEMORY_TYPE    (FIFO_MEMORY_TYPE),
    .PACKET_FIFO         ("false"),
    .FIFO_DEPTH          (FIFO_DEPTH),
    .TDATA_WIDTH         (TDATA_WIDTH),
    .TID_WIDTH           (TID_WIDTH),
    .TDEST_WIDTH         (TDEST_WIDTH),
    .TUSER_WIDTH         (TUSER_WIDTH),
    .SIM_ASSERT_CHK      (SIM_ASSERT_CHK),
    .CASCADE_HEIGHT      (CASCADE_HEIGHT),
    .ECC_MODE            (ECC_MODE),
    .RELATED_CLOCKS      (RELATED_CLOCKS),
    .USE_ADV_FEATURES    (USE_ADV_FEATURES),
    .WR_DATA_COUNT_WIDTH (WR_DATA_COUNT_WIDTH),
    .RD_DATA_COUNT_WIDTH (RD_DATA_COUNT_WIDTH),
    .PROG_FULL_THRESH    (PROG_FULL_THRESH),
    .PROG_EMPTY_THRESH   (PROG_EMPTY_THRESH),
    .CDC_SYNC_STAGES     (CDC_SYNC_STAGES)
  ) fifo_inst (
    .s_axis_tvalid      (s_axis_tvalid),
    .s_axis_tdata       (s_axis_tdata),
    .s_axis_tdest       (s_axis_tdest),
    .s_axis_tid         (s_axis_tid),
    .s_axis_tkeep       (s_axis_tkeep),
    .s_axis_tstrb       (s_axis_tstrb),
    .s_axis_tlast       (s_axis_tlast),
    .s_axis_tuser       (s_axis_tuser),
    .s_axis_tready      (s_axis_tready),

    .m_axis_tvalid      (axis_tvalid),
    .m_axis_tdata       (axis_tdata),
    .m_axis_tdest       (axis_tdest),
    .m_axis_tid         (axis_tid),
    .m_axis_tkeep       (axis_tkeep),
    .m_axis_tstrb       (axis_tstrb),
    .m_axis_tlast       (axis_tlast),
    .m_axis_tuser       (axis_tuser),
    .m_axis_tready      (axis_tready),

    .almost_empty_axis  (almost_empty_axis),
    .prog_empty_axis    (prog_empty_axis),
    .almost_full_axis   (almost_full_axis),
    .prog_full_axis     (prog_full_axis),
    .wr_data_count_axis (wr_data_count_axis),
    .rd_data_count_axis (rd_data_count_axis),

    .injectsbiterr_axis (injectsbiterr_axis),
    .injectdbiterr_axis (injectdbiterr_axis),
    .sbiterr_axis       (sbiterr_axis),
    .dbiterr_axis       (dbiterr_axis),

    .s_aclk             (s_aclk),
    .m_aclk             (m_aclk),
    .s_aresetn          (s_aresetn)
  );

  assign m_axis_tvalid = (pkt_cnt > 0) ? axis_tvalid : 1'b0;
  assign m_axis_tdata  = axis_tdata;
  assign m_axis_tdest  = axis_tdest;
  assign m_axis_tid    = axis_tid;
  assign m_axis_tkeep  = axis_tkeep;
  assign m_axis_tstrb  = axis_tstrb;
  assign m_axis_tlast  = axis_tlast;
  assign m_axis_tuser  = axis_tuser;
  assign axis_tready   = (pkt_cnt > 0) ? m_axis_tready : 1'b0;

  assign enq_pkt = s_axis_tvalid && s_axis_tlast && s_axis_tready;
  assign deq_pkt = m_axis_tvalid && m_axis_tlast && m_axis_tready;

  generate if (CLOCKING_MODE == "independent_clock") begin
    wire enq_pkt_fifo_wr_en;
    wire enq_pkt_fifo_din;
    wire enq_pkt_fifo_rd_en;
    wire enq_pkt_fifo_empty;

    xpm_cdc_single #(
      .DEST_SYNC_FF (CDC_SYNC_STAGES)
    ) m_aresetn_cdc_inst (
      .dest_clk (m_aclk),
      .dest_out (m_aresetn),
      .src_clk  (s_aclk),
      .src_in   (s_aresetn)
    );

    xpm_fifo_async #(
      .DOUT_RESET_VALUE    ("0"),
      .ECC_MODE            ("no_ecc"),
      .FIFO_MEMORY_TYPE    ("auto"),
      .FIFO_READ_LATENCY   (0),
      .FIFO_WRITE_DEPTH    (16),
      .READ_DATA_WIDTH     (1),
      .READ_MODE           ("fwft"),
      .WRITE_DATA_WIDTH    (1),
      .CDC_SYNC_STAGES     (CDC_SYNC_STAGES)
    ) enq_pkt_cdc_inst (
      .wr_en         (enq_pkt_fifo_wr_en),
      .din           (enq_pkt_fifo_din),
      .wr_ack        (),
      .rd_en         (enq_pkt_fifo_rd_en),
      .data_valid    (),
      .dout          (),

      .wr_data_count (),
      .rd_data_count (),

      .empty         (enq_pkt_fifo_empty),
      .full          (),
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

      .wr_clk        (s_aclk),
      .rd_clk        (m_aclk),
      .rst           (~s_aresetn),
      .rd_rst_busy   (),
      .wr_rst_busy   ()
    );

    assign enq_pkt_fifo_wr_en = enq_pkt;
    assign enq_pkt_fifo_din   = enq_pkt;
    assign enq_pkt_fifo_rd_en = ~enq_pkt_fifo_empty;
    assign enq_pkt_sync       = ~enq_pkt_fifo_empty;
  end
  else begin
    assign enq_pkt_sync = enq_pkt;
    assign m_aresetn    = s_aresetn;
  end
  endgenerate

  always @(posedge m_aclk) begin
    if (~m_aresetn) begin
      pkt_cnt <= 0;
    end
    else if (enq_pkt_sync && ~deq_pkt) begin
      pkt_cnt <= pkt_cnt + 1;
    end
    else if (deq_pkt && ~enq_pkt_sync) begin
      pkt_cnt <= pkt_cnt - 1;
    end
  end

endmodule: axi_stream_packet_fifo
