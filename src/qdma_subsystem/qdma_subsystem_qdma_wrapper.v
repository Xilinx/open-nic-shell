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
// This module wraps up the QDMA IP.  It creates two clock domains: one for the
// data path running at 250MHz, and the other for the AXI-Lite register
// interface running at 125MHz.
`timescale 1ns/1ps
module qdma_subsystem_qdma_wrapper (
  input   [15:0] pcie_rxp,
  input   [15:0] pcie_rxn,
  output  [15:0] pcie_txp,
  output  [15:0] pcie_txn,

  output         m_axil_awvalid,
  output  [31:0] m_axil_awaddr,
  input          m_axil_awready,
  output         m_axil_wvalid,
  output  [31:0] m_axil_wdata,
  input          m_axil_wready,
  input          m_axil_bvalid,
  input    [1:0] m_axil_bresp,
  output         m_axil_bready,
  output         m_axil_arvalid,
  output  [31:0] m_axil_araddr,
  input          m_axil_arready,
  input          m_axil_rvalid,
  input   [31:0] m_axil_rdata,
  input    [1:0] m_axil_rresp,
  output         m_axil_rready,

  output         m_axis_h2c_tvalid,
  output [511:0] m_axis_h2c_tdata,
  output  [31:0] m_axis_h2c_tcrc,
  output         m_axis_h2c_tlast,
  output  [10:0] m_axis_h2c_tuser_qid,
  output   [2:0] m_axis_h2c_tuser_port_id,
  output         m_axis_h2c_tuser_err,
  output  [31:0] m_axis_h2c_tuser_mdata,
  output   [5:0] m_axis_h2c_tuser_mty,
  output         m_axis_h2c_tuser_zero_byte,
  input          m_axis_h2c_tready,

  input          s_axis_c2h_tvalid,
  input  [511:0] s_axis_c2h_tdata,
  input   [31:0] s_axis_c2h_tcrc,
  input          s_axis_c2h_tlast,
  input          s_axis_c2h_ctrl_marker,
  input    [2:0] s_axis_c2h_ctrl_port_id,
  input    [6:0] s_axis_c2h_ctrl_ecc,
  input   [15:0] s_axis_c2h_ctrl_len,
  input   [10:0] s_axis_c2h_ctrl_qid,
  input          s_axis_c2h_ctrl_has_cmpt,
  input    [5:0] s_axis_c2h_mty,
  output         s_axis_c2h_tready,

  input          s_axis_cpl_tvalid,
  input  [511:0] s_axis_cpl_tdata,
  input    [1:0] s_axis_cpl_size,
  input   [15:0] s_axis_cpl_dpar,
  input   [10:0] s_axis_cpl_ctrl_qid,
  input    [1:0] s_axis_cpl_ctrl_cmpt_type,
  input   [15:0] s_axis_cpl_ctrl_wait_pld_pkt_id,
  input    [2:0] s_axis_cpl_ctrl_port_id,
  input          s_axis_cpl_ctrl_marker,
  input          s_axis_cpl_ctrl_user_trig,
  input    [2:0] s_axis_cpl_ctrl_col_idx,
  input    [2:0] s_axis_cpl_ctrl_err_idx,
  input          s_axis_cpl_ctrl_no_wrb_marker,
  output         s_axis_cpl_tready,

  output         h2c_byp_out_vld,
  output [255:0] h2c_byp_out_dsc,
  output         h2c_byp_out_st_mm,
  output   [1:0] h2c_byp_out_dsc_sz,
  output  [10:0] h2c_byp_out_qid,
  output         h2c_byp_out_error,
  output   [7:0] h2c_byp_out_func,
  output  [15:0] h2c_byp_out_cidx,
  output   [2:0] h2c_byp_out_port_id,
  output   [3:0] h2c_byp_out_fmt,
  input          h2c_byp_out_rdy,

  input          h2c_byp_in_st_vld,
  input   [63:0] h2c_byp_in_st_addr,
  input   [15:0] h2c_byp_in_st_len,
  input          h2c_byp_in_st_eop,
  input          h2c_byp_in_st_sop,
  input          h2c_byp_in_st_mrkr_req,
  input    [2:0] h2c_byp_in_st_port_id,
  input          h2c_byp_in_st_sdi,
  input   [10:0] h2c_byp_in_st_qid,
  input          h2c_byp_in_st_error,
  input    [7:0] h2c_byp_in_st_func,
  input   [15:0] h2c_byp_in_st_cidx,
  input          h2c_byp_in_st_no_dma,
  output         h2c_byp_in_st_rdy,

  output         c2h_byp_out_vld,
  output [255:0] c2h_byp_out_dsc,
  output         c2h_byp_out_st_mm,
  output  [10:0] c2h_byp_out_qid,
  output   [1:0] c2h_byp_out_dsc_sz,
  output         c2h_byp_out_error,
  output   [7:0] c2h_byp_out_func,
  output  [15:0] c2h_byp_out_cidx,
  output   [2:0] c2h_byp_out_port_id,
  output   [3:0] c2h_byp_out_fmt,
  output   [6:0] c2h_byp_out_pfch_tag,
  input          c2h_byp_out_rdy,

  input          c2h_byp_in_st_csh_vld,
  input   [63:0] c2h_byp_in_st_csh_addr,
  input    [2:0] c2h_byp_in_st_csh_port_id,
  input   [10:0] c2h_byp_in_st_csh_qid,
  input          c2h_byp_in_st_csh_error,
  input    [7:0] c2h_byp_in_st_csh_func,
  input    [6:0] c2h_byp_in_st_csh_pfch_tag,
  output         c2h_byp_in_st_csh_rdy,

  input          pcie_refclk,
  input          pcie_refclk_gt,
  input          pcie_rstn,

  output         user_lnk_up,
  output         phy_ready,
  input          soft_reset_n,

  output         axis_aclk,
  output         axil_aclk,
  output         aresetn
);

  // 250MHz clock generated by QDMA IP
  wire        aclk_250mhz;
  wire        aresetn_250mhz;

  reg   [1:0] aresetn_sync = 2'b11;

  wire        qdma_axil_awvalid;
  wire [31:0] qdma_axil_awaddr;
  wire  [2:0] qdma_axil_awprot;
  wire        qdma_axil_awready;
  wire        qdma_axil_wvalid;
  wire [31:0] qdma_axil_wdata;
  wire        qdma_axil_wready;
  wire        qdma_axil_bvalid;
  wire  [1:0] qdma_axil_bresp;
  wire        qdma_axil_bready;
  wire        qdma_axil_arvalid;
  wire [31:0] qdma_axil_araddr;
  wire  [2:0] qdma_axil_arprot;
  wire        qdma_axil_arready;
  wire        qdma_axil_rvalid;
  wire [31:0] qdma_axil_rdata;
  wire  [1:0] qdma_axil_rresp;
  wire        qdma_axil_rready;

  wire        usr_irq_in_vld;
  wire  [4:0] usr_irq_in_vec;
  wire  [7:0] usr_irq_in_fnc;
  wire        usr_irq_out_ack;
  wire        usr_irq_out_fail;

  wire        tm_dsc_sts_vld;
  wire  [2:0] tm_dsc_sts_port_id;
  wire        tm_dsc_sts_qen;
  wire        tm_dsc_sts_byp;
  wire        tm_dsc_sts_dir;
  wire        tm_dsc_sts_mm;
  wire        tm_dsc_sts_error;
  wire [10:0] tm_dsc_sts_qid;
  wire [15:0] tm_dsc_sts_avl;
  wire        tm_dsc_sts_qinv;
  wire        tm_dsc_sts_irq_arm;
  wire [15:0] tm_dsc_sts_pidx;
  wire        tm_dsc_sts_rdy;

  wire        dsc_crdt_in_vld;
  wire [15:0] dsc_crdt_in_crdt;
  wire [10:0] dsc_crdt_in_qid;
  wire        dsc_crdt_in_dir;
  wire        dsc_crdt_in_fence;
  wire        dsc_crdt_in_rdy;

  assign axis_aclk = aclk_250mhz;

  // Generate 125MHz 'axil_aclk'
  qdma_subsystem_clk_div clk_div_inst (
    .clk_in1  (axis_aclk),
    .clk_out1 (axil_aclk),
    .locked   ()
  );

  // Generate reset w.r.t. the 125MHz clock
  assign aresetn = aresetn_sync[1];
  always @(posedge axil_aclk) begin
    aresetn_sync[0] <= aresetn_250mhz;
    aresetn_sync[1] <= aresetn_sync[0];
  end

  // Convert the 250MHz QDMA output AXI-Lite interface to a 125MHz one
  qdma_subsystem_axi_cdc axi_cdc_inst (
    .s_axi_awvalid (qdma_axil_awvalid),
    .s_axi_awaddr  (qdma_axil_awaddr),
    .s_axi_awprot  (0),
    .s_axi_awready (qdma_axil_awready),
    .s_axi_wvalid  (qdma_axil_wvalid),
    .s_axi_wdata   (qdma_axil_wdata),
    .s_axi_wstrb   (4'hF),
    .s_axi_wready  (qdma_axil_wready),
    .s_axi_bvalid  (qdma_axil_bvalid),
    .s_axi_bresp   (qdma_axil_bresp),
    .s_axi_bready  (qdma_axil_bready),
    .s_axi_arvalid (qdma_axil_arvalid),
    .s_axi_araddr  (qdma_axil_araddr),
    .s_axi_arprot  (0),
    .s_axi_arready (qdma_axil_arready),
    .s_axi_rvalid  (qdma_axil_rvalid),
    .s_axi_rdata   (qdma_axil_rdata),
    .s_axi_rresp   (qdma_axil_rresp),
    .s_axi_rready  (qdma_axil_rready),

    .m_axi_awvalid (m_axil_awvalid),
    .m_axi_awaddr  (m_axil_awaddr),
    .m_axi_awprot  (),
    .m_axi_awready (m_axil_awready),
    .m_axi_wvalid  (m_axil_wvalid),
    .m_axi_wdata   (m_axil_wdata),
    .m_axi_wstrb   (),
    .m_axi_wready  (m_axil_wready),
    .m_axi_bvalid  (m_axil_bvalid),
    .m_axi_bresp   (m_axil_bresp),
    .m_axi_bready  (m_axil_bready),
    .m_axi_arvalid (m_axil_arvalid),
    .m_axi_araddr  (m_axil_araddr),
    .m_axi_arprot  (),
    .m_axi_arready (m_axil_arready),
    .m_axi_rvalid  (m_axil_rvalid),
    .m_axi_rdata   (m_axil_rdata),
    .m_axi_rresp   (m_axil_rresp),
    .m_axi_rready  (m_axil_rready),

    .s_axi_aclk    (axis_aclk),
    .s_axi_aresetn (aresetn_250mhz),
    .m_axi_aclk    (axil_aclk),
    .m_axi_aresetn (aresetn)
  );

  assign usr_irq_in_vld    = 1'b0;
  assign usr_irq_in_vec    = 0;
  assign usr_irq_in_fnc    = 0;

  assign tm_dsc_sts_rdy    = 1'b1;

  assign dsc_crdt_in_vld   = 1'b0;
  assign dsc_crdt_in_crdt  = 0;
  assign dsc_crdt_in_qid   = 0;
  assign dsc_crdt_in_dir   = 1'b0;
  assign dsc_crdt_in_fence = 1'b0;

  qdma_no_sriov qdma_inst (
    .pci_exp_rxp                          (pcie_rxp),
    .pci_exp_rxn                          (pcie_rxn),
    .pci_exp_txp                          (pcie_txp),
    .pci_exp_txn                          (pcie_txn),

    .sys_clk                              (pcie_refclk),
    .sys_clk_gt                           (pcie_refclk_gt),
    .sys_rst_n                            (pcie_rstn),
    .user_lnk_up                          (user_lnk_up),

    .axi_aclk                             (aclk_250mhz),
    .axi_aresetn                          (aresetn_250mhz),

    .m_axil_awvalid                       (qdma_axil_awvalid),
    .m_axil_awaddr                        (qdma_axil_awaddr),
    .m_axil_awuser                        (),
    .m_axil_awprot                        (),
    .m_axil_awready                       (qdma_axil_awready),
    .m_axil_wvalid                        (qdma_axil_wvalid),
    .m_axil_wdata                         (qdma_axil_wdata),
    .m_axil_wstrb                         (),
    .m_axil_wready                        (qdma_axil_wready),
    .m_axil_bvalid                        (qdma_axil_bvalid),
    .m_axil_bresp                         (qdma_axil_bresp),
    .m_axil_bready                        (qdma_axil_bready),
    .m_axil_arvalid                       (qdma_axil_arvalid),
    .m_axil_araddr                        (qdma_axil_araddr),
    .m_axil_aruser                        (),
    .m_axil_arprot                        (),
    .m_axil_arready                       (qdma_axil_arready),
    .m_axil_rvalid                        (qdma_axil_rvalid),
    .m_axil_rdata                         (qdma_axil_rdata),
    .m_axil_rresp                         (qdma_axil_rresp),
    .m_axil_rready                        (qdma_axil_rready),

    .h2c_byp_out_vld                      (h2c_byp_out_vld),
    .h2c_byp_out_dsc                      (h2c_byp_out_dsc),
    .h2c_byp_out_st_mm                    (h2c_byp_out_st_mm),
    .h2c_byp_out_dsc_sz                   (h2c_byp_out_dsc_sz),
    .h2c_byp_out_qid                      (h2c_byp_out_qid),
    .h2c_byp_out_error                    (h2c_byp_out_error),
    .h2c_byp_out_func                     (h2c_byp_out_func),
    .h2c_byp_out_cidx                     (h2c_byp_out_cidx),
    .h2c_byp_out_port_id                  (h2c_byp_out_port_id),
    .h2c_byp_out_fmt                      (h2c_byp_out_fmt),
    .h2c_byp_out_rdy                      (h2c_byp_out_rdy),

    .h2c_byp_in_st_vld                    (h2c_byp_in_st_vld),
    .h2c_byp_in_st_addr                   (h2c_byp_in_st_addr),
    .h2c_byp_in_st_len                    (h2c_byp_in_st_len),
    .h2c_byp_in_st_eop                    (h2c_byp_in_st_eop),
    .h2c_byp_in_st_sop                    (h2c_byp_in_st_sop),
    .h2c_byp_in_st_mrkr_req               (h2c_byp_in_st_mrkr_req),
    .h2c_byp_in_st_port_id                (h2c_byp_in_st_port_id),
    .h2c_byp_in_st_sdi                    (h2c_byp_in_st_sdi),
    .h2c_byp_in_st_qid                    (h2c_byp_in_st_qid),
    .h2c_byp_in_st_error                  (h2c_byp_in_st_error),
    .h2c_byp_in_st_func                   (h2c_byp_in_st_func),
    .h2c_byp_in_st_cidx                   (h2c_byp_in_st_cidx),
    .h2c_byp_in_st_no_dma                 (h2c_byp_in_st_no_dma),
    .h2c_byp_in_st_rdy                    (h2c_byp_in_st_rdy),

    .c2h_byp_out_vld                      (c2h_byp_out_vld),
    .c2h_byp_out_dsc                      (c2h_byp_out_dsc),
    .c2h_byp_out_st_mm                    (c2h_byp_out_st_mm),
    .c2h_byp_out_qid                      (c2h_byp_out_qid),
    .c2h_byp_out_dsc_sz                   (c2h_byp_out_dsc_sz),
    .c2h_byp_out_error                    (c2h_byp_out_error),
    .c2h_byp_out_func                     (c2h_byp_out_func),
    .c2h_byp_out_cidx                     (c2h_byp_out_cidx),
    .c2h_byp_out_port_id                  (c2h_byp_out_port_id),
    .c2h_byp_out_fmt                      (c2h_byp_out_fmt),
    .c2h_byp_out_pfch_tag                 (c2h_byp_out_pfch_tag),
    .c2h_byp_out_rdy                      (c2h_byp_out_rdy),

    .c2h_byp_in_st_csh_vld                (c2h_byp_in_st_csh_vld),
    .c2h_byp_in_st_csh_addr               (c2h_byp_in_st_csh_addr),
    .c2h_byp_in_st_csh_port_id            (c2h_byp_in_st_csh_port_id),
    .c2h_byp_in_st_csh_qid                (c2h_byp_in_st_csh_qid),
    .c2h_byp_in_st_csh_error              (c2h_byp_in_st_csh_error),
    .c2h_byp_in_st_csh_func               (c2h_byp_in_st_csh_func),
    .c2h_byp_in_st_csh_pfch_tag           (c2h_byp_in_st_csh_pfch_tag),
    .c2h_byp_in_st_csh_rdy                (c2h_byp_in_st_csh_rdy),

    .usr_irq_in_vld                       (usr_irq_in_vld),
    .usr_irq_in_vec                       (usr_irq_in_vec),
    .usr_irq_in_fnc                       (usr_irq_in_fnc),
    .usr_irq_out_ack                      (usr_irq_out_ack),
    .usr_irq_out_fail                     (usr_irq_out_fail),

    .tm_dsc_sts_vld                       (tm_dsc_sts_vld),
    .tm_dsc_sts_port_id                   (tm_dsc_sts_port_id),
    .tm_dsc_sts_qen                       (tm_dsc_sts_qen),
    .tm_dsc_sts_byp                       (tm_dsc_sts_byp),
    .tm_dsc_sts_dir                       (tm_dsc_sts_dir),
    .tm_dsc_sts_mm                        (tm_dsc_sts_mm),
    .tm_dsc_sts_error                     (tm_dsc_sts_error),
    .tm_dsc_sts_qid                       (tm_dsc_sts_qid),
    .tm_dsc_sts_avl                       (tm_dsc_sts_avl),
    .tm_dsc_sts_qinv                      (tm_dsc_sts_qinv),
    .tm_dsc_sts_irq_arm                   (tm_dsc_sts_irq_arm),
    .tm_dsc_sts_pidx                      (tm_dsc_sts_pidx),
    .tm_dsc_sts_rdy                       (tm_dsc_sts_rdy),

    .dsc_crdt_in_vld                      (dsc_crdt_in_vld),
    .dsc_crdt_in_crdt                     (dsc_crdt_in_crdt),
    .dsc_crdt_in_qid                      (dsc_crdt_in_qid),
    .dsc_crdt_in_dir                      (dsc_crdt_in_dir),
    .dsc_crdt_in_fence                    (dsc_crdt_in_fence),
    .dsc_crdt_in_rdy                      (dsc_crdt_in_rdy),

    .m_axis_h2c_tvalid                    (m_axis_h2c_tvalid),
    .m_axis_h2c_tdata                     (m_axis_h2c_tdata),
    .m_axis_h2c_tcrc                      (m_axis_h2c_tcrc),
    .m_axis_h2c_tlast                     (m_axis_h2c_tlast),
    .m_axis_h2c_tuser_qid                 (m_axis_h2c_tuser_qid),
    .m_axis_h2c_tuser_port_id             (m_axis_h2c_tuser_port_id),
    .m_axis_h2c_tuser_err                 (m_axis_h2c_tuser_err),
    .m_axis_h2c_tuser_mdata               (m_axis_h2c_tuser_mdata),
    .m_axis_h2c_tuser_mty                 (m_axis_h2c_tuser_mty),
    .m_axis_h2c_tuser_zero_byte           (m_axis_h2c_tuser_zero_byte),
    .m_axis_h2c_tready                    (m_axis_h2c_tready),

    .s_axis_c2h_tvalid                    (s_axis_c2h_tvalid),
    .s_axis_c2h_tdata                     (s_axis_c2h_tdata),
    .s_axis_c2h_tcrc                      (s_axis_c2h_tcrc),
    .s_axis_c2h_tlast                     (s_axis_c2h_tlast),
    .s_axis_c2h_ctrl_marker               (s_axis_c2h_ctrl_marker),
    .s_axis_c2h_ctrl_port_id              (s_axis_c2h_ctrl_port_id),
    .s_axis_c2h_ctrl_ecc                  (s_axis_c2h_ctrl_ecc),
    .s_axis_c2h_ctrl_len                  (s_axis_c2h_ctrl_len),
    .s_axis_c2h_ctrl_qid                  (s_axis_c2h_ctrl_qid),
    .s_axis_c2h_ctrl_has_cmpt             (s_axis_c2h_ctrl_has_cmpt),
    .s_axis_c2h_mty                       (s_axis_c2h_mty),
    .s_axis_c2h_tready                    (s_axis_c2h_tready),

    .s_axis_c2h_cmpt_tvalid               (s_axis_cpl_tvalid),
    .s_axis_c2h_cmpt_tdata                (s_axis_cpl_tdata),
    .s_axis_c2h_cmpt_size                 (s_axis_cpl_size),
    .s_axis_c2h_cmpt_dpar                 (s_axis_cpl_dpar),
    .s_axis_c2h_cmpt_ctrl_qid             (s_axis_cpl_ctrl_qid),
    .s_axis_c2h_cmpt_ctrl_cmpt_type       (s_axis_cpl_ctrl_cmpt_type),
    .s_axis_c2h_cmpt_ctrl_wait_pld_pkt_id (s_axis_cpl_ctrl_wait_pld_pkt_id),
    .s_axis_c2h_cmpt_ctrl_port_id         (s_axis_cpl_ctrl_port_id),
    .s_axis_c2h_cmpt_ctrl_marker          (s_axis_cpl_ctrl_marker),
    .s_axis_c2h_cmpt_ctrl_user_trig       (s_axis_cpl_ctrl_user_trig),
    .s_axis_c2h_cmpt_ctrl_col_idx         (s_axis_cpl_ctrl_col_idx),
    .s_axis_c2h_cmpt_ctrl_err_idx         (s_axis_cpl_ctrl_err_idx),
    .s_axis_c2h_cmpt_ctrl_no_wrb_marker   (s_axis_cpl_ctrl_no_wrb_marker),
    .s_axis_c2h_cmpt_tready               (s_axis_cpl_tready),

    .axis_c2h_status_drop                 (),     // output wire axis_c2h_status_drop
    .axis_c2h_status_valid                (),     // output wire axis_c2h_status_valid
    .axis_c2h_status_cmp                  (),     // output wire axis_c2h_status_cmp
    .axis_c2h_status_error                (),     // output wire axis_c2h_status_error
    .axis_c2h_status_last                 (),     // output wire axis_c2h_status_last
    .axis_c2h_status_qid                  (),     // output wire [10 : 0] axis_c2h_status_qid
    .axis_c2h_dmawr_cmp                   (),     // output wire axis_c2h_dmawr_cmp

    .qsts_out_op                          (),     // output wire [7 : 0] qsts_out_op
    .qsts_out_data                        (),     // output wire [63 : 0] qsts_out_data
    .qsts_out_port_id                     (),     // output wire [2 : 0] qsts_out_port_id
    .qsts_out_qid                         (),     // output wire [12 : 0] qsts_out_qid
    .qsts_out_vld                         (),     // output wire qsts_out_vld
    .qsts_out_rdy                         (1'b1), // input wire qsts_out_rdy

    .soft_reset_n                         (soft_reset_n),
    .phy_ready                            (phy_ready)
  );

endmodule: qdma_subsystem_qdma_wrapper
