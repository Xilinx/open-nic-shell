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
module open_nic_shell #(
  parameter [31:0] BUILD_TIMESTAMP = 32'h01010000,
  parameter int    MIN_PKT_LEN     = 64,
  parameter int    MAX_PKT_LEN     = 1518,
  parameter int    USE_PHYS_FUNC   = 1,
  parameter int    NUM_PHYS_FUNC   = 1,
  parameter int    NUM_QUEUE       = 512,
  parameter int    NUM_CMAC_PORT   = 1
) (
`ifdef __synthesis__
`ifdef __au280__
  output                         hbm_cattrip, // Fix the CATTRIP issue for AU280 custom flow
`endif

  input                   [15:0] pcie_rxp,
  input                   [15:0] pcie_rxn,
  output                  [15:0] pcie_txp,
  output                  [15:0] pcie_txn,
  input                          pcie_refclk_p,
  input                          pcie_refclk_n,
  input                          pcie_rstn,

  input    [4*NUM_CMAC_PORT-1:0] qsfp_rxp,
  input    [4*NUM_CMAC_PORT-1:0] qsfp_rxn,
  output   [4*NUM_CMAC_PORT-1:0] qsfp_txp,
  output   [4*NUM_CMAC_PORT-1:0] qsfp_txn,
  input      [NUM_CMAC_PORT-1:0] qsfp_refclk_p,
  input      [NUM_CMAC_PORT-1:0] qsfp_refclk_n
`else // !`ifdef __synthesis__
  input                          s_axil_sim_awvalid,
  input                   [31:0] s_axil_sim_awaddr,
  output                         s_axil_sim_awready,
  input                          s_axil_sim_wvalid,
  input                   [31:0] s_axil_sim_wdata,
  output                         s_axil_sim_wready,
  output                         s_axil_sim_bvalid,
  output                   [1:0] s_axil_sim_bresp,
  input                          s_axil_sim_bready,
  input                          s_axil_sim_arvalid,
  input                   [31:0] s_axil_sim_araddr,
  output                         s_axil_sim_arready,
  output                         s_axil_sim_rvalid,
  output                  [31:0] s_axil_sim_rdata,
  output                   [1:0] s_axil_sim_rresp,
  input                          s_axil_sim_rready,

  input                          s_axis_qdma_h2c_sim_tvalid,
  input                  [511:0] s_axis_qdma_h2c_sim_tdata,
  input                   [31:0] s_axis_qdma_h2c_sim_tcrc,
  input                          s_axis_qdma_h2c_sim_tlast,
  input                   [10:0] s_axis_qdma_h2c_sim_tuser_qid,
  input                    [2:0] s_axis_qdma_h2c_sim_tuser_port_id,
  input                          s_axis_qdma_h2c_sim_tuser_err,
  input                   [31:0] s_axis_qdma_h2c_sim_tuser_mdata,
  input                    [5:0] s_axis_qdma_h2c_sim_tuser_mty,
  input                          s_axis_qdma_h2c_sim_tuser_zero_byte,
  output                         s_axis_qdma_h2c_sim_tready,

  output                         m_axis_qdma_c2h_sim_tvalid,
  output                 [511:0] m_axis_qdma_c2h_sim_tdata,
  output                  [31:0] m_axis_qdma_c2h_sim_tcrc,
  output                         m_axis_qdma_c2h_sim_tlast,
  output                         m_axis_qdma_c2h_sim_ctrl_marker,
  output                   [2:0] m_axis_qdma_c2h_sim_ctrl_port_id,
  output                   [6:0] m_axis_qdma_c2h_sim_ctrl_ecc,
  output                  [15:0] m_axis_qdma_c2h_sim_ctrl_len,
  output                  [10:0] m_axis_qdma_c2h_sim_ctrl_qid,
  output                         m_axis_qdma_c2h_sim_ctrl_has_cmpt,
  output                   [5:0] m_axis_qdma_c2h_sim_mty,
  input                          m_axis_qdma_c2h_sim_tready,

  output                         m_axis_qdma_cpl_sim_tvalid,
  output                 [511:0] m_axis_qdma_cpl_sim_tdata,
  output                   [1:0] m_axis_qdma_cpl_sim_size,
  output                  [15:0] m_axis_qdma_cpl_sim_dpar,
  output                  [10:0] m_axis_qdma_cpl_sim_ctrl_qid,
  output                   [1:0] m_axis_qdma_cpl_sim_ctrl_cmpt_type,
  output                  [15:0] m_axis_qdma_cpl_sim_ctrl_wait_pld_pkt_id,
  output                   [2:0] m_axis_qdma_cpl_sim_ctrl_port_id,
  output                         m_axis_qdma_cpl_sim_ctrl_marker,
  output                         m_axis_qdma_cpl_sim_ctrl_user_trig,
  output                   [2:0] m_axis_qdma_cpl_sim_ctrl_col_idx,
  output                   [2:0] m_axis_qdma_cpl_sim_ctrl_err_idx,
  output                         m_axis_qdma_cpl_sim_ctrl_no_wrb_marker,
  input                          m_axis_qdma_cpl_sim_tready,

  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tuser_err,
  input      [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_sim_tready,

  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_sim_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_sim_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_sim_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_sim_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_sim_tuser_err,

  input                          powerup_rstn
`endif
);

  // Parameter DRC
  initial begin
    if (MIN_PKT_LEN > 256 || MIN_PKT_LEN < 64) begin
      $fatal("[%m] Minimum packet length should be within the range [64, 256]");
    end
    if (MAX_PKT_LEN > 9600 || MAX_PKT_LEN < 256) begin
      $fatal("[%m] Maximum packet length should be within the range [256, 9600]");
    end
    if (USE_PHYS_FUNC) begin
      if (NUM_QUEUE > 2048 || NUM_QUEUE < 1) begin
        $fatal("[%m] Number of queues should be within the range [1, 2048]");
      end
      if ((NUM_QUEUE & (NUM_QUEUE - 1)) != 0) begin
        $fatal("[%m] Number of queues should be 2^n");
      end
      if (NUM_PHYS_FUNC > 4 || NUM_PHYS_FUNC < 1) begin
        $fatal("[%m] Number of physical functions should be within the range [1, 4]");
      end
    end
    if (NUM_CMAC_PORT > 2 || NUM_CMAC_PORT < 1) begin
      $fatal("[%m] Number of CMACs should be within the range [1, 2]");
    end
  end

`ifdef __synthesis__
  wire         powerup_rstn;
  wire         pcie_user_lnk_up;
  wire         pcie_phy_ready;

  // BAR2-mapped master AXI-Lite feeding into system configuration block
  wire         axil_pcie_awvalid;
  wire  [31:0] axil_pcie_awaddr;
  wire         axil_pcie_awready;
  wire         axil_pcie_wvalid;
  wire  [31:0] axil_pcie_wdata;
  wire         axil_pcie_wready;
  wire         axil_pcie_bvalid;
  wire   [1:0] axil_pcie_bresp;
  wire         axil_pcie_bready;
  wire         axil_pcie_arvalid;
  wire  [31:0] axil_pcie_araddr;
  wire         axil_pcie_arready;
  wire         axil_pcie_rvalid;
  wire  [31:0] axil_pcie_rdata;
  wire   [1:0] axil_pcie_rresp;
  wire         axil_pcie_rready;

  IBUF pcie_rstn_ibuf_inst (.I(pcie_rstn), .O(pcie_rstn_int));

`ifdef __au280__
  // Fix the CATTRIP issue for AU280 custom flow
  //
  // This pin must be tied to 0; otherwise the board might be unrecoverable
  // after programming
  OBUF hbm_cattrip_obuf_inst (.I(1'b0), .O(hbm_cattrip));
`endif

`ifdef __zynq_family__
  zynq_usplus_ps zynq_usplus_ps_inst ();
`endif
`endif

  wire                         axil_qdma_awvalid;
  wire                  [31:0] axil_qdma_awaddr;
  wire                         axil_qdma_awready;
  wire                         axil_qdma_wvalid;
  wire                  [31:0] axil_qdma_wdata;
  wire                         axil_qdma_wready;
  wire                         axil_qdma_bvalid;
  wire                   [1:0] axil_qdma_bresp;
  wire                         axil_qdma_bready;
  wire                         axil_qdma_arvalid;
  wire                  [31:0] axil_qdma_araddr;
  wire                         axil_qdma_arready;
  wire                         axil_qdma_rvalid;
  wire                  [31:0] axil_qdma_rdata;
  wire                   [1:0] axil_qdma_rresp;
  wire                         axil_qdma_rready;

  wire     [NUM_CMAC_PORT-1:0] axil_adap_awvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_adap_awaddr;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_awready;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_wvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_adap_wdata;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_wready;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_bvalid;
  wire   [2*NUM_CMAC_PORT-1:0] axil_adap_bresp;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_bready;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_arvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_adap_araddr;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_arready;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_rvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_adap_rdata;
  wire   [2*NUM_CMAC_PORT-1:0] axil_adap_rresp;
  wire     [NUM_CMAC_PORT-1:0] axil_adap_rready;

  wire     [NUM_CMAC_PORT-1:0] axil_cmac_awvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_awaddr;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_awready;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_wvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_wdata;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_wready;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_bvalid;
  wire   [2*NUM_CMAC_PORT-1:0] axil_cmac_bresp;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_bready;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_arvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_araddr;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_arready;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_rvalid;
  wire  [32*NUM_CMAC_PORT-1:0] axil_cmac_rdata;
  wire   [2*NUM_CMAC_PORT-1:0] axil_cmac_rresp;
  wire     [NUM_CMAC_PORT-1:0] axil_cmac_rready;

  wire                         axil_box0_awvalid;
  wire                  [31:0] axil_box0_awaddr;
  wire                         axil_box0_awready;
  wire                         axil_box0_wvalid;
  wire                  [31:0] axil_box0_wdata;
  wire                         axil_box0_wready;
  wire                         axil_box0_bvalid;
  wire                   [1:0] axil_box0_bresp;
  wire                         axil_box0_bready;
  wire                         axil_box0_arvalid;
  wire                  [31:0] axil_box0_araddr;
  wire                         axil_box0_arready;
  wire                         axil_box0_rvalid;
  wire                  [31:0] axil_box0_rdata;
  wire                   [1:0] axil_box0_rresp;
  wire                         axil_box0_rready;

  wire                         axil_box1_awvalid;
  wire                  [31:0] axil_box1_awaddr;
  wire                         axil_box1_awready;
  wire                         axil_box1_wvalid;
  wire                  [31:0] axil_box1_wdata;
  wire                         axil_box1_wready;
  wire                         axil_box1_bvalid;
  wire                   [1:0] axil_box1_bresp;
  wire                         axil_box1_bready;
  wire                         axil_box1_arvalid;
  wire                  [31:0] axil_box1_araddr;
  wire                         axil_box1_arready;
  wire                         axil_box1_rvalid;
  wire                  [31:0] axil_box1_rdata;
  wire                   [1:0] axil_box1_rresp;
  wire                         axil_box1_rready;

  // QDMA subsystem interfaces to the box running at 250MHz
  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tvalid;
  wire [512*NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tdata;
  wire  [64*NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tkeep;
  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tlast;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tuser_size;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tuser_src;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tuser_dst;
  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_h2c_tready;

  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tvalid;
  wire [512*NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tdata;
  wire  [64*NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tkeep;
  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tlast;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tuser_size;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tuser_src;
  wire  [16*NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tuser_dst;
  wire     [NUM_PHYS_FUNC-1:0] axis_qdma_c2h_tready;

  // Packet adapter interfaces to the box running at 250MHz
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tlast;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tuser_size;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tuser_src;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tuser_dst;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_250mhz_tready;

  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tlast;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tuser_size;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tuser_src;
  wire  [16*NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tuser_dst;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_250mhz_tready;

  // Packet adapter interfaces to the box running at 322MHz
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tuser_err;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tready;

  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tuser_err;

  // CMAC subsystem interfaces to the box running at 322MHz
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_cmac_tx_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_cmac_tx_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tuser_err;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_tx_tready;

  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_cmac_rx_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_cmac_rx_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_cmac_rx_tuser_err;

  wire                  [31:0] shell_rstn;
  wire                  [31:0] shell_rst_done;
  wire                         qdma_rstn;
  wire                         qdma_rst_done;
  wire     [NUM_CMAC_PORT-1:0] adap_rstn;
  wire     [NUM_CMAC_PORT-1:0] adap_rst_done;
  wire     [NUM_CMAC_PORT-1:0] cmac_rstn;
  wire     [NUM_CMAC_PORT-1:0] cmac_rst_done;

  wire                  [31:0] user_rstn;
  wire                  [31:0] user_rst_done;
  wire                  [15:0] user_250mhz_rstn;
  wire                  [15:0] user_250mhz_rst_done;
  wire                   [7:0] user_322mhz_rstn;
  wire                   [7:0] user_322mhz_rst_done;
  wire                         box_250mhz_rstn;
  wire                         box_250mhz_rst_done;
  wire                         box_322mhz_rstn;
  wire                         box_322mhz_rst_done;

  wire                         axil_aclk;
  wire                         axis_aclk;
  wire     [NUM_CMAC_PORT-1:0] cmac_clk;

  // Unused reset pairs must have their "reset_done" tied to 1

  // First 4-bit for QDMA subsystem
  assign qdma_rstn           = shell_rstn[0];
  assign shell_rst_done[0]   = qdma_rst_done;
  assign shell_rst_done[3:1] = 3'b111;

  // For each CMAC port, use the subsequent 4-bit: bit 0 for CMAC subsystem and
  // bit 1 for the corresponding adapter
  generate for (genvar i = 0; i < NUM_CMAC_PORT; i++) begin: cmac_rst
    assign {adap_rstn[i], cmac_rstn[i]} = {shell_rstn[(i+1)*4+1], shell_rstn[(i+1)*4]};
    assign shell_rst_done[(i+1)*4 +: 4] = {2'b11, adap_rst_done[i], cmac_rst_done[i]};
  end: cmac_rst
  endgenerate

  generate for (genvar i = (NUM_CMAC_PORT+1)*4; i < 32; i++) begin: unused_rst
    assign shell_rst_done[i] = 1'b1;
  end: unused_rst
  endgenerate

  // The box running at 250MHz takes 16+1 user reset pairs, with the extra one
  // used by the box itself.  Similarly, the box running at 322MHz takes 8+1
  // pairs.  The mapping is as follows.
  //
  // | 31    | 30    | 29 ... 24 | 23 ... 16 | 15 ... 0 |
  // ----------------------------------------------------
  // | b@250 | b@322 | Reserved  | user@322  | user@250 |
  assign user_250mhz_rstn     = user_rstn[15:0];
  assign user_rst_done[15:0]  = user_250mhz_rst_done;
  assign user_322mhz_rstn     = user_rstn[23:16];
  assign user_rst_done[23:16] = user_322mhz_rst_done;

  assign box_250mhz_rstn      = user_rstn[31];
  assign user_rst_done[31]    = box_250mhz_rst_done;
  assign box_322mhz_rstn      = user_rstn[30];
  assign user_rst_done[30]    = box_322mhz_rst_done;

  // Unused pairs must have their rst_done signals tied to 1
  assign user_rst_done[29:24] = {6{1'b1}};

  system_config #(
    .BUILD_TIMESTAMP (BUILD_TIMESTAMP),
    .NUM_CMAC_PORT   (NUM_CMAC_PORT)
  ) system_config_inst (
`ifdef __synthesis__
    .s_axil_awvalid      (axil_pcie_awvalid),
    .s_axil_awaddr       (axil_pcie_awaddr),
    .s_axil_awready      (axil_pcie_awready),
    .s_axil_wvalid       (axil_pcie_wvalid),
    .s_axil_wdata        (axil_pcie_wdata),
    .s_axil_wready       (axil_pcie_wready),
    .s_axil_bvalid       (axil_pcie_bvalid),
    .s_axil_bresp        (axil_pcie_bresp),
    .s_axil_bready       (axil_pcie_bready),
    .s_axil_arvalid      (axil_pcie_arvalid),
    .s_axil_araddr       (axil_pcie_araddr),
    .s_axil_arready      (axil_pcie_arready),
    .s_axil_rvalid       (axil_pcie_rvalid),
    .s_axil_rdata        (axil_pcie_rdata),
    .s_axil_rresp        (axil_pcie_rresp),
    .s_axil_rready       (axil_pcie_rready),
`else // !`ifdef __synthesis__
    .s_axil_awvalid      (s_axil_sim_awvalid),
    .s_axil_awaddr       (s_axil_sim_awaddr),
    .s_axil_awready      (s_axil_sim_awready),
    .s_axil_wvalid       (s_axil_sim_wvalid),
    .s_axil_wdata        (s_axil_sim_wdata),
    .s_axil_wready       (s_axil_sim_wready),
    .s_axil_bvalid       (s_axil_sim_bvalid),
    .s_axil_bresp        (s_axil_sim_bresp),
    .s_axil_bready       (s_axil_sim_bready),
    .s_axil_arvalid      (s_axil_sim_arvalid),
    .s_axil_araddr       (s_axil_sim_araddr),
    .s_axil_arready      (s_axil_sim_arready),
    .s_axil_rvalid       (s_axil_sim_rvalid),
    .s_axil_rdata        (s_axil_sim_rdata),
    .s_axil_rresp        (s_axil_sim_rresp),
    .s_axil_rready       (s_axil_sim_rready),
`endif

    .m_axil_qdma_awvalid (axil_qdma_awvalid),
    .m_axil_qdma_awaddr  (axil_qdma_awaddr),
    .m_axil_qdma_awready (axil_qdma_awready),
    .m_axil_qdma_wvalid  (axil_qdma_wvalid),
    .m_axil_qdma_wdata   (axil_qdma_wdata),
    .m_axil_qdma_wready  (axil_qdma_wready),
    .m_axil_qdma_bvalid  (axil_qdma_bvalid),
    .m_axil_qdma_bresp   (axil_qdma_bresp),
    .m_axil_qdma_bready  (axil_qdma_bready),
    .m_axil_qdma_arvalid (axil_qdma_arvalid),
    .m_axil_qdma_araddr  (axil_qdma_araddr),
    .m_axil_qdma_arready (axil_qdma_arready),
    .m_axil_qdma_rvalid  (axil_qdma_rvalid),
    .m_axil_qdma_rdata   (axil_qdma_rdata),
    .m_axil_qdma_rresp   (axil_qdma_rresp),
    .m_axil_qdma_rready  (axil_qdma_rready),

    .m_axil_adap_awvalid (axil_adap_awvalid),
    .m_axil_adap_awaddr  (axil_adap_awaddr),
    .m_axil_adap_awready (axil_adap_awready),
    .m_axil_adap_wvalid  (axil_adap_wvalid),
    .m_axil_adap_wdata   (axil_adap_wdata),
    .m_axil_adap_wready  (axil_adap_wready),
    .m_axil_adap_bvalid  (axil_adap_bvalid),
    .m_axil_adap_bresp   (axil_adap_bresp),
    .m_axil_adap_bready  (axil_adap_bready),
    .m_axil_adap_arvalid (axil_adap_arvalid),
    .m_axil_adap_araddr  (axil_adap_araddr),
    .m_axil_adap_arready (axil_adap_arready),
    .m_axil_adap_rvalid  (axil_adap_rvalid),
    .m_axil_adap_rdata   (axil_adap_rdata),
    .m_axil_adap_rresp   (axil_adap_rresp),
    .m_axil_adap_rready  (axil_adap_rready),

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

    .m_axil_box0_awvalid (axil_box0_awvalid),
    .m_axil_box0_awaddr  (axil_box0_awaddr),
    .m_axil_box0_awready (axil_box0_awready),
    .m_axil_box0_wvalid  (axil_box0_wvalid),
    .m_axil_box0_wdata   (axil_box0_wdata),
    .m_axil_box0_wready  (axil_box0_wready),
    .m_axil_box0_bvalid  (axil_box0_bvalid),
    .m_axil_box0_bresp   (axil_box0_bresp),
    .m_axil_box0_bready  (axil_box0_bready),
    .m_axil_box0_arvalid (axil_box0_arvalid),
    .m_axil_box0_araddr  (axil_box0_araddr),
    .m_axil_box0_arready (axil_box0_arready),
    .m_axil_box0_rvalid  (axil_box0_rvalid),
    .m_axil_box0_rdata   (axil_box0_rdata),
    .m_axil_box0_rresp   (axil_box0_rresp),
    .m_axil_box0_rready  (axil_box0_rready),

    .m_axil_box1_awvalid (axil_box1_awvalid),
    .m_axil_box1_awaddr  (axil_box1_awaddr),
    .m_axil_box1_awready (axil_box1_awready),
    .m_axil_box1_wvalid  (axil_box1_wvalid),
    .m_axil_box1_wdata   (axil_box1_wdata),
    .m_axil_box1_wready  (axil_box1_wready),
    .m_axil_box1_bvalid  (axil_box1_bvalid),
    .m_axil_box1_bresp   (axil_box1_bresp),
    .m_axil_box1_bready  (axil_box1_bready),
    .m_axil_box1_arvalid (axil_box1_arvalid),
    .m_axil_box1_araddr  (axil_box1_araddr),
    .m_axil_box1_arready (axil_box1_arready),
    .m_axil_box1_rvalid  (axil_box1_rvalid),
    .m_axil_box1_rdata   (axil_box1_rdata),
    .m_axil_box1_rresp   (axil_box1_rresp),
    .m_axil_box1_rready  (axil_box1_rready),

    .shell_rstn          (shell_rstn),
    .shell_rst_done      (shell_rst_done),
    .user_rstn           (user_rstn),
    .user_rst_done       (user_rst_done),

    .aclk                (axil_aclk),
    .aresetn             (powerup_rstn)
  );

  qdma_subsystem #(
    .MIN_PKT_LEN   (MIN_PKT_LEN),
    .MAX_PKT_LEN   (MAX_PKT_LEN),
    .USE_PHYS_FUNC (USE_PHYS_FUNC),
    .NUM_PHYS_FUNC (NUM_PHYS_FUNC),
    .NUM_QUEUE     (NUM_QUEUE)
  ) qdma_subsystem_inst (
    .s_axil_awvalid                       (axil_qdma_awvalid),
    .s_axil_awaddr                        (axil_qdma_awaddr),
    .s_axil_awready                       (axil_qdma_awready),
    .s_axil_wvalid                        (axil_qdma_wvalid),
    .s_axil_wdata                         (axil_qdma_wdata),
    .s_axil_wready                        (axil_qdma_wready),
    .s_axil_bvalid                        (axil_qdma_bvalid),
    .s_axil_bresp                         (axil_qdma_bresp),
    .s_axil_bready                        (axil_qdma_bready),
    .s_axil_arvalid                       (axil_qdma_arvalid),
    .s_axil_araddr                        (axil_qdma_araddr),
    .s_axil_arready                       (axil_qdma_arready),
    .s_axil_rvalid                        (axil_qdma_rvalid),
    .s_axil_rdata                         (axil_qdma_rdata),
    .s_axil_rresp                         (axil_qdma_rresp),
    .s_axil_rready                        (axil_qdma_rready),

    .m_axis_h2c_tvalid                    (axis_qdma_h2c_tvalid),
    .m_axis_h2c_tdata                     (axis_qdma_h2c_tdata),
    .m_axis_h2c_tkeep                     (axis_qdma_h2c_tkeep),
    .m_axis_h2c_tlast                     (axis_qdma_h2c_tlast),
    .m_axis_h2c_tuser_size                (axis_qdma_h2c_tuser_size),
    .m_axis_h2c_tuser_src                 (axis_qdma_h2c_tuser_src),
    .m_axis_h2c_tuser_dst                 (axis_qdma_h2c_tuser_dst),
    .m_axis_h2c_tready                    (axis_qdma_h2c_tready),

    .s_axis_c2h_tvalid                    (axis_qdma_c2h_tvalid),
    .s_axis_c2h_tdata                     (axis_qdma_c2h_tdata),
    .s_axis_c2h_tkeep                     (axis_qdma_c2h_tkeep),
    .s_axis_c2h_tlast                     (axis_qdma_c2h_tlast),
    .s_axis_c2h_tuser_size                (axis_qdma_c2h_tuser_size),
    .s_axis_c2h_tuser_src                 (axis_qdma_c2h_tuser_src),
    .s_axis_c2h_tuser_dst                 (axis_qdma_c2h_tuser_dst),
    .s_axis_c2h_tready                    (axis_qdma_c2h_tready),

`ifdef __synthesis__
    .pcie_rxp                             (pcie_rxp),
    .pcie_rxn                             (pcie_rxn),
    .pcie_txp                             (pcie_txp),
    .pcie_txn                             (pcie_txn),

    .m_axil_pcie_awvalid                  (axil_pcie_awvalid),
    .m_axil_pcie_awaddr                   (axil_pcie_awaddr),
    .m_axil_pcie_awready                  (axil_pcie_awready),
    .m_axil_pcie_wvalid                   (axil_pcie_wvalid),
    .m_axil_pcie_wdata                    (axil_pcie_wdata),
    .m_axil_pcie_wready                   (axil_pcie_wready),
    .m_axil_pcie_bvalid                   (axil_pcie_bvalid),
    .m_axil_pcie_bresp                    (axil_pcie_bresp),
    .m_axil_pcie_bready                   (axil_pcie_bready),
    .m_axil_pcie_arvalid                  (axil_pcie_arvalid),
    .m_axil_pcie_araddr                   (axil_pcie_araddr),
    .m_axil_pcie_arready                  (axil_pcie_arready),
    .m_axil_pcie_rvalid                   (axil_pcie_rvalid),
    .m_axil_pcie_rdata                    (axil_pcie_rdata),
    .m_axil_pcie_rresp                    (axil_pcie_rresp),
    .m_axil_pcie_rready                   (axil_pcie_rready),

    .pcie_refclk_p                        (pcie_refclk_p),
    .pcie_refclk_n                        (pcie_refclk_n),
    .pcie_rstn                            (pcie_rstn_int),
    .user_lnk_up                          (pcie_user_lnk_up),
    .phy_ready                            (pcie_phy_ready),
    .powerup_rstn                         (powerup_rstn),
`else // !`ifdef __synthesis__
    .s_axis_qdma_h2c_tvalid               (s_axis_qdma_h2c_sim_tvalid),
    .s_axis_qdma_h2c_tdata                (s_axis_qdma_h2c_sim_tdata),
    .s_axis_qdma_h2c_tcrc                 (s_axis_qdma_h2c_sim_tcrc),
    .s_axis_qdma_h2c_tlast                (s_axis_qdma_h2c_sim_tlast),
    .s_axis_qdma_h2c_tuser_qid            (s_axis_qdma_h2c_sim_tuser_qid),
    .s_axis_qdma_h2c_tuser_port_id        (s_axis_qdma_h2c_sim_tuser_port_id),
    .s_axis_qdma_h2c_tuser_err            (s_axis_qdma_h2c_sim_tuser_err),
    .s_axis_qdma_h2c_tuser_mdata          (s_axis_qdma_h2c_sim_tuser_mdata),
    .s_axis_qdma_h2c_tuser_mty            (s_axis_qdma_h2c_sim_tuser_mty),
    .s_axis_qdma_h2c_tuser_zero_byte      (s_axis_qdma_h2c_sim_tuser_zero_byte),
    .s_axis_qdma_h2c_tready               (s_axis_qdma_h2c_sim_tready),

    .m_axis_qdma_c2h_tvalid               (m_axis_qdma_c2h_sim_tvalid),
    .m_axis_qdma_c2h_tdata                (m_axis_qdma_c2h_sim_tdata),
    .m_axis_qdma_c2h_tcrc                 (m_axis_qdma_c2h_sim_tcrc),
    .m_axis_qdma_c2h_tlast                (m_axis_qdma_c2h_sim_tlast),
    .m_axis_qdma_c2h_ctrl_marker          (m_axis_qdma_c2h_sim_ctrl_marker),
    .m_axis_qdma_c2h_ctrl_port_id         (m_axis_qdma_c2h_sim_ctrl_port_id),
    .m_axis_qdma_c2h_ctrl_ecc             (m_axis_qdma_c2h_sim_ctrl_ecc),
    .m_axis_qdma_c2h_ctrl_len             (m_axis_qdma_c2h_sim_ctrl_len),
    .m_axis_qdma_c2h_ctrl_qid             (m_axis_qdma_c2h_sim_ctrl_qid),
    .m_axis_qdma_c2h_ctrl_has_cmpt        (m_axis_qdma_c2h_sim_ctrl_has_cmpt),
    .m_axis_qdma_c2h_mty                  (m_axis_qdma_c2h_sim_mty),
    .m_axis_qdma_c2h_tready               (m_axis_qdma_c2h_sim_tready),

    .m_axis_qdma_cpl_tvalid               (m_axis_qdma_cpl_sim_tvalid),
    .m_axis_qdma_cpl_tdata                (m_axis_qdma_cpl_sim_tdata),
    .m_axis_qdma_cpl_size                 (m_axis_qdma_cpl_sim_size),
    .m_axis_qdma_cpl_dpar                 (m_axis_qdma_cpl_sim_dpar),
    .m_axis_qdma_cpl_ctrl_qid             (m_axis_qdma_cpl_sim_ctrl_qid),
    .m_axis_qdma_cpl_ctrl_cmpt_type       (m_axis_qdma_cpl_sim_ctrl_cmpt_type),
    .m_axis_qdma_cpl_ctrl_wait_pld_pkt_id (m_axis_qdma_cpl_sim_ctrl_wait_pld_pkt_id),
    .m_axis_qdma_cpl_ctrl_port_id         (m_axis_qdma_cpl_sim_ctrl_port_id),
    .m_axis_qdma_cpl_ctrl_marker          (m_axis_qdma_cpl_sim_ctrl_marker),
    .m_axis_qdma_cpl_ctrl_user_trig       (m_axis_qdma_cpl_sim_ctrl_user_trig),
    .m_axis_qdma_cpl_ctrl_col_idx         (m_axis_qdma_cpl_sim_ctrl_col_idx),
    .m_axis_qdma_cpl_ctrl_err_idx         (m_axis_qdma_cpl_sim_ctrl_err_idx),
    .m_axis_qdma_cpl_ctrl_no_wrb_marker   (m_axis_qdma_cpl_sim_ctrl_no_wrb_marker),
    .m_axis_qdma_cpl_tready               (m_axis_qdma_cpl_sim_tready),
`endif

    .mod_rstn                             (qdma_rstn),
    .mod_rst_done                         (qdma_rst_done),

    .axil_aclk                            (axil_aclk),
    .axis_aclk                            (axis_aclk)
  );

  generate for (genvar i = 0; i < NUM_CMAC_PORT; i++) begin: cmac_port
    packet_adapter #(
      .CMAC_ID     (i),
      .MIN_PKT_LEN (MIN_PKT_LEN),
      .MAX_PKT_LEN (MAX_PKT_LEN)
    ) packet_adapter_inst (
      .s_axil_awvalid       (axil_adap_awvalid[i]),
      .s_axil_awaddr        (axil_adap_awaddr[`getvec(32, i)]),
      .s_axil_awready       (axil_adap_awready[i]),
      .s_axil_wvalid        (axil_adap_wvalid[i]),
      .s_axil_wdata         (axil_adap_wdata[`getvec(32, i)]),
      .s_axil_wready        (axil_adap_wready[i]),
      .s_axil_bvalid        (axil_adap_bvalid[i]),
      .s_axil_bresp         (axil_adap_bresp[`getvec(2, i)]),
      .s_axil_bready        (axil_adap_bready[i]),
      .s_axil_arvalid       (axil_adap_arvalid[i]),
      .s_axil_araddr        (axil_adap_araddr[`getvec(32, i)]),
      .s_axil_arready       (axil_adap_arready[i]),
      .s_axil_rvalid        (axil_adap_rvalid[i]),
      .s_axil_rdata         (axil_adap_rdata[`getvec(32, i)]),
      .s_axil_rresp         (axil_adap_rresp[`getvec(2, i)]),
      .s_axil_rready        (axil_adap_rready[i]),

      .s_axis_tx_tvalid     (axis_adap_tx_250mhz_tvalid[i]),
      .s_axis_tx_tdata      (axis_adap_tx_250mhz_tdata[`getvec(512, i)]),
      .s_axis_tx_tkeep      (axis_adap_tx_250mhz_tkeep[`getvec(64, i)]),
      .s_axis_tx_tlast      (axis_adap_tx_250mhz_tlast[i]),
      .s_axis_tx_tuser_size (axis_adap_tx_250mhz_tuser_size[`getvec(16, i)]),
      .s_axis_tx_tuser_src  (axis_adap_tx_250mhz_tuser_src[`getvec(16, i)]),
      .s_axis_tx_tuser_dst  (axis_adap_tx_250mhz_tuser_dst[`getvec(16, i)]),
      .s_axis_tx_tready     (axis_adap_tx_250mhz_tready[i]),

      .m_axis_rx_tvalid     (axis_adap_rx_250mhz_tvalid[i]),
      .m_axis_rx_tdata      (axis_adap_rx_250mhz_tdata[`getvec(512, i)]),
      .m_axis_rx_tkeep      (axis_adap_rx_250mhz_tkeep[`getvec(64, i)]),
      .m_axis_rx_tlast      (axis_adap_rx_250mhz_tlast[i]),
      .m_axis_rx_tuser_size (axis_adap_rx_250mhz_tuser_size[`getvec(16, i)]),
      .m_axis_rx_tuser_src  (axis_adap_rx_250mhz_tuser_src[`getvec(16, i)]),
      .m_axis_rx_tuser_dst  (axis_adap_rx_250mhz_tuser_dst[`getvec(16, i)]),
      .m_axis_rx_tready     (axis_adap_rx_250mhz_tready[i]),

      .m_axis_tx_tvalid     (axis_adap_tx_322mhz_tvalid[i]),
      .m_axis_tx_tdata      (axis_adap_tx_322mhz_tdata[`getvec(512, i)]),
      .m_axis_tx_tkeep      (axis_adap_tx_322mhz_tkeep[`getvec(64, i)]),
      .m_axis_tx_tlast      (axis_adap_tx_322mhz_tlast[i]),
      .m_axis_tx_tuser_err  (axis_adap_tx_322mhz_tuser_err[i]),
      .m_axis_tx_tready     (axis_adap_tx_322mhz_tready[i]),

      .s_axis_rx_tvalid     (axis_adap_rx_322mhz_tvalid[i]),
      .s_axis_rx_tdata      (axis_adap_rx_322mhz_tdata[`getvec(512, i)]),
      .s_axis_rx_tkeep      (axis_adap_rx_322mhz_tkeep[`getvec(64, i)]),
      .s_axis_rx_tlast      (axis_adap_rx_322mhz_tlast[i]),
      .s_axis_rx_tuser_err  (axis_adap_rx_322mhz_tuser_err[i]),

      .mod_rstn             (adap_rstn[i]),
      .mod_rst_done         (adap_rst_done[i]),

      .axil_aclk            (axil_aclk),
      .axis_aclk            (axis_aclk),
      .cmac_clk             (cmac_clk[i])
    );

    cmac_subsystem #(
      .CMAC_ID     (i),
      .MIN_PKT_LEN (MIN_PKT_LEN),
      .MAX_PKT_LEN (MAX_PKT_LEN)
    ) cmac_subsystem_inst (
      .s_axil_awvalid               (axil_cmac_awvalid[i]),
      .s_axil_awaddr                (axil_cmac_awaddr[`getvec(32, i)]),
      .s_axil_awready               (axil_cmac_awready[i]),
      .s_axil_wvalid                (axil_cmac_wvalid[i]),
      .s_axil_wdata                 (axil_cmac_wdata[`getvec(32, i)]),
      .s_axil_wready                (axil_cmac_wready[i]),
      .s_axil_bvalid                (axil_cmac_bvalid[i]),
      .s_axil_bresp                 (axil_cmac_bresp[`getvec(2, i)]),
      .s_axil_bready                (axil_cmac_bready[i]),
      .s_axil_arvalid               (axil_cmac_arvalid[i]),
      .s_axil_araddr                (axil_cmac_araddr[`getvec(32, i)]),
      .s_axil_arready               (axil_cmac_arready[i]),
      .s_axil_rvalid                (axil_cmac_rvalid[i]),
      .s_axil_rdata                 (axil_cmac_rdata[`getvec(32, i)]),
      .s_axil_rresp                 (axil_cmac_rresp[`getvec(2, i)]),
      .s_axil_rready                (axil_cmac_rready[i]),

      .s_axis_cmac_tx_tvalid        (axis_cmac_tx_tvalid[i]),
      .s_axis_cmac_tx_tdata         (axis_cmac_tx_tdata[`getvec(512, i)]),
      .s_axis_cmac_tx_tkeep         (axis_cmac_tx_tkeep[`getvec(64, i)]),
      .s_axis_cmac_tx_tlast         (axis_cmac_tx_tlast[i]),
      .s_axis_cmac_tx_tuser_err     (axis_cmac_tx_tuser_err[i]),
      .s_axis_cmac_tx_tready        (axis_cmac_tx_tready[i]),

      .m_axis_cmac_rx_tvalid        (axis_cmac_rx_tvalid[i]),
      .m_axis_cmac_rx_tdata         (axis_cmac_rx_tdata[`getvec(512, i)]),
      .m_axis_cmac_rx_tkeep         (axis_cmac_rx_tkeep[`getvec(64, i)]),
      .m_axis_cmac_rx_tlast         (axis_cmac_rx_tlast[i]),
      .m_axis_cmac_rx_tuser_err     (axis_cmac_rx_tuser_err[i]),

`ifdef __synthesis__
      .gt_rxp                       (qsfp_rxp[`getvec(4, i)]),
      .gt_rxn                       (qsfp_rxn[`getvec(4, i)]),
      .gt_txp                       (qsfp_txp[`getvec(4, i)]),
      .gt_txn                       (qsfp_txn[`getvec(4, i)]),
      .gt_refclk_p                  (qsfp_refclk_p[i]),
      .gt_refclk_n                  (qsfp_refclk_n[i]),

      .cmac_clk                     (cmac_clk[i]),
`else
      .m_axis_cmac_tx_sim_tvalid    (m_axis_cmac_tx_sim_tvalid[i]),
      .m_axis_cmac_tx_sim_tdata     (m_axis_cmac_tx_sim_tdata[`getvec(512, i)]),
      .m_axis_cmac_tx_sim_tkeep     (m_axis_cmac_tx_sim_tkeep[`getvec(64, i)]),
      .m_axis_cmac_tx_sim_tlast     (m_axis_cmac_tx_sim_tlast[i]),
      .m_axis_cmac_tx_sim_tuser_err (m_axis_cmac_tx_sim_tuser_err[i]),
      .m_axis_cmac_tx_sim_tready    (m_axis_cmac_tx_sim_tready[i]),

      .s_axis_cmac_rx_sim_tvalid    (s_axis_cmac_rx_sim_tvalid[i]),
      .s_axis_cmac_rx_sim_tdata     (s_axis_cmac_rx_sim_tdata[`getvec(512, i)]),
      .s_axis_cmac_rx_sim_tkeep     (s_axis_cmac_rx_sim_tkeep[`getvec(64, i)]),
      .s_axis_cmac_rx_sim_tlast     (s_axis_cmac_rx_sim_tlast[i]),
      .s_axis_cmac_rx_sim_tuser_err (s_axis_cmac_rx_sim_tuser_err[i]),

      .cmac_clk                     (cmac_clk[i]),
`endif

      .mod_rstn                     (cmac_rstn[i]),
      .mod_rst_done                 (cmac_rst_done[i]),
      .axil_aclk                    (axil_aclk)
    );
  end: cmac_port
  endgenerate

  box_250mhz #(
    .MIN_PKT_LEN   (MIN_PKT_LEN),
    .MAX_PKT_LEN   (MAX_PKT_LEN),
    .USE_PHYS_FUNC (USE_PHYS_FUNC),
    .NUM_PHYS_FUNC (NUM_PHYS_FUNC),
    .NUM_CMAC_PORT (NUM_CMAC_PORT)
  ) box_250mhz_inst (
    .s_axil_awvalid                   (axil_box0_awvalid),
    .s_axil_awaddr                    (axil_box0_awaddr),
    .s_axil_awready                   (axil_box0_awready),
    .s_axil_wvalid                    (axil_box0_wvalid),
    .s_axil_wdata                     (axil_box0_wdata),
    .s_axil_wready                    (axil_box0_wready),
    .s_axil_bvalid                    (axil_box0_bvalid),
    .s_axil_bresp                     (axil_box0_bresp),
    .s_axil_bready                    (axil_box0_bready),
    .s_axil_arvalid                   (axil_box0_arvalid),
    .s_axil_araddr                    (axil_box0_araddr),
    .s_axil_arready                   (axil_box0_arready),
    .s_axil_rvalid                    (axil_box0_rvalid),
    .s_axil_rdata                     (axil_box0_rdata),
    .s_axil_rresp                     (axil_box0_rresp),
    .s_axil_rready                    (axil_box0_rready),

    .s_axis_qdma_h2c_tvalid           (axis_qdma_h2c_tvalid),
    .s_axis_qdma_h2c_tdata            (axis_qdma_h2c_tdata),
    .s_axis_qdma_h2c_tkeep            (axis_qdma_h2c_tkeep),
    .s_axis_qdma_h2c_tlast            (axis_qdma_h2c_tlast),
    .s_axis_qdma_h2c_tuser_size       (axis_qdma_h2c_tuser_size),
    .s_axis_qdma_h2c_tuser_src        (axis_qdma_h2c_tuser_src),
    .s_axis_qdma_h2c_tuser_dst        (axis_qdma_h2c_tuser_dst),
    .s_axis_qdma_h2c_tready           (axis_qdma_h2c_tready),

    .m_axis_qdma_c2h_tvalid           (axis_qdma_c2h_tvalid),
    .m_axis_qdma_c2h_tdata            (axis_qdma_c2h_tdata),
    .m_axis_qdma_c2h_tkeep            (axis_qdma_c2h_tkeep),
    .m_axis_qdma_c2h_tlast            (axis_qdma_c2h_tlast),
    .m_axis_qdma_c2h_tuser_size       (axis_qdma_c2h_tuser_size),
    .m_axis_qdma_c2h_tuser_src        (axis_qdma_c2h_tuser_src),
    .m_axis_qdma_c2h_tuser_dst        (axis_qdma_c2h_tuser_dst),
    .m_axis_qdma_c2h_tready           (axis_qdma_c2h_tready),

    .m_axis_adap_tx_250mhz_tvalid     (axis_adap_tx_250mhz_tvalid),
    .m_axis_adap_tx_250mhz_tdata      (axis_adap_tx_250mhz_tdata),
    .m_axis_adap_tx_250mhz_tkeep      (axis_adap_tx_250mhz_tkeep),
    .m_axis_adap_tx_250mhz_tlast      (axis_adap_tx_250mhz_tlast),
    .m_axis_adap_tx_250mhz_tuser_size (axis_adap_tx_250mhz_tuser_size),
    .m_axis_adap_tx_250mhz_tuser_src  (axis_adap_tx_250mhz_tuser_src),
    .m_axis_adap_tx_250mhz_tuser_dst  (axis_adap_tx_250mhz_tuser_dst),
    .m_axis_adap_tx_250mhz_tready     (axis_adap_tx_250mhz_tready),

    .s_axis_adap_rx_250mhz_tvalid     (axis_adap_rx_250mhz_tvalid),
    .s_axis_adap_rx_250mhz_tdata      (axis_adap_rx_250mhz_tdata),
    .s_axis_adap_rx_250mhz_tkeep      (axis_adap_rx_250mhz_tkeep),
    .s_axis_adap_rx_250mhz_tlast      (axis_adap_rx_250mhz_tlast),
    .s_axis_adap_rx_250mhz_tuser_size (axis_adap_rx_250mhz_tuser_size),
    .s_axis_adap_rx_250mhz_tuser_src  (axis_adap_rx_250mhz_tuser_src),
    .s_axis_adap_rx_250mhz_tuser_dst  (axis_adap_rx_250mhz_tuser_dst),
    .s_axis_adap_rx_250mhz_tready     (axis_adap_rx_250mhz_tready),

    .mod_rstn                         (user_250mhz_rstn),
    .mod_rst_done                     (user_250mhz_rst_done),

    .box_rstn                         (box_250mhz_rstn),
    .box_rst_done                     (box_250mhz_rst_done),

    .axil_aclk                        (axil_aclk),
    .axis_aclk                        (axis_aclk)
  );

  box_322mhz #(
    .MIN_PKT_LEN   (MIN_PKT_LEN),
    .MAX_PKT_LEN   (MAX_PKT_LEN),
    .NUM_CMAC_PORT (NUM_CMAC_PORT)
  ) box_322mhz_inst (
    .s_axil_awvalid                  (axil_box1_awvalid),
    .s_axil_awaddr                   (axil_box1_awaddr),
    .s_axil_awready                  (axil_box1_awready),
    .s_axil_wvalid                   (axil_box1_wvalid),
    .s_axil_wdata                    (axil_box1_wdata),
    .s_axil_wready                   (axil_box1_wready),
    .s_axil_bvalid                   (axil_box1_bvalid),
    .s_axil_bresp                    (axil_box1_bresp),
    .s_axil_bready                   (axil_box1_bready),
    .s_axil_arvalid                  (axil_box1_arvalid),
    .s_axil_araddr                   (axil_box1_araddr),
    .s_axil_arready                  (axil_box1_arready),
    .s_axil_rvalid                   (axil_box1_rvalid),
    .s_axil_rdata                    (axil_box1_rdata),
    .s_axil_rresp                    (axil_box1_rresp),
    .s_axil_rready                   (axil_box1_rready),

    .s_axis_adap_tx_322mhz_tvalid    (axis_adap_tx_322mhz_tvalid),
    .s_axis_adap_tx_322mhz_tdata     (axis_adap_tx_322mhz_tdata),
    .s_axis_adap_tx_322mhz_tkeep     (axis_adap_tx_322mhz_tkeep),
    .s_axis_adap_tx_322mhz_tlast     (axis_adap_tx_322mhz_tlast),
    .s_axis_adap_tx_322mhz_tuser_err (axis_adap_tx_322mhz_tuser_err),
    .s_axis_adap_tx_322mhz_tready    (axis_adap_tx_322mhz_tready),

    .m_axis_adap_rx_322mhz_tvalid    (axis_adap_rx_322mhz_tvalid),
    .m_axis_adap_rx_322mhz_tdata     (axis_adap_rx_322mhz_tdata),
    .m_axis_adap_rx_322mhz_tkeep     (axis_adap_rx_322mhz_tkeep),
    .m_axis_adap_rx_322mhz_tlast     (axis_adap_rx_322mhz_tlast),
    .m_axis_adap_rx_322mhz_tuser_err (axis_adap_rx_322mhz_tuser_err),

    .m_axis_cmac_tx_tvalid           (axis_cmac_tx_tvalid),
    .m_axis_cmac_tx_tdata            (axis_cmac_tx_tdata),
    .m_axis_cmac_tx_tkeep            (axis_cmac_tx_tkeep),
    .m_axis_cmac_tx_tlast            (axis_cmac_tx_tlast),
    .m_axis_cmac_tx_tuser_err        (axis_cmac_tx_tuser_err),
    .m_axis_cmac_tx_tready           (axis_cmac_tx_tready),

    .s_axis_cmac_rx_tvalid           (axis_cmac_rx_tvalid),
    .s_axis_cmac_rx_tdata            (axis_cmac_rx_tdata),
    .s_axis_cmac_rx_tkeep            (axis_cmac_rx_tkeep),
    .s_axis_cmac_rx_tlast            (axis_cmac_rx_tlast),
    .s_axis_cmac_rx_tuser_err        (axis_cmac_rx_tuser_err),

    .mod_rstn                        (user_322mhz_rstn),
    .mod_rst_done                    (user_322mhz_rst_done),

    .box_rstn                        (box_322mhz_rstn),
    .box_rst_done                    (box_322mhz_rst_done),

    .axil_aclk                       (axil_aclk),
    .cmac_clk                        (cmac_clk)
  );

endmodule: open_nic_shell
