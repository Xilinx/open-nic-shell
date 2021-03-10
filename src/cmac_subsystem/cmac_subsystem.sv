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
`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module cmac_subsystem #(
  parameter int MAX_PKT_LEN   = 1514,
  parameter int MIN_PKT_LEN   = 64,
  parameter int USE_CMAC_PORT = 1,
  parameter int NUM_CMAC_PORT = 1
) (
  input      [NUM_CMAC_PORT-1:0] s_axil_awvalid,
  input   [32*NUM_CMAC_PORT-1:0] s_axil_awaddr,
  output     [NUM_CMAC_PORT-1:0] s_axil_awready,
  input      [NUM_CMAC_PORT-1:0] s_axil_wvalid,
  input   [32*NUM_CMAC_PORT-1:0] s_axil_wdata,
  output     [NUM_CMAC_PORT-1:0] s_axil_wready,
  output     [NUM_CMAC_PORT-1:0] s_axil_bvalid,
  output   [2*NUM_CMAC_PORT-1:0] s_axil_bresp,
  input      [NUM_CMAC_PORT-1:0] s_axil_bready,
  input      [NUM_CMAC_PORT-1:0] s_axil_arvalid,
  input   [32*NUM_CMAC_PORT-1:0] s_axil_araddr,
  output     [NUM_CMAC_PORT-1:0] s_axil_arready,
  output     [NUM_CMAC_PORT-1:0] s_axil_rvalid,
  output  [32*NUM_CMAC_PORT-1:0] s_axil_rdata,
  output   [2*NUM_CMAC_PORT-1:0] s_axil_rresp,
  input      [NUM_CMAC_PORT-1:0] s_axil_rready,

  // Interfaces to the box running at 250MHz
  input      [NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tlast,
  input   [16*NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tuser_size,
  input   [16*NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tuser_src,
  input   [16*NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tuser_dst,
  output     [NUM_CMAC_PORT-1:0] s_axis_tx_250mhz_tready,

  output     [NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tlast,
  output  [16*NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tuser_size,
  output  [16*NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tuser_src,
  output  [16*NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tuser_dst,
  input      [NUM_CMAC_PORT-1:0] m_axis_rx_250mhz_tready,

  // Adapter-side interfaces to the box running at 322MHz
  output     [NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tuser_err,
  input      [NUM_CMAC_PORT-1:0] m_axis_adpt_tx_322mhz_tready,

  input      [NUM_CMAC_PORT-1:0] s_axis_adpt_rx_322mhz_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_adpt_rx_322mhz_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_adpt_rx_322mhz_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_adpt_rx_322mhz_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_adpt_rx_322mhz_tuser_err,

  // CMAC-side interfaces to the box running at 322MHz
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tuser_err,
  output     [NUM_CMAC_PORT-1:0] s_axis_cmac_tx_322mhz_tready,

  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_rx_322mhz_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_cmac_rx_322mhz_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_cmac_rx_322mhz_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_rx_322mhz_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_rx_322mhz_tuser_err,

`ifdef __synthesis__
  input    [4*NUM_CMAC_PORT-1:0] gt_rxp,
  input    [4*NUM_CMAC_PORT-1:0] gt_rxn,
  output   [4*NUM_CMAC_PORT-1:0] gt_txp,
  output   [4*NUM_CMAC_PORT-1:0] gt_txn,
  input      [NUM_CMAC_PORT-1:0] gt_refclk_p,
  input      [NUM_CMAC_PORT-1:0] gt_refclk_n,

  output     [NUM_CMAC_PORT-1:0] cmac_clk,
