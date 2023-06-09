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
module cmac_subsystem #(
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

  input          s_axis_cmac_tx_tvalid,
  input  [511:0] s_axis_cmac_tx_tdata,
  input   [63:0] s_axis_cmac_tx_tkeep,
  input          s_axis_cmac_tx_tlast,
  input          s_axis_cmac_tx_tuser_err,
  output         s_axis_cmac_tx_tready,

  output         m_axis_cmac_rx_tvalid,
  output [511:0] m_axis_cmac_rx_tdata,
  output  [63:0] m_axis_cmac_rx_tkeep,
  output         m_axis_cmac_rx_tlast,
  output         m_axis_cmac_rx_tuser_err,

`ifdef __synthesis__
  input    [3:0] gt_rxp,
  input    [3:0] gt_rxn,
  output   [3:0] gt_txp,
  output   [3:0] gt_txn,
  input          gt_refclk_p,
  input          gt_refclk_n,

`ifdef __au45n__
  input          dual0_gt_ref_clk_p,
  input          dual0_gt_ref_clk_n,
  input          dual1_gt_ref_clk_p,
  input          dual1_gt_ref_clk_n,
`endif

  output         cmac_clk,
`else
  output         m_axis_cmac_tx_sim_tvalid,
  output [511:0] m_axis_cmac_tx_sim_tdata,
  output  [63:0] m_axis_cmac_tx_sim_tkeep,
  output         m_axis_cmac_tx_sim_tlast,
  output         m_axis_cmac_tx_sim_tuser_err,
  input          m_axis_cmac_tx_sim_tready,

  input          s_axis_cmac_rx_sim_tvalid,
  input  [511:0] s_axis_cmac_rx_sim_tdata,
  input   [63:0] s_axis_cmac_rx_sim_tkeep,
  input          s_axis_cmac_rx_sim_tlast,
  input          s_axis_cmac_rx_sim_tuser_err,

  output reg     cmac_clk,
