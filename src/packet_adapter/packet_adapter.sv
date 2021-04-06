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
module packet_adapter #(
  parameter int CMAC_ID     = 0,
  parameter int MIN_PKT_LEN = 64,
  parameter int MAX_PKT_LEN = 1518
) (
  input          s_axil_awvalid,
  input   [31:0] s_axil_awaddr,
  output         s_axil_awready,
  input          s_axil_wvalid,
  input   [31:0] s_axil_wdata,
  output         s_axil_wready,
  output         s_axil_bvalid,
  output   [1:0] s_axil_bresp,
  input          s_axil_bready,
  input          s_axil_arvalid,
  input   [31:0] s_axil_araddr,
  output         s_axil_arready,
  output         s_axil_rvalid,
  output  [31:0] s_axil_rdata,
  output   [1:0] s_axil_rresp,
  input          s_axil_rready,

  input          s_axis_tx_tvalid,
  input  [511:0] s_axis_tx_tdata,
  input   [63:0] s_axis_tx_tkeep,
  input          s_axis_tx_tlast,
  input   [15:0] s_axis_tx_tuser_size,
  input   [15:0] s_axis_tx_tuser_src,
  input   [15:0] s_axis_tx_tuser_dst,
  output         s_axis_tx_tready,

  output         m_axis_tx_tvalid,
  output [511:0] m_axis_tx_tdata,
  output  [63:0] m_axis_tx_tkeep,
  output         m_axis_tx_tlast,
  output         m_axis_tx_tuser_err,
  input          m_axis_tx_tready,

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

  input          mod_rstn,
  output         mod_rst_done,

  input          axil_aclk,
  input          axis_aclk,
  input          cmac_clk
);

  wire        axil_aresetn;
  wire        cmac_rstn;

  wire        tx_pkt_sent;
  wire        tx_pkt_drop;
  wire [15:0] tx_bytes;

  wire        rx_pkt_recv;
  wire        rx_pkt_drop;
  wire        rx_pkt_err;
  wire [15:0] rx_bytes;

  // Reset is clocked by the 125MHz AXI-Lite clock
  generic_reset #(
    .NUM_INPUT_CLK  (2),
    .RESET_DURATION (100)
  ) reset_inst (
    .mod_rstn     (mod_rstn),
    .mod_rst_done (mod_rst_done),
    .clk          ({cmac_clk, axil_aclk}),
    .rstn         ({cmac_rstn, axil_aresetn})
  );

  packet_adapter_register reg_inst (
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

    .tx_pkt_sent    (tx_pkt_sent),
    .tx_pkt_drop    (tx_pkt_drop),
    .tx_bytes       (tx_bytes),

    .rx_pkt_recv    (rx_pkt_recv),
    .rx_pkt_drop    (rx_pkt_drop),
    .rx_pkt_err     (rx_pkt_err),
    .rx_bytes       (rx_bytes),

    .axil_aclk      (axil_aclk),
    .axis_aclk      (axis_aclk),
    .axil_aresetn   (axil_aresetn)
  );

  packet_adapter_tx #(
    .CMAC_ID     (CMAC_ID),
    .MAX_PKT_LEN (MAX_PKT_LEN),
    .PKT_CAP     (1.5)
  ) tx_inst (
    .s_axis_tx_tvalid     (s_axis_tx_tvalid),
    .s_axis_tx_tdata      (s_axis_tx_tdata),
    .s_axis_tx_tkeep      (s_axis_tx_tkeep),
    .s_axis_tx_tlast      (s_axis_tx_tlast),
    .s_axis_tx_tuser_size (s_axis_tx_tuser_size),
    .s_axis_tx_tuser_src  (s_axis_tx_tuser_src),
    .s_axis_tx_tuser_dst  (s_axis_tx_tuser_dst),
    .s_axis_tx_tready     (s_axis_tx_tready),

    .m_axis_tx_tvalid     (m_axis_tx_tvalid),
    .m_axis_tx_tdata      (m_axis_tx_tdata),
    .m_axis_tx_tkeep      (m_axis_tx_tkeep),
    .m_axis_tx_tlast      (m_axis_tx_tlast),
    .m_axis_tx_tuser_err  (m_axis_tx_tuser_err),
    .m_axis_tx_tready     (m_axis_tx_tready),

    .tx_pkt_sent          (tx_pkt_sent),
    .tx_pkt_drop          (tx_pkt_drop),
    .tx_bytes             (tx_bytes),

    .axis_aclk            (axis_aclk),
    .axil_aresetn         (axil_aresetn),
    .cmac_clk             (cmac_clk)
  );

  packet_adapter_rx #(
    .CMAC_ID     (CMAC_ID),
    .MAX_PKT_LEN (MAX_PKT_LEN),
    .PKT_CAP     (1.5)
  ) rx_inst (
    .s_axis_rx_tvalid     (s_axis_rx_tvalid),
    .s_axis_rx_tdata      (s_axis_rx_tdata),
    .s_axis_rx_tkeep      (s_axis_rx_tkeep),
    .s_axis_rx_tlast      (s_axis_rx_tlast),
    .s_axis_rx_tuser_err  (s_axis_rx_tuser_err),

    .m_axis_rx_tvalid     (m_axis_rx_tvalid),
    .m_axis_rx_tdata      (m_axis_rx_tdata),
    .m_axis_rx_tkeep      (m_axis_rx_tkeep),
    .m_axis_rx_tlast      (m_axis_rx_tlast),
    .m_axis_rx_tuser_size (m_axis_rx_tuser_size),
    .m_axis_rx_tuser_src  (m_axis_rx_tuser_src),
    .m_axis_rx_tuser_dst  (m_axis_rx_tuser_dst),
    .m_axis_rx_tready     (m_axis_rx_tready),

    .rx_pkt_recv          (rx_pkt_recv),
    .rx_pkt_drop          (rx_pkt_drop),
    .rx_pkt_err           (rx_pkt_err),
    .rx_bytes             (rx_bytes),

    .axis_aclk            (axis_aclk),
    .cmac_clk             (cmac_clk),
    .cmac_rstn            (cmac_rstn)
  );

endmodule: packet_adapter