`else
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tuser_err,
  input      [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tready,

  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tuser_err,

  output reg [NUM_CMAC_PORT-1:0] cmac_clk,
`endif

  input      [NUM_CMAC_PORT-1:0] mod_rstn,
  output     [NUM_CMAC_PORT-1:0] mod_rst_done,

  input                          axil_aclk,
  input                          axis_aclk
);

  wire     [NUM_CMAC_PORT-1:0] axil_aresetn;

  wire     [NUM_CMAC_PORT-1:0] axil_cmac_awvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_awaddr;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_awready;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_wdata;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_wvalid;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_wready;
  wire   [2*NUM_CMAC_PORT-1:0] axil_cmac_bresp;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_bvalid;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_bready;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_araddr;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_arvalid;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_arready;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_rdata;
  wire   [2*NUM_CMAC_PORT-1:0] axil_cmac_rresp;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_rvalid;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_rready;

  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_cmac_rx_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_cmac_rx_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tuser_err;

  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_cmac_tx_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_cmac_tx_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tuser_err;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tready;

  generate for (genvar i = 0; i < NUM_CMAC_PORT; i++) begin: cmac_misc
    wire         cmac_rstn;

    wire         axil_qsfp_awvalid;
    wire  [31:0] axil_qsfp_awaddr;
    wire         axil_qsfp_awready;
    wire  [31:0] axil_qsfp_wdata;
    wire         axil_qsfp_wvalid;
    wire         axil_qsfp_wready;
    wire   [1:0] axil_qsfp_bresp;
    wire         axil_qsfp_bvalid;
    wire         axil_qsfp_bready;
    wire  [31:0] axil_qsfp_araddr;
    wire         axil_qsfp_arvalid;
    wire         axil_qsfp_arready;
    wire  [31:0] axil_qsfp_rdata;
    wire   [1:0] axil_qsfp_rresp;
    wire         axil_qsfp_rvalid;
    wire         axil_qsfp_rready;

    wire         axil_adpt_awvalid;
    wire  [31:0] axil_adpt_awaddr;
    wire         axil_adpt_awready;
    wire  [31:0] axil_adpt_wdata;
    wire         axil_adpt_wvalid;
    wire         axil_adpt_wready;
    wire   [1:0] axil_adpt_bresp;
    wire         axil_adpt_bvalid;
    wire         axil_adpt_bready;
    wire  [31:0] axil_adpt_araddr;
    wire         axil_adpt_arvalid;
    wire         axil_adpt_arready;
    wire  [31:0] axil_adpt_rdata;
    wire   [1:0] axil_adpt_rresp;
    wire         axil_adpt_rvalid;
    wire         axil_adpt_rready;

    wire         axis_tx_tvalid;
    wire [511:0] axis_tx_tdata;
    wire  [63:0] axis_tx_tkeep;
    wire         axis_tx_tlast;
    wire  [15:0] axis_tx_tuser_size;
    wire  [15:0] axis_tx_tuser_src;
    wire  [15:0] axis_tx_tuser_dst;
    wire         axis_tx_tready;

    wire         axis_rx_tvalid;
    wire [511:0] axis_rx_tdata;
    wire  [63:0] axis_rx_tkeep;
    wire         axis_rx_tlast;
    wire  [15:0] axis_rx_tuser_size;
    wire  [15:0] axis_rx_tuser_src;
    wire  [15:0] axis_rx_tuser_dst;
    wire         axis_rx_tready;

    // Reset is clocked by the 125MHz AXI-Lite clock
    cmac_subsystem_reset reset_inst (
      .mod_rstn     (mod_rstn[i]),
      .mod_rst_done (mod_rst_done[i]),
      .axil_aresetn (axil_aresetn[i]),
      .cmac_rstn    (cmac_rstn),
      .axil_aclk    (axil_aclk),
      .cmac_clk     (cmac_clk[i])
    );

    cmac_subsystem_address_map address_map_inst (
      .s_axil_awvalid      (s_axil_awvalid[i]),
      .s_axil_awaddr       (s_axil_awaddr[`getvec(32, i)]),
      .s_axil_awready      (s_axil_awready[i]),
      .s_axil_wvalid       (s_axil_wvalid[i]),
      .s_axil_wdata        (s_axil_wdata[`getvec(32, i)]),
      .s_axil_wready       (s_axil_wready[i]),
      .s_axil_bvalid       (s_axil_bvalid[i]),
      .s_axil_bresp        (s_axil_bresp[`getvec(2, i)]),
      .s_axil_bready       (s_axil_bready[i]),
      .s_axil_arvalid      (s_axil_arvalid[i]),
      .s_axil_araddr       (s_axil_araddr[`getvec(32, i)]),
      .s_axil_arready      (s_axil_arready[i]),
      .s_axil_rvalid       (s_axil_rvalid[i]),
      .s_axil_rdata        (s_axil_rdata[`getvec(32, i)]),
      .s_axil_rresp        (s_axil_rresp[`getvec(2, i)]),
      .s_axil_rready       (s_axil_rready[i]),

      .m_axil_cmac_awvalid (axil_cmac_awvalid[i]),
      .m_axil_cmac_awaddr  (axil_cmac_awaddr[`getvec(32, i)]),
      .m_axil_cmac_awready (axil_cmac_awready[i]),
      .m_axil_cmac_wvalid  (axil_cmac_wvalid[i]),
      .m_axil_cmac_wdata   (axil_cmac_wdata[`getvec(32, i)]),
      .m_axil_cmac_wready  (axil_cmac_wready[i]),
      .m_axil_cmac_bvalid  (axil_cmac_bvalid[i]),
      .m_axil_cmac_bresp   (axil_cmac_bresp[`getvec(2, i)]),
      .m_axil_cmac_bready  (axil_cmac_bready[i]),
      .m_axil_cmac_arvalid (axil_cmac_arvalid[i]),
      .m_axil_cmac_araddr  (axil_cmac_araddr[`getvec(32, i)]),
      .m_axil_cmac_arready (axil_cmac_arready[i]),
      .m_axil_cmac_rvalid  (axil_cmac_rvalid[i]),
      .m_axil_cmac_rdata   (axil_cmac_rdata[`getvec(32, i)]),
      .m_axil_cmac_rresp   (axil_cmac_rresp[`getvec(2, i)]),
      .m_axil_cmac_rready  (axil_cmac_rready[i]),

      .m_axil_qsfp_awvalid (axil_qsfp_awvalid),
      .m_axil_qsfp_awaddr  (axil_qsfp_awaddr),
      .m_axil_qsfp_awready (axil_qsfp_awready),
      .m_axil_qsfp_wvalid  (axil_qsfp_wvalid),
      .m_axil_qsfp_wdata   (axil_qsfp_wdata),
      .m_axil_qsfp_wready  (axil_qsfp_wready),
      .m_axil_qsfp_bvalid  (axil_qsfp_bvalid),
      .m_axil_qsfp_bresp   (axil_qsfp_bresp),
      .m_axil_qsfp_bready  (axil_qsfp_bready),
      .m_axil_qsfp_arvalid (axil_qsfp_arvalid),
      .m_axil_qsfp_araddr  (axil_qsfp_araddr),
      .m_axil_qsfp_arready (axil_qsfp_arready),
      .m_axil_qsfp_rvalid  (axil_qsfp_rvalid),
      .m_axil_qsfp_rdata   (axil_qsfp_rdata),
      .m_axil_qsfp_rresp   (axil_qsfp_rresp),
      .m_axil_qsfp_rready  (axil_qsfp_rready),

      .m_axil_adpt_awvalid (axil_adpt_awvalid),
      .m_axil_adpt_awaddr  (axil_adpt_awaddr),
      .m_axil_adpt_awready (axil_adpt_awready),
      .m_axil_adpt_wvalid  (axil_adpt_wvalid),
      .m_axil_adpt_wdata   (axil_adpt_wdata),
      .m_axil_adpt_wready  (axil_adpt_wready),
      .m_axil_adpt_bvalid  (axil_adpt_bvalid),
      .m_axil_adpt_bresp   (axil_adpt_bresp),
      .m_axil_adpt_bready  (axil_adpt_bready),
      .m_axil_adpt_arvalid (axil_adpt_arvalid),
      .m_axil_adpt_araddr  (axil_adpt_araddr),
      .m_axil_adpt_arready (axil_adpt_arready),
      .m_axil_adpt_rvalid  (axil_adpt_rvalid),
      .m_axil_adpt_rdata   (axil_adpt_rdata),
      .m_axil_adpt_rresp   (axil_adpt_rresp),
      .m_axil_adpt_rready  (axil_adpt_rready),

      .aclk                (axil_aclk),
      .aresetn             (axil_aresetn[i])
    );

    // [TODO] replace this with an actual register access block
    axi_lite_slave #(
      .REG_ADDR_W (12),
      .REG_PREFIX (16'hC028 + (i << 8)) // for "CMAC0/1 QSFP28"
    ) qsfp_reg_inst (
      .s_axil_awvalid (axil_qsfp_awvalid),
      .s_axil_awaddr  (axil_qsfp_awaddr),
      .s_axil_awready (axil_qsfp_awready),
      .s_axil_wvalid  (axil_qsfp_wvalid),
      .s_axil_wdata   (axil_qsfp_wdata),
      .s_axil_wready  (axil_qsfp_wready),
      .s_axil_bvalid  (axil_qsfp_bvalid),
      .s_axil_bresp   (axil_qsfp_bresp),
      .s_axil_bready  (axil_qsfp_bready),
      .s_axil_arvalid (axil_qsfp_arvalid),
      .s_axil_araddr  (axil_qsfp_araddr),
      .s_axil_arready (axil_qsfp_arready),
      .s_axil_rvalid  (axil_qsfp_rvalid),
      .s_axil_rdata   (axil_qsfp_rdata),
      .s_axil_rresp   (axil_qsfp_rresp),
      .s_axil_rready  (axil_qsfp_rready),

      .aresetn        (axil_aresetn[i]),
      .aclk           (axil_aclk)
    );

    cmac_subsystem_adapter #(
      .CMAC_ID     (i),
      .MAX_PKT_LEN (MAX_PKT_LEN),
      .MIN_PKT_LEN (MIN_PKT_LEN)
    ) adpt_inst (
      .s_axil_awvalid       (axil_adpt_awvalid),
      .s_axil_awaddr        (axil_adpt_awaddr),
      .s_axil_awready       (axil_adpt_awready),
      .s_axil_wvalid        (axil_adpt_wvalid),
      .s_axil_wdata         (axil_adpt_wdata),
      .s_axil_wready        (axil_adpt_wready),
      .s_axil_bvalid        (axil_adpt_bvalid),
      .s_axil_bresp         (axil_adpt_bresp),
      .s_axil_bready        (axil_adpt_bready),
      .s_axil_arvalid       (axil_adpt_arvalid),
      .s_axil_araddr        (axil_adpt_araddr),
      .s_axil_arready       (axil_adpt_arready),
      .s_axil_rvalid        (axil_adpt_rvalid),
      .s_axil_rdata         (axil_adpt_rdata),
      .s_axil_rresp         (axil_adpt_rresp),
      .s_axil_rready        (axil_adpt_rready),

      .s_axis_tx_tvalid     (axis_tx_tvalid),
      .s_axis_tx_tdata      (axis_tx_tdata),
      .s_axis_tx_tkeep      (axis_tx_tkeep),
      .s_axis_tx_tlast      (axis_tx_tlast),
      .s_axis_tx_tuser_size (axis_tx_tuser_size),
      .s_axis_tx_tuser_src  (axis_tx_tuser_src),
      .s_axis_tx_tuser_dst  (axis_tx_tuser_dst),
      .s_axis_tx_tready     (axis_tx_tready),

      .m_axis_tx_tvalid     (m_axis_adpt_tx_322mhz_tvalid[i]),
      .m_axis_tx_tdata      (m_axis_adpt_tx_322mhz_tdata[`getvec(512, i)]),
      .m_axis_tx_tkeep      (m_axis_adpt_tx_322mhz_tkeep[`getvec(64, i)]),
      .m_axis_tx_tlast      (m_axis_adpt_tx_322mhz_tlast[i]),
      .m_axis_tx_tuser_err  (m_axis_adpt_tx_322mhz_tuser_err[i]),
      .m_axis_tx_tready     (m_axis_adpt_tx_322mhz_tready[i]),

      .s_axis_rx_tvalid     (s_axis_adpt_rx_322mhz_tvalid[i]),
      .s_axis_rx_tdata      (s_axis_adpt_rx_322mhz_tdata[`getvec(512, i)]),
      .s_axis_rx_tkeep      (s_axis_adpt_rx_322mhz_tkeep[`getvec(64, i)]),
      .s_axis_rx_tlast      (s_axis_adpt_rx_322mhz_tlast[i]),
      .s_axis_rx_tuser_err  (s_axis_adpt_rx_322mhz_tuser_err[i]),

      .m_axis_rx_tvalid     (axis_rx_tvalid),
      .m_axis_rx_tdata      (axis_rx_tdata),
      .m_axis_rx_tkeep      (axis_rx_tkeep),
      .m_axis_rx_tlast      (axis_rx_tlast),
      .m_axis_rx_tuser_size (axis_rx_tuser_size),
      .m_axis_rx_tuser_src  (axis_rx_tuser_src),
      .m_axis_rx_tuser_dst  (axis_rx_tuser_dst),
      .m_axis_rx_tready     (axis_rx_tready),

      .axil_aclk            (axil_aclk),
      .axis_aclk            (axis_aclk),
      .axil_aresetn         (axil_aresetn[i]),

      .cmac_clk             (cmac_clk[i]),
      .cmac_rstn            (cmac_rstn)
    );

    axi_stream_register_slice #(
      .TDATA_W (512),
      .TUSER_W (48),
      .MODE    ("full")
    ) tx_slice_inst (
      .s_axis_tvalid (s_axis_tx_250mhz_tvalid[i]),
      .s_axis_tdata  (s_axis_tx_250mhz_tdata[`getvec(512, i)]),
      .s_axis_tkeep  (s_axis_tx_250mhz_tkeep[`getvec(64, i)]),
      .s_axis_tlast  (s_axis_tx_250mhz_tlast[i]),
      .s_axis_tid    (0),
      .s_axis_tdest  (0),
      .s_axis_tuser  ({s_axis_tx_250mhz_tuser_size[`getvec(16, i)],
                       s_axis_tx_250mhz_tuser_src[`getvec(16, i)],
                       s_axis_tx_250mhz_tuser_dst[`getvec(16, i)]}),
      .s_axis_tready (s_axis_tx_250mhz_tready[i]),

      .m_axis_tvalid (axis_tx_tvalid),
      .m_axis_tdata  (axis_tx_tdata),
      .m_axis_tkeep  (axis_tx_tkeep),
      .m_axis_tlast  (axis_tx_tlast),
      .m_axis_tid    (),
      .m_axis_tdest  (),
      .m_axis_tuser  ({axis_tx_tuser_size,
                       axis_tx_tuser_src,
                       axis_tx_tuser_dst}),
      .m_axis_tready (axis_tx_tready),

      .aclk          (axis_aclk),
      .aresetn       (axil_aresetn[i])
    );

    axi_stream_register_slice #(
      .TDATA_W (512),
      .TUSER_W (48),
      .MODE    ("full")
    ) rx_slice_inst (
      .s_axis_tvalid (axis_rx_tvalid),
      .s_axis_tdata  (axis_rx_tdata),
      .s_axis_tkeep  (axis_rx_tkeep),
      .s_axis_tlast  (axis_rx_tlast),
      .s_axis_tid    (0),
      .s_axis_tdest  (0),
      .s_axis_tuser  ({axis_rx_tuser_size,
                       axis_rx_tuser_src,
                       axis_rx_tuser_dst}),
      .s_axis_tready (axis_rx_tready),

      .m_axis_tvalid (m_axis_rx_250mhz_tvalid[i]),
      .m_axis_tdata  (m_axis_rx_250mhz_tdata[`getvec(512, i)]),
      .m_axis_tkeep  (m_axis_rx_250mhz_tkeep[`getvec(64, i)]),
      .m_axis_tlast  (m_axis_rx_250mhz_tlast[i]),
      .m_axis_tid    (),
      .m_axis_tdest  (),
      .m_axis_tuser  ({m_axis_rx_250mhz_tuser_size[`getvec(16, i)],
                       m_axis_rx_250mhz_tuser_src[`getvec(16, i)],
                       m_axis_rx_250mhz_tuser_dst[`getvec(16, i)]}),
      .m_axis_tready (m_axis_rx_250mhz_tready[i]),

      .aclk          (axis_aclk),
      .aresetn       (axil_aresetn[i])
    );
  end: cmac_misc
  endgenerate