`endif

  input          mod_rstn,
  output         mod_rst_done,
  input          axil_aclk
);

  wire         axil_aresetn;
  wire         cmac_rstn;

  wire         axil_cmac_awvalid;
  wire  [31:0] axil_cmac_awaddr;
  wire         axil_cmac_awready;
  wire  [31:0] axil_cmac_wdata;
  wire         axil_cmac_wvalid;
  wire         axil_cmac_wready;
  wire   [1:0] axil_cmac_bresp;
  wire         axil_cmac_bvalid;
  wire         axil_cmac_bready;
  wire  [31:0] axil_cmac_araddr;
  wire         axil_cmac_arvalid;
  wire         axil_cmac_arready;
  wire  [31:0] axil_cmac_rdata;
  wire   [1:0] axil_cmac_rresp;
  wire         axil_cmac_rvalid;
  wire         axil_cmac_rready;

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

  wire         axis_cmac_tx_tvalid;
  wire [511:0] axis_cmac_tx_tdata;
  wire  [63:0] axis_cmac_tx_tkeep;
  wire         axis_cmac_tx_tlast;
  wire         axis_cmac_tx_tuser_err;
  wire         axis_cmac_tx_tready;

  wire         axis_cmac_rx_tvalid;
  wire [511:0] axis_cmac_rx_tdata;
  wire  [63:0] axis_cmac_rx_tkeep;
  wire         axis_cmac_rx_tlast;
  wire         axis_cmac_rx_tuser_err;

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

  cmac_subsystem_address_map address_map_inst (
    .s_axil_awvalid      (s_axil_awvalid),
    .s_axil_awaddr       (s_axil_awaddr),
    .s_axil_awready      (s_axil_awready),
    .s_axil_wvalid       (s_axil_wvalid),
    .s_axil_wdata        (s_axil_wdata),
    .s_axil_wready       (s_axil_wready),
    .s_axil_bvalid       (s_axil_bvalid),
    .s_axil_bresp        (s_axil_bresp),
    .s_axil_bready       (s_axil_bready),
    .s_axil_arvalid      (s_axil_arvalid),
    .s_axil_araddr       (s_axil_araddr),
    .s_axil_arready      (s_axil_arready),
    .s_axil_rvalid       (s_axil_rvalid),
    .s_axil_rdata        (s_axil_rdata),
    .s_axil_rresp        (s_axil_rresp),
    .s_axil_rready       (s_axil_rready),

    .m_axil_cmac_awvalid (axil_cmac_awvalid),
    .m_axil_cmac_awaddr  (axil_cmac_awaddr),
    .m_axil_cmac_awready (axil_cmac_awready),
    .m_axil_cmac_wvalid  (axil_cmac_wvalid),
    .m_axil_cmac_wdata   (axil_cmac_wdata),
    .m_axil_cmac_wready  (axil_cmac_wready),
    .m_axil_cmac_bvalid  (axil_cmac_bvalid),
    .m_axil_cmac_bresp   (axil_cmac_bresp),
    .m_axil_cmac_bready  (axil_cmac_bready),
    .m_axil_cmac_arvalid (axil_cmac_arvalid),
    .m_axil_cmac_araddr  (axil_cmac_araddr),
    .m_axil_cmac_arready (axil_cmac_arready),
    .m_axil_cmac_rvalid  (axil_cmac_rvalid),
    .m_axil_cmac_rdata   (axil_cmac_rdata),
    .m_axil_cmac_rresp   (axil_cmac_rresp),
    .m_axil_cmac_rready  (axil_cmac_rready),

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

    .aclk                (axil_aclk),
    .aresetn             (axil_aresetn)
  );

  // [TODO] replace this with an actual register access block
  axi_lite_slave #(
    .REG_ADDR_W (12),
    .REG_PREFIX (16'hC028 + (CMAC_ID << 8)) // for "CMAC0/1 QSFP28"
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

    .aresetn        (axil_aresetn),
    .aclk           (axil_aclk)
  );

  axi_stream_register_slice #(
    .TDATA_W (512),
    .TUSER_W (1),
    .MODE    ("full")
  ) tx_slice_inst (
    .s_axis_tvalid (s_axis_cmac_tx_tvalid),
    .s_axis_tdata  (s_axis_cmac_tx_tdata),
    .s_axis_tkeep  (s_axis_cmac_tx_tkeep),
    .s_axis_tlast  (s_axis_cmac_tx_tlast),
    .s_axis_tid    (0),
    .s_axis_tdest  (0),
    .s_axis_tuser  (s_axis_cmac_tx_tuser_err),
    .s_axis_tready (s_axis_cmac_tx_tready),

    .m_axis_tvalid (axis_cmac_tx_tvalid),
    .m_axis_tdata  (axis_cmac_tx_tdata),
    .m_axis_tkeep  (axis_cmac_tx_tkeep),
    .m_axis_tlast  (axis_cmac_tx_tlast),
    .m_axis_tid    (),
    .m_axis_tdest  (),
    .m_axis_tuser  (axis_cmac_tx_tuser_err),
    .m_axis_tready (axis_cmac_tx_tready),

    .aclk          (cmac_clk),
    .aresetn       (cmac_rstn)
  );

  axi_stream_register_slice #(
    .TDATA_W (512),
    .TUSER_W (1),
    .MODE    ("full")
  ) rx_slice_inst (
    .s_axis_tvalid (axis_cmac_rx_tvalid),
    .s_axis_tdata  (axis_cmac_rx_tdata),
    .s_axis_tkeep  (axis_cmac_rx_tkeep),
    .s_axis_tlast  (axis_cmac_rx_tlast),
    .s_axis_tid    (0),
    .s_axis_tdest  (0),
    .s_axis_tuser  (axis_cmac_rx_tuser_err),
    .s_axis_tready (),

    .m_axis_tvalid (m_axis_cmac_rx_tvalid),
    .m_axis_tdata  (m_axis_cmac_rx_tdata),
    .m_axis_tkeep  (m_axis_cmac_rx_tkeep),
    .m_axis_tlast  (m_axis_cmac_rx_tlast),
    .m_axis_tid    (),
    .m_axis_tdest  (),
    .m_axis_tuser  (m_axis_cmac_rx_tuser_err),
    .m_axis_tready (1'b1),

    .aclk          (cmac_clk),
    .aresetn       (cmac_rstn)
  );

`ifdef __synthesis__
  cmac_subsystem_cmac_wrapper #(
    .CMAC_ID (CMAC_ID)
  ) cmac_wrapper_inst (
    .gt_rxp              (gt_rxp),
    .gt_rxn              (gt_rxn),
    .gt_txp              (gt_txp),
    .gt_txn              (gt_txn),

`ifdef __au45n__
    .dual0_gt_ref_clk_p (dual0_gt_ref_clk_p),
    .dual0_gt_ref_clk_n (dual0_gt_ref_clk_n),
    .dual1_gt_ref_clk_p (dual1_gt_ref_clk_p),
    .dual1_gt_ref_clk_n (dual1_gt_ref_clk_n),
`endif

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

    .s_axis_tx_tvalid    (axis_cmac_tx_tvalid),
    .s_axis_tx_tdata     (axis_cmac_tx_tdata),
    .s_axis_tx_tkeep     (axis_cmac_tx_tkeep),
    .s_axis_tx_tlast     (axis_cmac_tx_tlast),
    .s_axis_tx_tuser_err (axis_cmac_tx_tuser_err),
    .s_axis_tx_tready    (axis_cmac_tx_tready),

    .m_axis_rx_tvalid    (axis_cmac_rx_tvalid),
    .m_axis_rx_tdata     (axis_cmac_rx_tdata),
    .m_axis_rx_tkeep     (axis_cmac_rx_tkeep),
    .m_axis_rx_tlast     (axis_cmac_rx_tlast),
    .m_axis_rx_tuser_err (axis_cmac_rx_tuser_err),

    .gt_refclk_p         (gt_refclk_p),
    .gt_refclk_n         (gt_refclk_n),
    .cmac_clk            (cmac_clk),
    .cmac_sys_reset      (~axil_aresetn),

    .axil_aclk           (axil_aclk)
  );
