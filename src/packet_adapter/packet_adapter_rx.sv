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
module packet_adapter_rx #(
  parameter int  CMAC_ID     = 0,
  parameter int  MIN_PKT_LEN = 64,
  parameter int  MAX_PKT_LEN = 1518,
  parameter real PKT_CAP     = 1.5
) (
  input          s_axis_rx_tvalid,
  input  [511:0] s_axis_rx_tdata,
  input   [63:0] s_axis_rx_tkeep,
  input          s_axis_rx_tlast,
  input          s_axis_rx_tuser_err,

  output         m_axis_rx_tvalid,
  output [511:0] m_axis_rx_tdata,
  output  [63:0] m_axis_rx_tkeep,
  output         m_axis_rx_tlast,
  output  [15:0] m_axis_rx_tuser_size,
  output  [15:0] m_axis_rx_tuser_src,
  output  [15:0] m_axis_rx_tuser_dst,
  input          m_axis_rx_tready,

  // Synchronized to axis_aclk (250MHz)
  output         rx_pkt_recv,
  output         rx_pkt_drop,
  output         rx_pkt_err,
  output  [15:0] rx_bytes,

  input          axis_aclk,
  input          cmac_clk,
  input          cmac_rstn
);

  // FIFO is large enough to fit in at least 1.5 largest packets
  localparam C_FIFO_ADDR_W = $clog2(int'($ceil(real'(MAX_PKT_LEN * 8) / 512 * PKT_CAP)));
  localparam C_FIFO_DEPTH  = 1 << C_FIFO_ADDR_W;

  // Synchronized to the CMAC clock `s_aclk`
  wire  [15:0] pkt_size;
  wire         pkt_recv;
  wire         pkt_drop;
  wire         pkt_err;

  wire         drop;
  wire         drop_busy;

  wire         axis_buf_tvalid;
  wire [511:0] axis_buf_tdata;
  wire  [63:0] axis_buf_tkeep;
  wire         axis_buf_tlast;
  wire         axis_buf_tuser_err;
  wire         axis_buf_tready;

  axi_stream_register_slice #(
    .TDATA_W (512),
    .TUSER_W (1),
    .MODE    ("forward")
  ) input_slice_inst (
    .s_axis_tvalid    (s_axis_rx_tvalid),
    .s_axis_tdata     (s_axis_rx_tdata),
    .s_axis_tkeep     (s_axis_rx_tkeep),
    .s_axis_tlast     (s_axis_rx_tlast),
    .s_axis_tid       (0),
    .s_axis_tdest     (0),
    .s_axis_tuser     (s_axis_rx_tuser_err),
    .s_axis_tready    (),
    
    .m_axis_tvalid    (axis_buf_tvalid),
    .m_axis_tdata     (axis_buf_tdata),
    .m_axis_tkeep     (axis_buf_tkeep),
    .m_axis_tlast     (axis_buf_tlast),
    .m_axis_tid       (),
    .m_axis_tdest     (),
    .m_axis_tuser     (axis_buf_tuser_err),
    .m_axis_tready    (1'b1),

    .aclk             (cmac_clk),
    .aresetn          (cmac_rstn)
  );

  axi_stream_size_counter #(
    .TDATA_W (512)
  ) size_cnt_inst (
    .p_axis_tvalid    (axis_buf_tvalid),
    .p_axis_tkeep     (axis_buf_tkeep),
    .p_axis_tlast     (axis_buf_tlast),
    .p_axis_tuser_mty (0),
    .p_axis_tready    (1'b1),

    .size_valid       (),
    .size             (pkt_size),

    .aclk             (cmac_clk),
    .aresetn          (cmac_rstn)
  );

  // Total number of packets from CMAC =
  //   number of received packets (i.e., pkt_recv) +
  //   number of dropped packets (i.e., pkt_drop)
  assign pkt_recv = axis_buf_tvalid && axis_buf_tlast && axis_buf_tready && ~drop_busy;
  assign pkt_drop = axis_buf_tvalid && axis_buf_tlast && axis_buf_tready && drop_busy;
  assign pkt_err  = axis_buf_tvalid && axis_buf_tlast && axis_buf_tready && axis_buf_tuser_err;

  // Packets should be dropped when
  // - error bit is asserted (i.e., tuser_err = 1 at the last beat), or
  // - packet buffer does not have space
  assign drop = (axis_buf_tvalid && axis_buf_tlast && axis_buf_tuser_err) ||
                (axis_buf_tvalid && ~axis_buf_tready);

  level_trigger_cdc #(
    .DATA_W     (16),
    .FIFO_DEPTH (64)
  ) pkt_recv_cdc_inst (
    .src_valid (pkt_recv),
    .src_data  (pkt_size),
    .src_miss  (),
    .dst_valid (rx_pkt_recv),
    .dst_data  (rx_bytes),

    .src_clk   (cmac_clk),
    .src_rstn  (cmac_rstn),
    .dst_clk   (axis_aclk)
  );

  level_trigger_cdc #(
    .FIFO_DEPTH (64)
  ) pkt_drop_cdc_inst (
    .src_valid (pkt_drop),
    .src_data  (0),
    .src_miss  (),
    .dst_valid (rx_pkt_drop),
    .dst_data  (),

    .src_clk   (cmac_clk),
    .src_rstn  (cmac_rstn),
    .dst_clk   (axis_aclk)
  );

  level_trigger_cdc #(
    .FIFO_DEPTH (64)
  ) pkt_err_cdc_inst (
    .src_valid (pkt_err),
    .src_data  (0),
    .src_miss  (),
    .dst_valid (rx_pkt_err),
    .dst_data  (),

    .src_clk   (cmac_clk),
    .src_rstn  (cmac_rstn),
    .dst_clk   (axis_aclk)
  );

  axi_stream_packet_buffer #(
    .CLOCKING_MODE   ("independent_clock"),
    .CDC_SYNC_STAGES (2),
    .TDATA_W         (512),
    .MIN_PKT_LEN     (MIN_PKT_LEN),
    .MAX_PKT_LEN     (MAX_PKT_LEN),
    .PKT_CAP         (PKT_CAP)
  ) pkt_buf_inst (
    .s_axis_tvalid     (axis_buf_tvalid),
    .s_axis_tdata      (axis_buf_tdata),
    .s_axis_tkeep      (axis_buf_tkeep),
    .s_axis_tlast      (axis_buf_tlast),
    .s_axis_tid        (0),
    .s_axis_tdest      (0),
    .s_axis_tuser      (0),
    .s_axis_tready     (axis_buf_tready),

    .drop              (drop),
    .drop_busy         (drop_busy),

    .m_axis_tvalid     (m_axis_rx_tvalid),
    .m_axis_tdata      (m_axis_rx_tdata),
    .m_axis_tkeep      (m_axis_rx_tkeep),
    .m_axis_tlast      (m_axis_rx_tlast),
    .m_axis_tid        (),
    .m_axis_tdest      (),
    .m_axis_tuser      (),
    .m_axis_tuser_size (m_axis_rx_tuser_size),
    .m_axis_tready     (m_axis_rx_tready),

    .s_aclk            (cmac_clk),
    .s_aresetn         (cmac_rstn),
    .m_aclk            (axis_aclk)
  );

  assign m_axis_rx_tuser_src = 16'h1 << (CMAC_ID + 6);
  assign m_axis_rx_tuser_dst = 0;

endmodule: packet_adapter_rx