`ifdef __synthesis__
  cmac_subsystem_cmac_wrapper #(
    .NUM_CMAC_PORT (NUM_CMAC_PORT)
  ) cmac_wrapper_inst (
    .gt_rxp              (gt_rxp),
    .gt_rxn              (gt_rxn),
    .gt_txp              (gt_txp),
    .gt_txn              (gt_txn),

    .s_axil_awaddr       (axil_cmac_awaddr),
    .s_axil_awvalid      (axil_cmac_awvalid),
    .s_axil_awready      (axil_cmac_awready),
    .s_axil_wdata        (axil_cmac_wdata),
    .s_axil_wvalid       (axil_cmac_wvalid),
    .s_axil_wready       (axil_cmac_wready),
    .s_axil_bresp        (axil_cmac_bresp),
    .s_axil_bvalid       (axil_cmac_bvalid),
    .s_axil_bready       (axil_cmac_bready),
    .s_axil_araddr       (axil_cmac_araddr),
    .s_axil_arvalid      (axil_cmac_arvalid),
    .s_axil_arready      (axil_cmac_arready),
    .s_axil_rdata        (axil_cmac_rdata),
    .s_axil_rresp        (axil_cmac_rresp),
    .s_axil_rvalid       (axil_cmac_rvalid),
    .s_axil_rready       (axil_cmac_rready),

    .m_axis_rx_tvalid    (m_axis_cmac_rx_322mhz_tvalid),
    .m_axis_rx_tdata     (m_axis_cmac_rx_322mhz_tdata),
    .m_axis_rx_tkeep     (m_axis_cmac_rx_322mhz_tkeep),
    .m_axis_rx_tlast     (m_axis_cmac_rx_322mhz_tlast),
    .m_axis_rx_tuser_err (m_axis_cmac_rx_322mhz_tuser_err),

    .s_axis_tx_tvalid    (s_axis_cmac_tx_322mhz_tvalid),
    .s_axis_tx_tdata     (s_axis_cmac_tx_322mhz_tdata),
    .s_axis_tx_tkeep     (s_axis_cmac_tx_322mhz_tkeep),
    .s_axis_tx_tlast     (s_axis_cmac_tx_322mhz_tlast),
    .s_axis_tx_tuser_err (s_axis_cmac_tx_322mhz_tuser_err),
    .s_axis_tx_tready    (s_axis_cmac_tx_322mhz_tready),

    .gt_refclk_p         (gt_refclk_p),
    .gt_refclk_n         (gt_refclk_n),
    .cmac_clk            (cmac_clk),
    .cmac_sys_reset      (~axil_aresetn),

    .axil_aclk           (axil_aclk)
  );
`else // !`ifdef __synthesis__
  for (genvar i = 0; i < NUM_CMAC_PORT; i++) begin: cmac_sim
    if (i == 0) begin
      initial begin
        cmac_clk[i] = 1'b1;
        forever #1552ps cmac_clk[i] = ~cmac_clk[i];
      end
    end
    else begin
      initial begin
        // Assume a random phase shift with CMAC1 clock 
        cmac_clk[i] = 1'b0;
        #(1ps * ($urandom % 3103));
        cmac_clk[i] = 1'b1;
        forever #1552ps cmac_clk[i] = ~cmac_clk[i];
      end
    end

    // CMAC registers do not exist in simulation
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC000 + (i << 8)) // C000 -> CMAC0, C100 -> CMAC1
    ) cmac_reg_inst (
      .s_axil_awvalid (axil_cmac_awvalid[i]),
      .s_axil_awaddr  (axil_cmac_awaddr[`getvec(32, i)]),
      .s_axil_awready (axil_cmac_awready[i]),
      .s_axil_wvalid  (axil_cmac_wvalid[i]),
      .s_axil_wdata   (axil_cmac_wdata[`getvec(32, i)]),
      .s_axil_wready  (axil_cmac_wready[i]),
      .s_axil_bvalid  (axil_cmac_bvalid[i]),
      .s_axil_bresp   (axil_cmac_bresp[`getvec(2, i)]),
      .s_axil_bready  (axil_cmac_bready[i]),
      .s_axil_arvalid (axil_cmac_arvalid[i]),
      .s_axil_araddr  (axil_cmac_araddr[`getvec(32, i)]),
      .s_axil_arready (axil_cmac_arready[i]),
      .s_axil_rvalid  (axil_cmac_rvalid[i]),
      .s_axil_rdata   (axil_cmac_rdata[`getvec(32, i)]),
      .s_axil_rresp   (axil_cmac_rresp[`getvec(2, i)]),
      .s_axil_rready  (axil_cmac_rready[i]),

      .aclk           (axil_aclk),
      .aresetn        (axil_aresetn[i])
    );
  end: cmac_sim

  assign m_axis_cmac_tx_tvalid           = s_axis_cmac_tx_322mhz_tvalid;
  assign m_axis_cmac_tx_tdata            = s_axis_cmac_tx_322mhz_tdata;
  assign m_axis_cmac_tx_tkeep            = s_axis_cmac_tx_322mhz_tkeep;
  assign m_axis_cmac_tx_tlast            = s_axis_cmac_tx_322mhz_tlast;
  assign m_axis_cmac_tx_tuser_err        = s_axis_cmac_tx_322mhz_tuser_err;
  assign s_axis_cmac_tx_322mhz_tready    = m_axis_cmac_tx_tready;

  assign m_axis_cmac_rx_322mhz_tvalid    = s_axis_cmac_rx_tvalid;
  assign m_axis_cmac_rx_322mhz_tdata     = s_axis_cmac_rx_tdata;
  assign m_axis_cmac_rx_322mhz_tkeep     = s_axis_cmac_rx_tkeep;
  assign m_axis_cmac_rx_322mhz_tlast     = s_axis_cmac_rx_tlast;
  assign m_axis_cmac_rx_322mhz_tuser_err = s_axis_cmac_rx_tuser_err;
`endif

endmodule: cmac_subsystem