`else // !`ifdef __synthesis__
  generate begin: cmac_sim
    if (CMAC_ID == 0) begin
      initial begin
        cmac_clk = 1'b1;
        forever #1552ps cmac_clk = ~cmac_clk;
      end
    end
    else begin
      initial begin
        // Assume a random phase shift with CMAC-0 clock 
        cmac_clk = 1'b0;
        #(1ps * ($urandom % 3103));
        cmac_clk = 1'b1;
        forever #1552ps cmac_clk = ~cmac_clk;
      end
    end

    // CMAC registers do not exist in simulation
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC000 + (CMAC_ID << 8)) // C000 -> CMAC0, C100 -> CMAC1
    ) cmac_reg_inst (
      .s_axil_awvalid (axil_cmac_awvalid),
      .s_axil_awaddr  (axil_cmac_awaddr),
      .s_axil_awready (axil_cmac_awready),
      .s_axil_wvalid  (axil_cmac_wvalid),
      .s_axil_wdata   (axil_cmac_wdata),
      .s_axil_wready  (axil_cmac_wready),
      .s_axil_bvalid  (axil_cmac_bvalid),
      .s_axil_bresp   (axil_cmac_bresp),
      .s_axil_bready  (axil_cmac_bready),
      .s_axil_arvalid (axil_cmac_arvalid),
      .s_axil_araddr  (axil_cmac_araddr),
      .s_axil_arready (axil_cmac_arready),
      .s_axil_rvalid  (axil_cmac_rvalid),
      .s_axil_rdata   (axil_cmac_rdata),
      .s_axil_rresp   (axil_cmac_rresp),
      .s_axil_rready  (axil_cmac_rready),

      .aclk           (axil_aclk),
      .aresetn        (axil_aresetn)
    );
  end: cmac_sim
  endgenerate

  assign m_axis_cmac_tx_sim_tvalid    = axis_cmac_tx_tvalid;
  assign m_axis_cmac_tx_sim_tdata     = axis_cmac_tx_tdata;
  assign m_axis_cmac_tx_sim_tkeep     = axis_cmac_tx_tkeep;
  assign m_axis_cmac_tx_sim_tlast     = axis_cmac_tx_tlast;
  assign m_axis_cmac_tx_sim_tuser_err = axis_cmac_tx_tuser_err;
  assign axis_cmac_tx_tready          = m_axis_cmac_tx_sim_tready;

  assign axis_cmac_rx_tvalid          = s_axis_cmac_rx_sim_tvalid;
  assign axis_cmac_rx_tdata           = s_axis_cmac_rx_sim_tdata;
  assign axis_cmac_rx_tkeep           = s_axis_cmac_rx_sim_tkeep;
  assign axis_cmac_rx_tlast           = s_axis_cmac_rx_sim_tlast;
  assign axis_cmac_rx_tuser_err       = s_axis_cmac_rx_sim_tuser_err;
`endif

endmodule: cmac_subsystem
