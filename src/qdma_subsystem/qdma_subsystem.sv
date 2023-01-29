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
module qdma_subsystem #(
  parameter int MIN_PKT_LEN   = 64,
  parameter int MAX_PKT_LEN   = 1518,
  parameter int USE_PHYS_FUNC = 1,
  parameter int NUM_PHYS_FUNC = 1,
  parameter int NUM_QUEUE     = 512
) (
  input                          s_axil_awvalid,
  input                   [31:0] s_axil_awaddr,
  output                         s_axil_awready,
  input                          s_axil_wvalid,
  input                   [31:0] s_axil_wdata,
  output                         s_axil_wready,
  output                         s_axil_bvalid,
  output                   [1:0] s_axil_bresp,
  input                          s_axil_bready,
  input                          s_axil_arvalid,
  input                   [31:0] s_axil_araddr,
  output                         s_axil_arready,
  output                         s_axil_rvalid,
  output                  [31:0] s_axil_rdata,
  output                   [1:0] s_axil_rresp,
  input                          s_axil_rready,

  output     [NUM_PHYS_FUNC-1:0] m_axis_h2c_tvalid,
  output [512*NUM_PHYS_FUNC-1:0] m_axis_h2c_tdata,
  output  [64*NUM_PHYS_FUNC-1:0] m_axis_h2c_tkeep,
  output     [NUM_PHYS_FUNC-1:0] m_axis_h2c_tlast,
  output  [16*NUM_PHYS_FUNC-1:0] m_axis_h2c_tuser_size,
  output  [16*NUM_PHYS_FUNC-1:0] m_axis_h2c_tuser_src,
  output  [16*NUM_PHYS_FUNC-1:0] m_axis_h2c_tuser_dst,
  input      [NUM_PHYS_FUNC-1:0] m_axis_h2c_tready,

  input      [NUM_PHYS_FUNC-1:0] s_axis_c2h_tvalid,
  input  [512*NUM_PHYS_FUNC-1:0] s_axis_c2h_tdata,
  input   [64*NUM_PHYS_FUNC-1:0] s_axis_c2h_tkeep,
  input      [NUM_PHYS_FUNC-1:0] s_axis_c2h_tlast,
  input   [16*NUM_PHYS_FUNC-1:0] s_axis_c2h_tuser_size,
  input   [16*NUM_PHYS_FUNC-1:0] s_axis_c2h_tuser_src,
  input   [16*NUM_PHYS_FUNC-1:0] s_axis_c2h_tuser_dst,
  output     [NUM_PHYS_FUNC-1:0] s_axis_c2h_tready,

`ifdef __synthesis__
  input                   [15:0] pcie_rxp,
  input                   [15:0] pcie_rxn,
  output                  [15:0] pcie_txp,
  output                  [15:0] pcie_txn,


// ARM PCIe Interface

    input arm_pcie_refclk_p,
    input arm_pcie_refclk_n,
    input [7:0] arm_pcie_mgt_0_rxn,
    input [7:0] arm_pcie_mgt_0_rxp,
    output [7:0] arm_pcie_mgt_0_txn,
    output [7:0] arm_pcie_mgt_0_txp,
    input arm_pcie_rstn,
  

  // BAR2-mapped master AXI-Lite feeding into system configuration block
  output                         m_axil_pcie_awvalid,
  output                  [31:0] m_axil_pcie_awaddr,
  input                          m_axil_pcie_awready,
  output                         m_axil_pcie_wvalid,
  output                  [31:0] m_axil_pcie_wdata,
  input                          m_axil_pcie_wready,
  input                          m_axil_pcie_bvalid,
  input                    [1:0] m_axil_pcie_bresp,
  output                         m_axil_pcie_bready,
 (* mark_debug = "true" *)  output                         m_axil_pcie_arvalid,
 output                  [31:0] m_axil_pcie_araddr,
 input                          m_axil_pcie_arready,
 (* mark_debug = "true" *) input                          m_axil_pcie_rvalid,
 input                   [31:0] m_axil_pcie_rdata,
 input                    [1:0] m_axil_pcie_rresp,
 output                         m_axil_pcie_rready,

  input                          pcie_refclk_p,
  input                          pcie_refclk_n,
  input                          pcie_rstn,
  output                         user_lnk_up,
  output                         phy_ready,

  // This reset signal serves as a power-up reset for the entire system.  It is
  // routed into the `system_config` submodule to generate proper reset signals
  // for each submodule.
  output                         powerup_rstn,
`else // !`ifdef __synthesis__
  input                          s_axis_qdma_h2c_tvalid,
  input                  [511:0] s_axis_qdma_h2c_tdata,
  input                   [31:0] s_axis_qdma_h2c_tcrc,
  input                          s_axis_qdma_h2c_tlast,
  input                   [10:0] s_axis_qdma_h2c_tuser_qid,
  input                    [2:0] s_axis_qdma_h2c_tuser_port_id,
  input                          s_axis_qdma_h2c_tuser_err,
  input                   [31:0] s_axis_qdma_h2c_tuser_mdata,
  input                    [5:0] s_axis_qdma_h2c_tuser_mty,
  input                          s_axis_qdma_h2c_tuser_zero_byte,
  output                         s_axis_qdma_h2c_tready,

  output                         m_axis_qdma_c2h_tvalid,
  output                 [511:0] m_axis_qdma_c2h_tdata,
  output                  [31:0] m_axis_qdma_c2h_tcrc,
  output                         m_axis_qdma_c2h_tlast,
  output                         m_axis_qdma_c2h_ctrl_marker,
  output                   [2:0] m_axis_qdma_c2h_ctrl_port_id,
  output                   [6:0] m_axis_qdma_c2h_ctrl_ecc,
  output                  [15:0] m_axis_qdma_c2h_ctrl_len,
  output                  [10:0] m_axis_qdma_c2h_ctrl_qid,
  output                         m_axis_qdma_c2h_ctrl_has_cmpt,
  output                   [5:0] m_axis_qdma_c2h_mty,
  input                          m_axis_qdma_c2h_tready,

  output                         m_axis_qdma_cpl_tvalid,
  output                 [511:0] m_axis_qdma_cpl_tdata,
  output                   [1:0] m_axis_qdma_cpl_size,
  output                  [15:0] m_axis_qdma_cpl_dpar,
  output                  [10:0] m_axis_qdma_cpl_ctrl_qid,
  output                   [1:0] m_axis_qdma_cpl_ctrl_cmpt_type,
  output                  [15:0] m_axis_qdma_cpl_ctrl_wait_pld_pkt_id,
  output                   [2:0] m_axis_qdma_cpl_ctrl_port_id,
  output                         m_axis_qdma_cpl_ctrl_marker,
  output                         m_axis_qdma_cpl_ctrl_user_trig,
  output                   [2:0] m_axis_qdma_cpl_ctrl_col_idx,
  output                   [2:0] m_axis_qdma_cpl_ctrl_err_idx,
  output                         m_axis_qdma_cpl_ctrl_no_wrb_marker,
  input                          m_axis_qdma_cpl_tready,
`endif

   input                          mod_rstn,
  output                         mod_rst_done,
  
    // CMS Ports
  input                          [1:0]satellite_gpio,
  input                          satellite_uart_rxd,
  output                         satellite_uart_txd,
  //QSPI Interface
//  inout                           spi_flash_io0_io,
//  inout                           spi_flash_io1_io,
//  inout                           spi_flash_io2_io,
//  inout                           spi_flash_io3_io,
//  inout                           spi_flash_sck_io,
//  inout                      [0:0]spi_flash_ss_io,

`ifdef __synthesis__
  output                         axil_aclk,
  output                         clk_100M,
  output                         axis_aclk
`else
  output reg                     axil_aclk,
  output reg                     clk_100M,
  output reg                     axis_aclk
`endif
);


  wire                         x86_m_axil_pcie_awvalid;
  wire                  [31:0] x86_m_axil_pcie_awaddr;
  wire                         x86_m_axil_pcie_awready;
  wire                         x86_m_axil_pcie_wvalid;
  wire                  [31:0] x86_m_axil_pcie_wdata;
  wire                         x86_m_axil_pcie_wready;
  wire                         x86_m_axil_pcie_bvalid;
  wire                   [1:0] x86_m_axil_pcie_bresp;
  wire                         x86_m_axil_pcie_bready;
  wire                         x86_m_axil_pcie_arvalid;
  wire                  [31:0] x86_m_axil_pcie_araddr;
  wire                         x86_m_axil_pcie_arready;
  wire                         x86_m_axil_pcie_rvalid;
  wire                  [31:0] x86_m_axil_pcie_rdata;
  wire                   [1:0] x86_m_axil_pcie_rresp;
  wire                         x86_m_axil_pcie_rready;

  wire                         arm_m_axil_pcie_awvalid;
  wire                  [31:0] arm_m_axil_pcie_awaddr;
  wire                         arm_m_axil_pcie_awready;
  wire                         arm_m_axil_pcie_wvalid;
  wire                  [31:0] arm_m_axil_pcie_wdata;
  wire                         arm_m_axil_pcie_wready;
  wire                         arm_m_axil_pcie_bvalid;
  wire                   [1:0] arm_m_axil_pcie_bresp;
  wire                         arm_m_axil_pcie_bready;
(* mark_debug = "true" *) wire                         arm_m_axil_pcie_arvalid;
wire                  [31:0] arm_m_axil_pcie_araddr;
wire                         arm_m_axil_pcie_arready;
(* mark_debug = "true" *) wire                         arm_m_axil_pcie_rvalid;
wire                  [31:0] arm_m_axil_pcie_rdata;
wire                   [1:0] arm_m_axil_pcie_rresp;
wire                         arm_m_axil_pcie_rready;

  wire                         arm_axil_aclk;

  wire         axis_qdma_h2c_tvalid;
  wire [511:0] axis_qdma_h2c_tdata;
  wire  [31:0] axis_qdma_h2c_tcrc;
  wire         axis_qdma_h2c_tlast;
  wire  [10:0] axis_qdma_h2c_tuser_qid;
  wire   [2:0] axis_qdma_h2c_tuser_port_id;
  wire         axis_qdma_h2c_tuser_err;
  wire  [31:0] axis_qdma_h2c_tuser_mdata;
  wire   [5:0] axis_qdma_h2c_tuser_mty;
  wire         axis_qdma_h2c_tuser_zero_byte;
  wire         axis_qdma_h2c_tready;


  wire         x86_axis_qdma_h2c_tvalid;
  wire [511:0] x86_axis_qdma_h2c_tdata;
  wire  [31:0] x86_axis_qdma_h2c_tcrc;
  wire         x86_axis_qdma_h2c_tlast;
  wire  [10:0] x86_axis_qdma_h2c_tuser_qid;
  wire   [2:0] x86_axis_qdma_h2c_tuser_port_id;
  wire         x86_axis_qdma_h2c_tuser_err;
  wire  [31:0] x86_axis_qdma_h2c_tuser_mdata;
  wire   [5:0] x86_axis_qdma_h2c_tuser_mty;
  wire         x86_axis_qdma_h2c_tuser_zero_byte;
  wire         x86_axis_qdma_h2c_tready;

  wire [127:0] x86_axis_qdma_h2c_tuser;
  assign x86_axis_qdma_h2c_tuser = {42'd0, x86_axis_qdma_h2c_tcrc[31:0], x86_axis_qdma_h2c_tuser_qid[10:0], x86_axis_qdma_h2c_tuser_port_id[2:0], x86_axis_qdma_h2c_tuser_err, x86_axis_qdma_h2c_tuser_mdata[31:0], x86_axis_qdma_h2c_tuser_mty[5:0], x86_axis_qdma_h2c_tuser_zero_byte};


  wire         axis_qdma_c2h_tvalid;
  wire [511:0] axis_qdma_c2h_tdata;
  wire  [31:0] axis_qdma_c2h_tcrc;
  wire         axis_qdma_c2h_tlast;
  wire         axis_qdma_c2h_ctrl_marker;
  wire   [2:0] axis_qdma_c2h_ctrl_port_id;
  wire   [6:0] axis_qdma_c2h_ctrl_ecc;
  wire  [15:0] axis_qdma_c2h_ctrl_len;
  wire  [10:0] axis_qdma_c2h_ctrl_qid;
  wire         axis_qdma_c2h_ctrl_has_cmpt;
  wire   [5:0] axis_qdma_c2h_mty;
  wire         axis_qdma_c2h_tready;

  wire [127:0] axis_qdma_c2h_tuser;
  assign axis_qdma_c2h_tuser = {51'd0, axis_qdma_c2h_tcrc[31:0], axis_qdma_c2h_ctrl_marker, axis_qdma_c2h_ctrl_port_id[2:0], axis_qdma_c2h_ctrl_ecc[6:0], axis_qdma_c2h_ctrl_len[15:0], axis_qdma_c2h_ctrl_qid[10:0], axis_qdma_c2h_ctrl_has_cmpt, axis_qdma_c2h_mty[5:0]};

  wire [127:0] x86_axis_qdma_c2h_tuser;
  
  wire         x86_axis_qdma_c2h_tvalid;
  wire [511:0] x86_axis_qdma_c2h_tdata;
  wire  [31:0] x86_axis_qdma_c2h_tcrc;
  wire         x86_axis_qdma_c2h_tlast;
  wire         x86_axis_qdma_c2h_ctrl_marker;
  wire   [2:0] x86_axis_qdma_c2h_ctrl_port_id;
  wire   [6:0] x86_axis_qdma_c2h_ctrl_ecc;
  wire  [15:0] x86_axis_qdma_c2h_ctrl_len;
  wire  [10:0] x86_axis_qdma_c2h_ctrl_qid;
  wire         x86_axis_qdma_c2h_ctrl_has_cmpt;
  wire   [5:0] x86_axis_qdma_c2h_mty;
  wire         x86_axis_qdma_c2h_tready;

  assign x86_axis_qdma_c2h_mty = x86_axis_qdma_c2h_tuser[5:0];
  assign x86_axis_qdma_c2h_ctrl_has_cmpt = x86_axis_qdma_c2h_tuser[6];
  assign x86_axis_qdma_c2h_ctrl_qid = x86_axis_qdma_c2h_tuser[17:7];
  assign x86_axis_qdma_c2h_ctrl_len = x86_axis_qdma_c2h_tuser[33:18];
  assign x86_axis_qdma_c2h_ctrl_ecc = x86_axis_qdma_c2h_tuser[40:34];
  assign x86_axis_qdma_c2h_ctrl_port_id = x86_axis_qdma_c2h_tuser[43:41];
  assign x86_axis_qdma_c2h_ctrl_marker = x86_axis_qdma_c2h_tuser[44];
  assign x86_axis_qdma_c2h_tcrc = x86_axis_qdma_c2h_tuser[76:45];


  wire         axis_qdma_cpl_tvalid;
  wire [511:0] axis_qdma_cpl_tdata;
  wire   [1:0] axis_qdma_cpl_size;
  wire  [15:0] axis_qdma_cpl_dpar;
  wire  [10:0] axis_qdma_cpl_ctrl_qid;
  wire   [1:0] axis_qdma_cpl_ctrl_cmpt_type;
  wire  [15:0] axis_qdma_cpl_ctrl_wait_pld_pkt_id;
  wire   [2:0] axis_qdma_cpl_ctrl_port_id;
  wire         axis_qdma_cpl_ctrl_marker;
  wire         axis_qdma_cpl_ctrl_user_trig;
  wire   [2:0] axis_qdma_cpl_ctrl_col_idx;
  wire   [2:0] axis_qdma_cpl_ctrl_err_idx;
  wire         axis_qdma_cpl_ctrl_no_wrb_marker;
  wire         axis_qdma_cpl_tready;

  wire [127:0] axis_qdma_cpl_tuser;
  assign axis_qdma_cpl_tuser = {69'd0, axis_qdma_cpl_size[1:0], axis_qdma_cpl_dpar[15:0], axis_qdma_cpl_ctrl_qid[10:0], axis_qdma_cpl_ctrl_cmpt_type[1:0], axis_qdma_cpl_ctrl_wait_pld_pkt_id[15:0], axis_qdma_cpl_ctrl_port_id[2:0], axis_qdma_cpl_ctrl_marker, axis_qdma_cpl_ctrl_user_trig, axis_qdma_cpl_ctrl_col_idx[2:0], axis_qdma_cpl_ctrl_err_idx[2:0], axis_qdma_cpl_ctrl_no_wrb_marker };

  wire         x86_axis_qdma_cpl_tvalid;
  wire [511:0] x86_axis_qdma_cpl_tdata;
  wire   [1:0] x86_axis_qdma_cpl_size;
  wire  [15:0] x86_axis_qdma_cpl_dpar;
  wire  [10:0] x86_axis_qdma_cpl_ctrl_qid;
  wire   [1:0] x86_axis_qdma_cpl_ctrl_cmpt_type;
  wire  [15:0] x86_axis_qdma_cpl_ctrl_wait_pld_pkt_id;
  wire   [2:0] x86_axis_qdma_cpl_ctrl_port_id;
  wire         x86_axis_qdma_cpl_ctrl_marker;
  wire         x86_axis_qdma_cpl_ctrl_user_trig;
  wire   [2:0] x86_axis_qdma_cpl_ctrl_col_idx;
  wire   [2:0] x86_axis_qdma_cpl_ctrl_err_idx;
  wire         x86_axis_qdma_cpl_ctrl_no_wrb_marker;
  wire         x86_axis_qdma_cpl_tready;

  wire [127:0] x86_axis_qdma_cpl_tuser;
  assign x86_axis_qdma_cpl_ctrl_no_wrb_marker = x86_axis_qdma_cpl_tuser[0];
  assign x86_axis_qdma_cpl_ctrl_err_idx = x86_axis_qdma_cpl_tuser[3:1];
  assign x86_axis_qdma_cpl_ctrl_col_idx = x86_axis_qdma_cpl_tuser[6:4];
  assign x86_axis_qdma_cpl_ctrl_user_trig = x86_axis_qdma_cpl_tuser[7];
  assign x86_axis_qdma_cpl_ctrl_marker = x86_axis_qdma_cpl_tuser[8];
  assign x86_axis_qdma_cpl_ctrl_port_id = x86_axis_qdma_cpl_tuser[11:9];
  assign x86_axis_qdma_cpl_ctrl_wait_pld_pkt_id = x86_axis_qdma_cpl_tuser[27:12];
  assign x86_axis_qdma_cpl_ctrl_cmpt_type = x86_axis_qdma_cpl_tuser[29:28];
  assign x86_axis_qdma_cpl_ctrl_qid = x86_axis_qdma_cpl_tuser[40:30];
  assign x86_axis_qdma_cpl_dpar = x86_axis_qdma_cpl_tuser[56:41];
  assign x86_axis_qdma_cpl_size = x86_axis_qdma_cpl_tuser[58:57];

  wire         h2c_byp_out_vld;
  wire [255:0] h2c_byp_out_dsc;
  wire         h2c_byp_out_st_mm;
  wire   [1:0] h2c_byp_out_dsc_sz;
  wire  [10:0] h2c_byp_out_qid;
  wire         h2c_byp_out_error;
  wire   [7:0] h2c_byp_out_func;
  wire  [15:0] h2c_byp_out_cidx;
  wire   [2:0] h2c_byp_out_port_id;
  wire   [3:0] h2c_byp_out_fmt;
  wire         h2c_byp_out_rdy;

  wire         h2c_byp_in_st_vld;
  wire  [63:0] h2c_byp_in_st_addr;
  wire  [15:0] h2c_byp_in_st_len;
  wire         h2c_byp_in_st_eop;
  wire         h2c_byp_in_st_sop;
  wire         h2c_byp_in_st_mrkr_req;
  wire   [2:0] h2c_byp_in_st_port_id;
  wire         h2c_byp_in_st_sdi;
  wire  [10:0] h2c_byp_in_st_qid;
  wire         h2c_byp_in_st_error;
  wire   [7:0] h2c_byp_in_st_func;
  wire  [15:0] h2c_byp_in_st_cidx;
  wire         h2c_byp_in_st_no_dma;
  wire         h2c_byp_in_st_rdy;

  wire         c2h_byp_out_vld;
  wire [255:0] c2h_byp_out_dsc;
  wire         c2h_byp_out_st_mm;
  wire  [10:0] c2h_byp_out_qid;
  wire   [1:0] c2h_byp_out_dsc_sz;
  wire         c2h_byp_out_error;
  wire   [7:0] c2h_byp_out_func;
  wire  [15:0] c2h_byp_out_cidx;
  wire   [2:0] c2h_byp_out_port_id;
  wire   [3:0] c2h_byp_out_fmt;
  wire   [6:0] c2h_byp_out_pfch_tag;
  wire         c2h_byp_out_rdy;

  wire         c2h_byp_in_st_csh_vld;
  wire  [63:0] c2h_byp_in_st_csh_addr;
  wire   [2:0] c2h_byp_in_st_csh_port_id;
  wire  [10:0] c2h_byp_in_st_csh_qid;
  wire         c2h_byp_in_st_csh_error;
  wire   [7:0] c2h_byp_in_st_csh_func;
  wire   [6:0] c2h_byp_in_st_csh_pfch_tag;
  wire         c2h_byp_in_st_csh_rdy;

wire         axil_aresetn;


  wire [127:0] axis_qdma_h2c_tuser;

  assign axis_qdma_h2c_tuser_zero_byte = axis_qdma_h2c_tuser[0];
  assign axis_qdma_h2c_tuser_mty = axis_qdma_h2c_tuser[6:1];
  assign axis_qdma_h2c_tuser_mdata = axis_qdma_h2c_tuser[38:7];
  assign axis_qdma_h2c_tuser_err = axis_qdma_h2c_tuser[39];
  assign axis_qdma_h2c_tuser_port_id = axis_qdma_h2c_tuser[42:40];
  assign axis_qdma_h2c_tuser_qid = axis_qdma_h2c_tuser[53:43];
  assign axis_qdma_h2c_tcrc = axis_qdma_h2c_tuser[85:54];

// ARM QDMA wires
  wire [127:0] arm_axis_qdma_h2c_tuser;
  assign arm_axis_qdma_h2c_tuser = {42'd0, arm_axis_qdma_h2c_tcrc[31:0], arm_axis_qdma_h2c_tuser_qid[10:0], arm_axis_qdma_h2c_tuser_port_id[2:0], arm_axis_qdma_h2c_tuser_err, arm_axis_qdma_h2c_tuser_mdata[31:0], arm_axis_qdma_h2c_tuser_mty[5:0], arm_axis_qdma_h2c_tuser_zero_byte};

  wire         arm_axis_qdma_h2c_tvalid;
  wire [511:0] arm_axis_qdma_h2c_tdata;
  wire  [31:0] arm_axis_qdma_h2c_tcrc;
  wire         arm_axis_qdma_h2c_tlast;
  wire  [10:0] arm_axis_qdma_h2c_tuser_qid;
  wire   [2:0] arm_axis_qdma_h2c_tuser_port_id;
  wire         arm_axis_qdma_h2c_tuser_err;
  wire  [31:0] arm_axis_qdma_h2c_tuser_mdata;
  wire   [5:0] arm_axis_qdma_h2c_tuser_mty;
  wire         arm_axis_qdma_h2c_tuser_zero_byte;
  wire         arm_axis_qdma_h2c_tready;

  wire         arm_axis_qdma_c2h_tvalid;
  wire [511:0] arm_axis_qdma_c2h_tdata;
  wire  [31:0] arm_axis_qdma_c2h_tcrc;
  wire         arm_axis_qdma_c2h_tlast;
  wire         arm_axis_qdma_c2h_ctrl_marker;
  wire   [2:0] arm_axis_qdma_c2h_ctrl_port_id;
  wire   [6:0] arm_axis_qdma_c2h_ctrl_ecc;
  wire  [15:0] arm_axis_qdma_c2h_ctrl_len;
  wire  [10:0] arm_axis_qdma_c2h_ctrl_qid;
  wire         arm_axis_qdma_c2h_ctrl_has_cmpt;
  wire   [5:0] arm_axis_qdma_c2h_mty;
  wire         arm_axis_qdma_c2h_tready;

  wire   [127:0] arm_axis_qdma_c2h_tuser;

  assign arm_axis_qdma_c2h_mty = arm_axis_qdma_c2h_tuser[5:0];
  assign arm_axis_qdma_c2h_ctrl_has_cmpt = arm_axis_qdma_c2h_tuser[6];
  assign arm_axis_qdma_c2h_ctrl_qid = arm_axis_qdma_c2h_tuser[17:7];
  assign arm_axis_qdma_c2h_ctrl_len = arm_axis_qdma_c2h_tuser[33:18];
  assign arm_axis_qdma_c2h_ctrl_ecc = arm_axis_qdma_c2h_tuser[40:34];
  assign arm_axis_qdma_c2h_ctrl_port_id = arm_axis_qdma_c2h_tuser[43:41];
  assign arm_axis_qdma_c2h_ctrl_marker = arm_axis_qdma_c2h_tuser[44];
  assign arm_axis_qdma_c2h_tcrc = arm_axis_qdma_c2h_tuser[76:45];

  wire         arm_axis_qdma_cpl_tvalid;
  wire [511:0] arm_axis_qdma_cpl_tdata;
  wire   [1:0] arm_axis_qdma_cpl_size;
  wire  [15:0] arm_axis_qdma_cpl_dpar;
  wire  [10:0] arm_axis_qdma_cpl_ctrl_qid;
  wire   [1:0] arm_axis_qdma_cpl_ctrl_cmpt_type;
  wire  [15:0] arm_axis_qdma_cpl_ctrl_wait_pld_pkt_id;
  wire   [2:0] arm_axis_qdma_cpl_ctrl_port_id;
  wire         arm_axis_qdma_cpl_ctrl_marker;
  wire         arm_axis_qdma_cpl_ctrl_user_trig;
  wire   [2:0] arm_axis_qdma_cpl_ctrl_col_idx;
  wire   [2:0] arm_axis_qdma_cpl_ctrl_err_idx;
  wire         arm_axis_qdma_cpl_ctrl_no_wrb_marker;
  wire         arm_axis_qdma_cpl_tready;

  wire [127:0] arm_axis_qdma_cpl_tuser;
  assign arm_axis_qdma_cpl_ctrl_no_wrb_marker = arm_axis_qdma_cpl_tuser[0];
  assign arm_axis_qdma_cpl_ctrl_err_idx = arm_axis_qdma_cpl_tuser[3:1];
  assign arm_axis_qdma_cpl_ctrl_col_idx = arm_axis_qdma_cpl_tuser[6:4];
  assign arm_axis_qdma_cpl_ctrl_user_trig = arm_axis_qdma_cpl_tuser[7];
  assign arm_axis_qdma_cpl_ctrl_marker = arm_axis_qdma_cpl_tuser[8];
  assign arm_axis_qdma_cpl_ctrl_port_id = arm_axis_qdma_cpl_tuser[11:9];
  assign arm_axis_qdma_cpl_ctrl_wait_pld_pkt_id = arm_axis_qdma_cpl_tuser[27:12];
  assign arm_axis_qdma_cpl_ctrl_cmpt_type = arm_axis_qdma_cpl_tuser[29:28];
  assign arm_axis_qdma_cpl_ctrl_qid = arm_axis_qdma_cpl_tuser[40:30];
  assign arm_axis_qdma_cpl_dpar = arm_axis_qdma_cpl_tuser[56:41];
  assign arm_axis_qdma_cpl_size = arm_axis_qdma_cpl_tuser[58:57];

  wire         arm_h2c_byp_out_vld;
  wire [255:0] arm_h2c_byp_out_dsc;
  wire         arm_h2c_byp_out_st_mm;
  wire   [1:0] arm_h2c_byp_out_dsc_sz;
  wire  [10:0] arm_h2c_byp_out_qid;
  wire         arm_h2c_byp_out_error;
  wire   [7:0] arm_h2c_byp_out_func;
  wire  [15:0] arm_h2c_byp_out_cidx;
  wire   [2:0] arm_h2c_byp_out_port_id;
  wire   [3:0] arm_h2c_byp_out_fmt;
  wire         arm_h2c_byp_out_rdy;

  wire         arm_h2c_byp_in_st_vld;
  wire  [63:0] arm_h2c_byp_in_st_addr;
  wire  [15:0] arm_h2c_byp_in_st_len;
  wire         arm_h2c_byp_in_st_eop;
  wire         arm_h2c_byp_in_st_sop;
  wire         arm_h2c_byp_in_st_mrkr_req;
  wire   [2:0] arm_h2c_byp_in_st_port_id;
  wire         arm_h2c_byp_in_st_sdi;
  wire  [10:0] arm_h2c_byp_in_st_qid;
  wire         arm_h2c_byp_in_st_error;
  wire   [7:0] arm_h2c_byp_in_st_func;
  wire  [15:0] arm_h2c_byp_in_st_cidx;
  wire         arm_h2c_byp_in_st_no_dma;
  wire         arm_h2c_byp_in_st_rdy;

  wire         arm_c2h_byp_out_vld;
  wire [255:0] arm_c2h_byp_out_dsc;
  wire         arm_c2h_byp_out_st_mm;
  wire  [10:0] arm_c2h_byp_out_qid;
  wire   [1:0] arm_c2h_byp_out_dsc_sz;
  wire         arm_c2h_byp_out_error;
  wire   [7:0] arm_c2h_byp_out_func;
  wire  [15:0] arm_c2h_byp_out_cidx;
  wire   [2:0] arm_c2h_byp_out_port_id;
  wire   [3:0] arm_c2h_byp_out_fmt;
  wire   [6:0] arm_c2h_byp_out_pfch_tag;
  wire         arm_c2h_byp_out_rdy;

  wire         arm_c2h_byp_in_st_csh_vld;
  wire  [63:0] arm_c2h_byp_in_st_csh_addr;
  wire   [2:0] arm_c2h_byp_in_st_csh_port_id;
  wire  [10:0] arm_c2h_byp_in_st_csh_qid;
  wire         arm_c2h_byp_in_st_csh_error;
  wire   [7:0] arm_c2h_byp_in_st_csh_func;
  wire   [6:0] arm_c2h_byp_in_st_csh_pfch_tag;
  wire         arm_c2h_byp_in_st_csh_rdy;

   wire         arm_axil_aresetn;

//assign axis_aclk = axil_aclk;

// AXI lite Interconnect
//  x86 QDMA , S00 ---->
//                      ----> AXI Config interface to other peripherals
//   ARM QDMA , S01 ---->

//axi_interconnect_0 axi_interconnect_0_inst (
design_1_wrapper bd_design (
  .ACLK(axil_aclk),        // input wire INTERCONNECT_ACLK
  .ARESETN(axil_aresetn),  // input wire INTERCONNECT_ARESETN
  .S00_ACLK(axil_aclk),                  // input wire S00_AXI_ACLK
  //.S00_AXI_awid(1'b0),                  // input wire [0 : 0] S00_AXI_AWID
  .S00_AXI_awaddr(x86_m_axil_pcie_awaddr),              // input wire [31 : 0] S00_AXI_AWADDR
//  .S00_AXI_awlen(8'd0),                // input wire [7 : 0] S00_AXI_AWLEN
//  .S00_AXI_awsize(3'b010),              // input wire [2 : 0] S00_AXI_AWSIZE
//  .S00_AXI_awburst(2'b01),            // input wire [1 : 0] S00_AXI_AWBURST
//  .S00_AXI_awlock(1'b0),              // input wire S00_AXI_AWLOCK
//  .S00_AXI_awcache(4'b0000),            // input wire [3 : 0] S00_AXI_AWCACHE
  .S00_AXI_awprot(3'd0),              // input wire [2 : 0] S00_AXI_AWPROT
//  .S00_AXI_awqos(4'd0),                // input wire [3 : 0] S00_AXI_AWQOS
  .S00_AXI_awvalid(x86_m_axil_pcie_awvalid),            // input wire S00_AXI_AWVALID
  .S00_AXI_awready(x86_m_axil_pcie_awready),            // output wire S00_AXI_AWREADY
  .S00_AXI_wdata(x86_m_axil_pcie_wdata),                // input wire [31 : 0] S00_AXI_WDATA
  .S00_AXI_wstrb(4'b1111),                // input wire [3 : 0] S00_AXI_WSTRB
//  .S00_AXI_wlast(x86_m_axil_pcie_wvalid),                // input wire S00_AXI_WLAST
  .S00_AXI_wvalid(x86_m_axil_pcie_wvalid),              // input wire S00_AXI_WVALID
  .S00_AXI_wready(x86_m_axil_pcie_wready),              // output wire S00_AXI_WREADY
  //.S00_AXI_bid(1'b0),                    // output wire [0 : 0] S00_AXI_BID
  .S00_AXI_bresp(x86_m_axil_pcie_bresp),                // output wire [1 : 0] S00_AXI_BRESP
  .S00_AXI_bvalid(x86_m_axil_pcie_bvalid),              // output wire S00_AXI_BVALID
  .S00_AXI_bready(x86_m_axil_pcie_bready),              // input wire S00_AXI_BREADY
  //.S00_AXI_arid(1'b0),                  // input wire [0 : 0] S00_AXI_ARID
  .S00_AXI_araddr(x86_m_axil_pcie_araddr),              // input wire [31 : 0] S00_AXI_ARADDR
//  .S00_AXI_arlen(8'd0),                // input wire [7 : 0] S00_AXI_ARLEN
//  .S00_AXI_arsize(3'b010),              // input wire [2 : 0] S00_AXI_ARSIZE
//  .S00_AXI_arburst(2'b01),            // input wire [1 : 0] S00_AXI_ARBURST
//  .S00_AXI_arlock(1'b0),              // input wire S00_AXI_ARLOCK
//  .S00_AXI_arcache(4'b0000),            // input wire [3 : 0] S00_AXI_ARCACHE
  .S00_AXI_arprot(3'd0),              // input wire [2 : 0] S00_AXI_ARPROT
//  .S00_AXI_arqos(4'd0),                // input wire [3 : 0] S00_AXI_ARQOS
  .S00_AXI_arvalid(x86_m_axil_pcie_arvalid),            // input wire S00_AXI_ARVALID
  .S00_AXI_arready(x86_m_axil_pcie_arready),            // output wire S00_AXI_ARREADY
  //.S00_AXI_rid(1'b0),                    // output wire [0 : 0] S00_AXI_RID
  .S00_AXI_rdata(x86_m_axil_pcie_rdata),                // output wire [31 : 0] S00_AXI_RDATA
  .S00_AXI_rresp(x86_m_axil_pcie_rresp),                // output wire [1 : 0] S00_AXI_RRESP
//  .S00_AXI_rlast(),                // output wire S00_AXI_RLAST
  .S00_AXI_rvalid(x86_m_axil_pcie_rvalid),              // output wire S00_AXI_RVALID
  .S00_AXI_rready(x86_m_axil_pcie_rready),              // input wire S00_AXI_RREADY
  .S01_ACLK(arm_axil_aclk),                  // input wire S01_AXI_ACLK
  //.S01_AXI_awid(1'b0),                  // input wire [0 : 0] S01_AXI_AWID
  .S01_AXI_awaddr(arm_m_axil_pcie_awaddr),              // input wire [31 : 0] S01_AXI_AWADDR
//  .S01_AXI_awlen(8'd0),                // input wire [7 : 0] S01_AXI_AWLEN
//  .S01_AXI_awsize(3'b010),              // input wire [2 : 0] S01_AXI_AWSIZE
//  .S01_AXI_awburst(2'b01),            // input wire [1 : 0] S01_AXI_AWBURST
//  .S01_AXI_awlock(1'b0),              // input wire S01_AXI_AWLOCK
//  .S01_AXI_awcache(4'b0000),            // input wire [3 : 0] S01_AXI_AWCACHE
  .S01_AXI_awprot(3'd0),              // input wire [2 : 0] S01_AXI_AWPROT
//  .S01_AXI_awqos(4'd0),                // input wire [3 : 0] S01_AXI_AWQOS
  .S01_AXI_awvalid(arm_m_axil_pcie_awvalid),            // input wire S01_AXI_AWVALID
  .S01_AXI_awready(arm_m_axil_pcie_awready),            // output wire S01_AXI_AWREADY
  .S01_AXI_wdata(arm_m_axil_pcie_wdata),                // input wire [31 : 0] S01_AXI_WDATA
  .S01_AXI_wstrb(4'b1111),                // input wire [3 : 0] S01_AXI_WSTRB
//  .S01_AXI_wlast(arm_m_axil_pcie_wvalid),                // input wire S01_AXI_WLAST
  .S01_AXI_wvalid(arm_m_axil_pcie_wvalid),              // input wire S01_AXI_WVALID
  .S01_AXI_wready(arm_m_axil_pcie_wready),              // output wire S01_AXI_WREADY
  //.S01_AXI_bid(1'b0),                    // output wire [0 : 0] S01_AXI_BID
  .S01_AXI_bresp(arm_m_axil_pcie_bresp),                // output wire [1 : 0] S01_AXI_BRESP
  .S01_AXI_bvalid(arm_m_axil_pcie_bvalid),              // output wire S01_AXI_BVALID
  .S01_AXI_bready(arm_m_axil_pcie_bready),              // input wire S01_AXI_BREADY
  //.S01_AXI_arid(1'b0),                  // input wire [0 : 0] S01_AXI_ARID
  .S01_AXI_araddr(arm_m_axil_pcie_araddr),              // input wire [31 : 0] S01_AXI_ARADDR
//  .S01_AXI_arlen(8'd0),                // input wire [7 : 0] S01_AXI_ARLEN
//  .S01_AXI_arsize(3'b010),              // input wire [2 : 0] S01_AXI_ARSIZE
//  .S01_AXI_arburst(2'b01),            // input wire [1 : 0] S01_AXI_ARBURST
//  .S01_AXI_arlock(1'b0),              // input wire S01_AXI_ARLOCK
//  .S01_AXI_arcache(4'b0000),            // input wire [3 : 0] S01_AXI_ARCACHE
  .S01_AXI_arprot(3'd0),              // input wire [2 : 0] S01_AXI_ARPROT
//  .S01_AXI_arqos(4'd0),                // input wire [3 : 0] S01_AXI_ARQOS
  .S01_AXI_arvalid(arm_m_axil_pcie_arvalid),            // input wire S01_AXI_ARVALID
  .S01_AXI_arready(arm_m_axil_pcie_arready),            // output wire S01_AXI_ARREADY
  //.S01_AXI_rid(1'b0),                    // output wire [0 : 0] S01_AXI_RID
  .S01_AXI_rdata(arm_m_axil_pcie_rdata),                // output wire [31 : 0] S01_AXI_RDATA
  .S01_AXI_rresp(arm_m_axil_pcie_rresp),                // output wire [1 : 0] S01_AXI_RRESP
//  .S01_AXI_rlast(),                // output wire S01_AXI_RLAST
  .S01_AXI_rvalid(arm_m_axil_pcie_rvalid),              // output wire S01_AXI_RVALID
  .S01_AXI_rready(arm_m_axil_pcie_rready),              // input wire S01_AXI_RREADY
  .M00_ACLK(axil_aclk),                  // input wire M00_AXI_ACLK
//  .M00_AXI_awid(1'b0),                  // output wire [3 : 0] M00_AXI_AWID
  .M00_AXI_awaddr(m_axil_pcie_awaddr),              // output wire [31 : 0] M00_AXI_AWADDR
//  .M00_AXI_awlen(),                // output wire [7 : 0] M00_AXI_AWLEN
//  .M00_AXI_awsize(),              // output wire [2 : 0] M00_AXI_AWSIZE
//  .M00_AXI_awburst(),            // output wire [1 : 0] M00_AXI_AWBURST
//  .M00_AXI_awlock(),              // output wire M00_AXI_AWLOCK
//  .M00_AXI_awcache(),            // output wire [3 : 0] M00_AXI_AWCACHE
  .M00_AXI_awprot(),              // output wire [2 : 0] M00_AXI_AWPROT
//  .M00_AXI_awqos(),                // output wire [3 : 0] M00_AXI_AWQOS
  .M00_AXI_awvalid(m_axil_pcie_awvalid),            // output wire M00_AXI_AWVALID
  .M00_AXI_awready(m_axil_pcie_awready),            // input wire M00_AXI_AWREADY
  .M00_AXI_wdata(m_axil_pcie_wdata),                // output wire [31 : 0] M00_AXI_WDATA
  .M00_AXI_wstrb(),                // output wire [3 : 0] M00_AXI_WSTRB
//  .M00_AXI_wlast(),                // output wire M00_AXI_WLAST
  .M00_AXI_wvalid(m_axil_pcie_wvalid),              // output wire M00_AXI_WVALID
  .M00_AXI_wready(m_axil_pcie_wready),              // input wire M00_AXI_WREADY
//  .M00_AXI_bid(1'b0),                    // input wire [3 : 0] M00_AXI_BID
  .M00_AXI_bresp(m_axil_pcie_bresp),                // input wire [1 : 0] M00_AXI_BRESP
  .M00_AXI_bvalid(m_axil_pcie_bvalid),              // input wire M00_AXI_BVALID
  .M00_AXI_bready(m_axil_pcie_bready),              // output wire M00_AXI_BREADY
//  .M00_AXI_arid(),                  // output wire [3 : 0] M00_AXI_ARID
  .M00_AXI_araddr(m_axil_pcie_araddr),              // output wire [31 : 0] M00_AXI_ARADDR
//  .M00_AXI_arlen(),                // output wire [7 : 0] M00_AXI_ARLEN
//  .M00_AXI_arsize(),              // output wire [2 : 0] M00_AXI_ARSIZE
//  .M00_AXI_arburst(),            // output wire [1 : 0] M00_AXI_ARBURST
//  .M00_AXI_arlock(),              // output wire M00_AXI_ARLOCK
//  .M00_AXI_arcache(),            // output wire [3 : 0] M00_AXI_ARCACHE
  .M00_AXI_arprot(),              // output wire [2 : 0] M00_AXI_ARPROT
//  .M00_AXI_arqos(),                // output wire [3 : 0] M00_AXI_ARQOS
  .M00_AXI_arvalid(m_axil_pcie_arvalid),            // output wire M00_AXI_ARVALID
  .M00_AXI_arready(m_axil_pcie_arready),            // input wire M00_AXI_ARREADY
//  .M00_AXI_rid(1'b0),                    // input wire [3 : 0] M00_AXI_RID
  .M00_AXI_rdata(m_axil_pcie_rdata),                // input wire [31 : 0] M00_AXI_RDATA
  .M00_AXI_rresp(m_axil_pcie_rresp),                // input wire [1 : 0] M00_AXI_RRESP
//  .M00_AXI_rlast(m_axil_pcie_rvalid),                // input wire M00_AXI_RLAST
  .M00_AXI_rvalid(m_axil_pcie_rvalid),              // input wire M00_AXI_RVALID
  .M00_AXI_rready(m_axil_pcie_rready),  // output wire M00_AXI_RREADY
  .M00_ARESETN (powerup_rstn),
  .S00_ARESETN (powerup_rstn),
  .S01_ARESETN (arm_powerup_rstn),
  
  // CMS ports 
  .interrupt_host (interrupt_host),
  .satellite_gpio (satellite_gpio),
  .satellite_uart_rxd (satellite_uart_rxd),
  .satellite_uart_txd (satellite_uart_txd)
  //.spi_flash_io0_io (spi_flash_io0_io),
  //.spi_flash_io1_io (spi_flash_io1_io),
  //.spi_flash_io2_io (spi_flash_io2_io),
  //.spi_flash_io3_io (spi_flash_io3_io),
  //.spi_flash_sck_io (spi_flash_sck_io),
  //.spi_flash_ss_io (spi_flash_ss_io)
);

// H2C AXIS Interconnect
//  x86 QDMA , S00 ---->
//                      ----> To CMAC 
//   ARM QDMA , S01 ---->
h2c_axis_interconnect_1 h2c_axis_interconnect_inst (
  .ACLK(axis_aclk),                                  // input wire ACLK
  .ARESETN(powerup_rstn),                            // input wire ARESETN
  .S00_AXIS_ACLK(axis_aclk),                // input wire S00_AXIS_ACLK
  .S01_AXIS_ACLK(arm_axis_aclk),                // input wire S01_AXIS_ACLK
  .S00_AXIS_ARESETN(powerup_rstn),          // input wire S00_AXIS_ARESETN
  .S01_AXIS_ARESETN(arm_powerup_rstn),          // input wire S01_AXIS_ARESETN
  .S00_AXIS_TVALID(x86_axis_qdma_h2c_tvalid ),            // input wire S00_AXIS_TVALID
  .S01_AXIS_TVALID(arm_axis_qdma_h2c_tvalid),            // input wire S01_AXIS_TVALID
  .S00_AXIS_TREADY(x86_axis_qdma_h2c_tready),            // output wire S00_AXIS_TREADY
  .S01_AXIS_TREADY(arm_axis_qdma_h2c_tready),            // output wire S01_AXIS_TREADY
  .S00_AXIS_TDATA(x86_axis_qdma_h2c_tdata),              // input wire [511 : 0] S00_AXIS_TDATA
  .S01_AXIS_TDATA(arm_axis_qdma_h2c_tdata),              // input wire [511 : 0] S01_AXIS_TDATA
  .S00_AXIS_TLAST(x86_axis_qdma_h2c_tlast),              // input wire S00_AXIS_TLAST
  .S01_AXIS_TLAST(arm_axis_qdma_h2c_tlast),              // input wire S01_AXIS_TLAST
  .S00_AXIS_TUSER(x86_axis_qdma_h2c_tuser),              // input wire [127 : 0] S00_AXIS_TUSER
  .S01_AXIS_TUSER(arm_axis_qdma_h2c_tuser),              // input wire [127 : 0] S01_AXIS_TUSER
  .M00_AXIS_ACLK(axis_aclk),                // input wire M00_AXIS_ACLK
  .M00_AXIS_ARESETN (powerup_rstn),          // input wire M00_AXIS_ARESETN
  .M00_AXIS_TVALID(axis_qdma_h2c_tvalid),            // output wire M00_AXIS_TVALID
  .M00_AXIS_TREADY(axis_qdma_h2c_tready),            // input wire M00_AXIS_TREADY
  .M00_AXIS_TDATA(axis_qdma_h2c_tdata),              // output wire [511 : 0] M00_AXIS_TDATA
  .M00_AXIS_TLAST(axis_qdma_h2c_tlast),              // output wire M00_AXIS_TLAST
  .M00_AXIS_TUSER(axis_qdma_h2c_tuser),              // output wire [127 : 0] M00_AXIS_TUSER
  .S00_ARB_REQ_SUPPRESS(1'b0),  // input wire S00_ARB_REQ_SUPPRESS
  .S01_ARB_REQ_SUPPRESS(1'b0)  // input wire S01_ARB_REQ_SUPPRESS
);

wire data_direction;

// C2H AXIS Interconnect
//   			             x86 QDMA , M00 ---->
//   QDMA Subsystem C2H (S00) ---->  
//   				     ARM QDMA , M01 ---->
c2h_axis_interconnect_1 c2h_axis_interconnect_inst (
  .ACLK(axis_aclk),                          // input wire ACLK
  .ARESETN(powerup_rstn),                    // input wire ARESETN
  .S00_AXIS_ACLK(axis_aclk),        // input wire S00_AXIS_ACLK
  .S00_AXIS_ARESETN(powerup_rstn),  // input wire S00_AXIS_ARESETN
  .S00_AXIS_TVALID(axis_qdma_c2h_tvalid),    // input wire S00_AXIS_TVALID
  .S00_AXIS_TREADY(axis_qdma_c2h_tready),    // output wire S00_AXIS_TREADY
  .S00_AXIS_TDATA(axis_qdma_c2h_tdata),      // input wire [511 : 0] S00_AXIS_TDATA
  .S00_AXIS_TLAST(axis_qdma_c2h_tlast),      // input wire S00_AXIS_TLAST
  .S00_AXIS_TDEST(data_direction),      // input wire [0 : 0] S00_AXIS_TDEST
  .S00_AXIS_TUSER(axis_qdma_c2h_tuser),      // input wire [127 : 0] S00_AXIS_TUSER
  .M00_AXIS_ACLK(axis_aclk),        // input wire M00_AXIS_ACLK
  .M01_AXIS_ACLK(arm_axis_aclk),        // input wire M01_AXIS_ACLK
  .M00_AXIS_ARESETN(powerup_rstn),  // input wire M00_AXIS_ARESETN
  .M01_AXIS_ARESETN(arm_powerup_rstn),  // input wire M01_AXIS_ARESETN
  .M00_AXIS_TVALID(x86_axis_qdma_c2h_tvalid),    // output wire M00_AXIS_TVALID
  .M01_AXIS_TVALID(arm_axis_qdma_c2h_tvalid),    // output wire M01_AXIS_TVALID
  .M00_AXIS_TREADY(x86_axis_qdma_c2h_tready),    // input wire M00_AXIS_TREADY
  .M01_AXIS_TREADY(arm_axis_qdma_c2h_tready),    // input wire M01_AXIS_TREADY
  .M00_AXIS_TDATA(x86_axis_qdma_c2h_tdata),      // output wire [511 : 0] M00_AXIS_TDATA
  .M01_AXIS_TDATA(arm_axis_qdma_c2h_tdata),      // output wire [511 : 0] M01_AXIS_TDATA
  .M00_AXIS_TLAST(x86_axis_qdma_c2h_tlast),      // output wire M00_AXIS_TLAST
  .M01_AXIS_TLAST(arm_axis_qdma_c2h_tlast),      // output wire M01_AXIS_TLAST
  .M00_AXIS_TDEST(),      // output wire [0 : 0] M00_AXIS_TDEST
  .M01_AXIS_TDEST(),      // output wire [0 : 0] M01_AXIS_TDEST
  .M00_AXIS_TUSER(x86_axis_qdma_c2h_tuser),      // output wire [127 : 0] M00_AXIS_TUSER
  .M01_AXIS_TUSER(arm_axis_qdma_c2h_tuser),      // output wire [127 : 0] M01_AXIS_TUSER
  .S00_DECODE_ERR()      // output wire S00_DECODE_ERR
);

//VIO to select packet direction
vio_0_1 vio_0_inst (
.clk (axis_aclk),
.probe_out0 (data_direction)

);


// CPL AXIS Interconnect
//   			             x86 QDMA , M00 ---->
//   QDMA Subsystem C2H (S00) ---->  
//   				     ARM QDMA , M01 ---->

cpl_axis_interconnect_1 cpl_axis_interconnect_inst (
  .ACLK(axis_aclk),                          // input wire ACLK
  .ARESETN(powerup_rstn),                    // input wire ARESETN
  .S00_AXIS_ACLK(axis_aclk),        // input wire S00_AXIS_ACLK
  .S00_AXIS_ARESETN(powerup_rstn),  // input wire S00_AXIS_ARESETN
  .S00_AXIS_TVALID(axis_qdma_cpl_tvalid),    // input wire S00_AXIS_TVALID
  .S00_AXIS_TREADY(axis_qdma_cpl_tready),    // output wire S00_AXIS_TREADY
  .S00_AXIS_TDATA(axis_qdma_cpl_tdata),      // input wire [511 : 0] S00_AXIS_TDATA
  .S00_AXIS_TDEST(data_direction),      // input wire [0 : 0] S00_AXIS_TDEST
  .S00_AXIS_TUSER(axis_qdma_cpl_tuser),      // input wire [127 : 0] S00_AXIS_TUSER
  .M00_AXIS_ACLK(axis_aclk),        // input wire M00_AXIS_ACLK
  .M01_AXIS_ACLK(arm_axis_aclk),        // input wire M01_AXIS_ACLK
  .M00_AXIS_ARESETN(powerup_rstn),  // input wire M00_AXIS_ARESETN
  .M01_AXIS_ARESETN(arm_powerup_rstn),  // input wire M01_AXIS_ARESETN
  .M00_AXIS_TVALID(x86_axis_qdma_cpl_tvalid),    // output wire M00_AXIS_TVALID
  .M01_AXIS_TVALID(arm_axis_qdma_cpl_tvalid),    // output wire M01_AXIS_TVALID
  .M00_AXIS_TREADY(x86_axis_qdma_cpl_tready),    // input wire M00_AXIS_TREADY
  .M01_AXIS_TREADY(arm_axis_qdma_cpl_tready),    // input wire M01_AXIS_TREADY
  .M00_AXIS_TDATA(x86_axis_qdma_cpl_tdata),      // output wire [511 : 0] M00_AXIS_TDATA
  .M01_AXIS_TDATA(arm_axis_qdma_cpl_tdata),      // output wire [511 : 0] M01_AXIS_TDATA
  .M00_AXIS_TDEST(),      // output wire [0 : 0] M00_AXIS_TDEST
  .M01_AXIS_TDEST(),      // output wire [0 : 0] M01_AXIS_TDEST
  .M00_AXIS_TUSER(x86_axis_qdma_cpl_tuser),      // output wire [127 : 0] M00_AXIS_TUSER
  .M01_AXIS_TUSER(arm_axis_qdma_cpl_tuser),      // output wire [127 : 0] M01_AXIS_TUSER
  .S00_DECODE_ERR()      // output wire S00_DECODE_ERR
);

wire arm_mod_rst_done;

  // Reset is clocked by the 125MHz AXI-Lite clock
  generic_reset #(
    .NUM_INPUT_CLK  (1),
    .RESET_DURATION (100)
  ) reset_inst (
    .mod_rstn     (mod_rstn),
    .mod_rst_done (mod_rst_done),
    .clk          (axil_aclk),
    .rstn         (axil_aresetn)
  );

//  assign axil_aresetn = mod_rstn;

  // Reset is clocked by the 125MHz AXI-Lite clock
//  generic_reset #(
//    .NUM_INPUT_CLK  (1),
//    .RESET_DURATION (100)
//  ) arm_reset_inst (
//    .mod_rstn     (mod_rstn),
//    .mod_rst_done (arm_mod_rst_done),
//    .clk          (arm_axil_aclk),
//    .rstn         (arm_axil_aresetn)
//  );

  assign arm_axil_aresetn = mod_rstn;


`ifdef __synthesis__
  wire         pcie_refclk_gt;
  wire         pcie_refclk;

  IBUFDS_GTE4 pcie_refclk_buf (
    .CEB   (1'b0),
    .I     (pcie_refclk_p),
    .IB    (pcie_refclk_n),
    .O     (pcie_refclk_gt),
    .ODIV2 (pcie_refclk)
  );

  wire         arm_pcie_refclk_gt;
  wire         arm_pcie_refclk;

  IBUFDS_GTE4 pcie_refclk_buf_arm (
    .CEB   (1'b0),
    .I     (arm_pcie_refclk_p),
    .IB    (arm_pcie_refclk_n),
    .O     (arm_pcie_refclk_gt),
    .ODIV2 (arm_pcie_refclk)
  );

  assign h2c_byp_out_rdy            = 1'b1;
  assign h2c_byp_in_st_vld          = 1'b0;
  assign h2c_byp_in_st_addr         = 0;
  assign h2c_byp_in_st_len          = 0;
  assign h2c_byp_in_st_eop          = 1'b0;
  assign h2c_byp_in_st_sop          = 1'b0;
  assign h2c_byp_in_st_mrkr_req     = 1'b0;
  assign h2c_byp_in_st_port_id      = 0;
  assign h2c_byp_in_st_sdi          = 1'b0;
  assign h2c_byp_in_st_qid          = 0;
  assign h2c_byp_in_st_error        = 1'b0;
  assign h2c_byp_in_st_func         = 0;
  assign h2c_byp_in_st_cidx         = 0;
  assign h2c_byp_in_st_no_dma       = 1'b0;

  assign c2h_byp_out_rdy            = 1'b1;
  assign c2h_byp_in_st_csh_vld      = 1'b0;
  assign c2h_byp_in_st_csh_addr     = 0;
  assign c2h_byp_in_st_csh_port_id  = 0;
  assign c2h_byp_in_st_csh_qid      = 0;
  assign c2h_byp_in_st_csh_error    = 1'b0;
  assign c2h_byp_in_st_csh_func     = 0;
  assign c2h_byp_in_st_csh_pfch_tag = 0;

// ARM QDMA wires

  assign arm_h2c_byp_out_rdy            = 1'b1;
  assign arm_h2c_byp_in_st_vld          = 1'b0;
  assign arm_h2c_byp_in_st_addr         = 0;
  assign arm_h2c_byp_in_st_len          = 0;
  assign arm_h2c_byp_in_st_eop          = 1'b0;
  assign arm_h2c_byp_in_st_sop          = 1'b0;
  assign arm_h2c_byp_in_st_mrkr_req     = 1'b0;
  assign arm_h2c_byp_in_st_port_id      = 0;
  assign arm_h2c_byp_in_st_sdi          = 1'b0;
  assign arm_h2c_byp_in_st_qid          = 0;
  assign arm_h2c_byp_in_st_error        = 1'b0;
  assign arm_h2c_byp_in_st_func         = 0;
  assign arm_h2c_byp_in_st_cidx         = 0;
  assign arm_h2c_byp_in_st_no_dma       = 1'b0;

  assign arm_c2h_byp_out_rdy            = 1'b1;
  assign arm_c2h_byp_in_st_csh_vld      = 1'b0;
  assign arm_c2h_byp_in_st_csh_addr     = 0;
  assign arm_c2h_byp_in_st_csh_port_id  = 0;
  assign arm_c2h_byp_in_st_csh_qid      = 0;
  assign arm_c2h_byp_in_st_csh_error    = 1'b0;
  assign arm_c2h_byp_in_st_csh_func     = 0;
  assign arm_c2h_byp_in_st_csh_pfch_tag = 0;

/*
  design_1_wrapper two_qdmas (

    .arm_pcie_mgt_0_rxn (arm_pcie_mgt_0_rxn),
    .arm_pcie_mgt_0_rxp (arm_pcie_mgt_0_rxp),
    .arm_pcie_mgt_0_txn (arm_pcie_mgt_0_txn),
    .arm_pcie_mgt_0_txp (arm_pcie_mgt_0_txp),
    .axi_aclk_arm (arm_axis_aclk),
    .axi_aclk_x86 (axis_aclk),
    .axil_aclk (axil_aclk),
    .axi_aresetn_arm (axi_aresetn_arm),
    .axi_aresetn_x86 (powerup_rstn),
    .m_axil_pcie_araddr (m_axil_pcie_araddr),
    .m_axil_pcie_arburst (m_axil_pcie_arburst),
    .m_axil_pcie_arcache (m_axil_pcie_arcache),
    .m_axil_pcie_arlen (m_axil_pcie_arlen),
    .m_axil_pcie_arlock (m_axil_pcie_arlock),
    .m_axil_pcie_arprot (m_axil_pcie_arprot),
    .m_axil_pcie_arqos (m_axil_pcie_arqos),
    .m_axil_pcie_arready (m_axil_pcie_arready),
    .m_axil_pcie_arsize (m_axil_pcie_arsize),
    //.m_axil_pcie_aruser (m_axil_pcie_aruser),
    .m_axil_pcie_arvalid (m_axil_pcie_arvalid),
    .m_axil_pcie_awaddr (m_axil_pcie_awaddr),
    .m_axil_pcie_awburst (m_axil_pcie_awburst),
    .m_axil_pcie_awcache (m_axil_pcie_awcache),
    .m_axil_pcie_awlen (m_axil_pcie_awlen),
    .m_axil_pcie_awlock (m_axil_pcie_awlock),
    .m_axil_pcie_awprot (m_axil_pcie_awprot),
    .m_axil_pcie_awqos (m_axil_pcie_awqos),
    .m_axil_pcie_awready (m_axil_pcie_awready),
    .m_axil_pcie_awsize (m_axil_pcie_awsize),
    //.m_axil_pcie_awuser (m_axil_pcie_awuser),
    .m_axil_pcie_awvalid (m_axil_pcie_awvalid),
    .m_axil_pcie_bready (m_axil_pcie_bready),
    .m_axil_pcie_bresp (m_axil_pcie_bresp),
    .m_axil_pcie_bvalid (m_axil_pcie_bvalid),
    .m_axil_pcie_rdata (m_axil_pcie_rdata),
    .m_axil_pcie_rlast (m_axil_pcie_rvalid),
    .m_axil_pcie_rready (m_axil_pcie_rready),
    .m_axil_pcie_rresp (m_axil_pcie_rresp),
    .m_axil_pcie_rvalid (m_axil_pcie_rvalid),
    .m_axil_pcie_wdata (m_axil_pcie_wdata),
    .m_axil_pcie_wlast (m_axil_pcie_wlast),
    .m_axil_pcie_wready (m_axil_pcie_wready),
    .m_axil_pcie_wstrb (m_axil_pcie_wstrb),
    .m_axil_pcie_wvalid (m_axil_pcie_wvalid),
    .pcie_refclk (pcie_refclk),
    .pcie_ref_clk_gt (pcie_refclk_gt),
    .pcie_rstn (pcie_rstn),
    .pcie_rxn (pcie_rxn),
    .pcie_rxp (pcie_rxp),
    .pcie_txn (pcie_txn),
    .pcie_txp (pcie_txp),
    .soft_reset_arm (mod_rstn),
    .soft_reset_x86 (mod_rstn),
    .arm_pcie_refclk (arm_pcie_refclk),
    .arm_pcie_refclk_gt (arm_pcie_refclk_gt),
    .arm_pcie_rstn (arm_pcie_rstn),

    .x86_axis_qdma_c2h_ctrl_has_cmpt(x86_axis_qdma_c2h_ctrl_has_cmpt),
    .x86_axis_qdma_c2h_ctrl_len (x86_axis_qdma_c2h_ctrl_len),
    .x86_axis_qdma_c2h_ctrl_marker (x86_axis_qdma_c2h_ctrl_marker),
    .x86_axis_qdma_c2h_ctrl_port_id (x86_axis_qdma_c2h_ctrl_port_id),
    .x86_axis_qdma_c2h_ctrl_qid (x86_axis_qdma_c2h_ctrl_qid),
    .x86_axis_qdma_c2h_ecc (x86_axis_qdma_c2h_ctrl_ecc),
    .x86_axis_qdma_c2h_mty (x86_axis_qdma_c2h_mty),
    .x86_axis_qdma_c2h_tcrc (x86_axis_qdma_c2h_tcrc),
    .x86_axis_qdma_c2h_tdata (x86_axis_qdma_c2h_tdata),
    .x86_axis_qdma_c2h_tlast (x86_axis_qdma_c2h_tlast),
    .x86_axis_qdma_c2h_tready (x86_axis_qdma_c2h_tready),
    .x86_axis_qdma_c2h_tvalid (x86_axis_qdma_c2h_tvalid),
    .x86_axis_qdma_cpl_cmpt_type (x86_axis_qdma_cpl_ctrl_cmpt_type),
    .x86_axis_qdma_cpl_col_idx (x86_axis_qdma_cpl_ctrl_col_idx),
    .x86_axis_qdma_cpl_data (x86_axis_qdma_cpl_tdata),
    .x86_axis_qdma_cpl_dpar (x86_axis_qdma_cpl_dpar),
    .x86_axis_qdma_cpl_err_idx (x86_axis_qdma_cpl_ctrl_err_idx),
    .x86_axis_qdma_cpl_marker (x86_axis_qdma_cpl_ctrl_marker),
    .x86_axis_qdma_cpl_no_wrb_marker (x86_axis_qdma_cpl_ctrl_no_wrb_marker),
    .x86_axis_qdma_cpl_port_id (x86_axis_qdma_cpl_ctrl_port_id),
    .x86_axis_qdma_cpl_qid (x86_axis_qdma_cpl_ctrl_qid),
    .x86_axis_qdma_cpl_size (x86_axis_qdma_cpl_size),
    .x86_axis_qdma_cpl_tready (x86_axis_qdma_cpl_tready),
    .x86_axis_qdma_cpl_tvalid (x86_axis_qdma_cpl_tvalid),
    .x86_axis_qdma_cpl_user_trig (x86_axis_qdma_cpl_ctrl_user_trig),
    .x86_axis_qdma_cpl_wait_pld_pkt_id (x86_axis_qdma_cpl_ctrl_wait_pld_pkt_id),
    .x86_axis_qdma_h2c_err (x86_axis_qdma_h2c_tuser_err),
    .x86_axis_qdma_h2c_mdata (x86_axis_qdma_h2c_tuser_mdata),
    .x86_axis_qdma_h2c_mty (x86_axis_qdma_h2c_tuser_mty),
    .x86_axis_qdma_h2c_port_id (x86_axis_qdma_h2c_tuser_port_id),
    .x86_axis_qdma_h2c_qid (x86_axis_qdma_h2c_tuser_qid),
    .x86_axis_qdma_h2c_tcrc (x86_axis_qdma_h2c_tcrc),
    .x86_axis_qdma_h2c_tdata (x86_axis_qdma_h2c_tdata),
    .x86_axis_qdma_h2c_tlast (x86_axis_qdma_h2c_tlast),
    .x86_axis_qdma_h2c_tready (x86_axis_qdma_h2c_tready),
    .x86_axis_qdma_h2c_tvalid (x86_axis_qdma_h2c_tvalid),
    .x86_axis_qdma_h2c_zero_byte (x86_axis_qdma_h2c_tuser_zero_byte),


    .arm_axis_qdma_c2h_ctrl_has_cmpt (arm_axis_qdma_c2h_ctrl_has_cmpt),
    .arm_axis_qdma_c2h_ctrl_len (arm_axis_qdma_c2h_ctrl_len),
    .arm_axis_qdma_c2h_ctrl_marker (arm_axis_qdma_c2h_ctrl_marker),
    .arm_axis_qdma_c2h_ctrl_port_id (arm_axis_qdma_c2h_ctrl_port_id),
    .arm_axis_qdma_c2h_ctrl_qid (arm_axis_qdma_c2h_ctrl_qid),
    .arm_axis_qdma_c2h_ecc (arm_axis_qdma_c2h_ctrl_ecc),
    .arm_axis_qdma_c2h_mty (arm_axis_qdma_c2h_mty),
    .arm_axis_qdma_c2h_tcrc (arm_axis_qdma_c2h_tcrc),
    .arm_axis_qdma_c2h_tdata (arm_axis_qdma_c2h_tdata),
    .arm_axis_qdma_c2h_tlast (arm_axis_qdma_c2h_tlast),
    .arm_axis_qdma_c2h_tready (arm_axis_qdma_c2h_tready),
    .arm_axis_qdma_c2h_tvalid (arm_axis_qdma_c2h_tvalid),
    .arm_axis_qdma_cpl_cmpt_type (arm_axis_qdma_cpl_ctrl_cmpt_type),
    .arm_axis_qdma_cpl_col_idx (arm_axis_qdma_cpl_ctrl_col_idx),
    .arm_axis_qdma_cpl_data (arm_axis_qdma_cpl_tdata),
    .arm_axis_qdma_cpl_dpar (arm_axis_qdma_cpl_dpar),
    .arm_axis_qdma_cpl_err_idx (arm_axis_qdma_cpl_ctrl_err_idx),
    .arm_axis_qdma_cpl_marker (arm_axis_qdma_cpl_ctrl_marker),
    .arm_axis_qdma_cpl_no_wrb_marker (arm_axis_qdma_cpl_ctrl_no_wrb_marker),
    .arm_axis_qdma_cpl_port_id (arm_axis_qdma_cpl_ctrl_port_id),
    .arm_axis_qdma_cpl_qid (arm_axis_qdma_cpl_ctrl_qid),
    .arm_axis_qdma_cpl_size (arm_axis_qdma_cpl_size),
    .arm_axis_qdma_cpl_tready (arm_axis_qdma_cpl_tready),
    .arm_axis_qdma_cpl_tvalid (arm_axis_qdma_cpl_tvalid),
    .arm_axis_qdma_cpl_user_trig (arm_axis_qdma_cpl_ctrl_user_trig),
    .arm_axis_qdma_cpl_wait_pld_pkt_id (arm_axis_qdma_cpl_ctrl_wait_pld_pkt_id),
    .arm_axis_qdma_h2c_err (arm_axis_qdma_h2c_tuser_err),
    .arm_axis_qdma_h2c_mdata (arm_axis_qdma_h2c_tuser_mdata),
    .arm_axis_qdma_h2c_mty (arm_axis_qdma_h2c_tuser_mty),
    .arm_axis_qdma_h2c_port_id (arm_axis_qdma_h2c_tuser_port_id),
    .arm_axis_qdma_h2c_qid (arm_axis_qdma_h2c_tuser_qid),
    .arm_axis_qdma_h2c_tcrc (arm_axis_qdma_h2c_tcrc),
    .arm_axis_qdma_h2c_tdata (arm_axis_qdma_h2c_tdata),
    .arm_axis_qdma_h2c_tlast (arm_axis_qdma_h2c_tlast),
    .arm_axis_qdma_h2c_tready (arm_axis_qdma_h2c_tready),
    .arm_axis_qdma_h2c_tvalid (arm_axis_qdma_h2c_tvalid),
    .arm_axis_qdma_h2c_zero_byte (arm_axis_qdma_h2c_tuser_zero_byte)    

  );
  */

  qdma_subsystem_qdma_wrapper #(1) 
  qdma_wrapper_inst (
    .pcie_rxp                        (pcie_rxp),
    .pcie_rxn                        (pcie_rxn),
    .pcie_txp                        (pcie_txp),
    .pcie_txn                        (pcie_txn),

    .m_axil_awvalid                  (x86_m_axil_pcie_awvalid),
    .m_axil_awaddr                   (x86_m_axil_pcie_awaddr),
    .m_axil_awready                  (x86_m_axil_pcie_awready),
    .m_axil_wvalid                   (x86_m_axil_pcie_wvalid),
    .m_axil_wdata                    (x86_m_axil_pcie_wdata),
    .m_axil_wready                   (x86_m_axil_pcie_wready),
    .m_axil_bvalid                   (x86_m_axil_pcie_bvalid),
    .m_axil_bresp                    (x86_m_axil_pcie_bresp),
    .m_axil_bready                   (x86_m_axil_pcie_bready),
    .m_axil_arvalid                  (x86_m_axil_pcie_arvalid),
    .m_axil_araddr                   (x86_m_axil_pcie_araddr),
    .m_axil_arready                  (x86_m_axil_pcie_arready),
    .m_axil_rvalid                   (x86_m_axil_pcie_rvalid),
    .m_axil_rdata                    (x86_m_axil_pcie_rdata),
    .m_axil_rresp                    (x86_m_axil_pcie_rresp),
    .m_axil_rready                   (x86_m_axil_pcie_rready),

    .m_axis_h2c_tvalid               (x86_axis_qdma_h2c_tvalid),
    .m_axis_h2c_tdata                (x86_axis_qdma_h2c_tdata),
    .m_axis_h2c_tcrc                 (x86_axis_qdma_h2c_tcrc),
    .m_axis_h2c_tlast                (x86_axis_qdma_h2c_tlast),
    .m_axis_h2c_tuser_qid            (x86_axis_qdma_h2c_tuser_qid),
    .m_axis_h2c_tuser_port_id        (x86_axis_qdma_h2c_tuser_port_id),
    .m_axis_h2c_tuser_err            (x86_axis_qdma_h2c_tuser_err),
    .m_axis_h2c_tuser_mdata          (x86_axis_qdma_h2c_tuser_mdata),
    .m_axis_h2c_tuser_mty            (x86_axis_qdma_h2c_tuser_mty),
    .m_axis_h2c_tuser_zero_byte      (x86_axis_qdma_h2c_tuser_zero_byte),
    .m_axis_h2c_tready               (x86_axis_qdma_h2c_tready),

    .s_axis_c2h_tvalid               (x86_axis_qdma_c2h_tvalid),
    .s_axis_c2h_tdata                (x86_axis_qdma_c2h_tdata),
    .s_axis_c2h_tcrc                 (x86_axis_qdma_c2h_tcrc),
    .s_axis_c2h_tlast                (x86_axis_qdma_c2h_tlast),
    .s_axis_c2h_ctrl_marker          (x86_axis_qdma_c2h_ctrl_marker),
    .s_axis_c2h_ctrl_port_id         (x86_axis_qdma_c2h_ctrl_port_id),
    .s_axis_c2h_ctrl_ecc             (x86_axis_qdma_c2h_ctrl_ecc),
    .s_axis_c2h_ctrl_len             (x86_axis_qdma_c2h_ctrl_len),
    .s_axis_c2h_ctrl_qid             (x86_axis_qdma_c2h_ctrl_qid),
    .s_axis_c2h_ctrl_has_cmpt        (x86_axis_qdma_c2h_ctrl_has_cmpt),
    .s_axis_c2h_mty                  (x86_axis_qdma_c2h_mty),
    .s_axis_c2h_tready               (x86_axis_qdma_c2h_tready),

    .s_axis_cpl_tvalid               (x86_axis_qdma_cpl_tvalid),
    .s_axis_cpl_tdata                (x86_axis_qdma_cpl_tdata),
    .s_axis_cpl_size                 (x86_axis_qdma_cpl_size),
    .s_axis_cpl_dpar                 (x86_axis_qdma_cpl_dpar),
    .s_axis_cpl_ctrl_qid             (x86_axis_qdma_cpl_ctrl_qid),
    .s_axis_cpl_ctrl_cmpt_type       (x86_axis_qdma_cpl_ctrl_cmpt_type),
    .s_axis_cpl_ctrl_wait_pld_pkt_id (x86_axis_qdma_cpl_ctrl_wait_pld_pkt_id),
    .s_axis_cpl_ctrl_port_id         (x86_axis_qdma_cpl_ctrl_port_id),
    .s_axis_cpl_ctrl_marker          (x86_axis_qdma_cpl_ctrl_marker),
    .s_axis_cpl_ctrl_user_trig       (x86_axis_qdma_cpl_ctrl_user_trig),
    .s_axis_cpl_ctrl_col_idx         (x86_axis_qdma_cpl_ctrl_col_idx),
    .s_axis_cpl_ctrl_err_idx         (x86_axis_qdma_cpl_ctrl_err_idx),
    .s_axis_cpl_ctrl_no_wrb_marker   (x86_axis_qdma_cpl_ctrl_no_wrb_marker),
    .s_axis_cpl_tready               (x86_axis_qdma_cpl_tready),

    .h2c_byp_out_vld                 (h2c_byp_out_vld),
    .h2c_byp_out_dsc                 (h2c_byp_out_dsc),
    .h2c_byp_out_st_mm               (h2c_byp_out_st_mm),
    .h2c_byp_out_dsc_sz              (h2c_byp_out_dsc_sz),
    .h2c_byp_out_qid                 (h2c_byp_out_qid),
    .h2c_byp_out_error               (h2c_byp_out_error),
    .h2c_byp_out_func                (h2c_byp_out_func),
    .h2c_byp_out_cidx                (h2c_byp_out_cidx),
    .h2c_byp_out_port_id             (h2c_byp_out_port_id),
    .h2c_byp_out_fmt                 (h2c_byp_out_fmt),
    .h2c_byp_out_rdy                 (h2c_byp_out_rdy),

    .h2c_byp_in_st_vld               (h2c_byp_in_st_vld),
    .h2c_byp_in_st_addr              (h2c_byp_in_st_addr),
    .h2c_byp_in_st_len               (h2c_byp_in_st_len),
    .h2c_byp_in_st_eop               (h2c_byp_in_st_eop),
    .h2c_byp_in_st_sop               (h2c_byp_in_st_sop),
    .h2c_byp_in_st_mrkr_req          (h2c_byp_in_st_mrkr_req),
    .h2c_byp_in_st_port_id           (h2c_byp_in_st_port_id),
    .h2c_byp_in_st_sdi               (h2c_byp_in_st_sdi),
    .h2c_byp_in_st_qid               (h2c_byp_in_st_qid),
    .h2c_byp_in_st_error             (h2c_byp_in_st_error),
    .h2c_byp_in_st_func              (h2c_byp_in_st_func),
    .h2c_byp_in_st_cidx              (h2c_byp_in_st_cidx),
    .h2c_byp_in_st_no_dma            (h2c_byp_in_st_no_dma),
    .h2c_byp_in_st_rdy               (h2c_byp_in_st_rdy),

    .c2h_byp_out_vld                 (c2h_byp_out_vld),
    .c2h_byp_out_dsc                 (c2h_byp_out_dsc),
    .c2h_byp_out_st_mm               (c2h_byp_out_st_mm),
    .c2h_byp_out_qid                 (c2h_byp_out_qid),
    .c2h_byp_out_dsc_sz              (c2h_byp_out_dsc_sz),
    .c2h_byp_out_error               (c2h_byp_out_error),
    .c2h_byp_out_func                (c2h_byp_out_func),
    .c2h_byp_out_cidx                (c2h_byp_out_cidx),
    .c2h_byp_out_port_id             (c2h_byp_out_port_id),
    .c2h_byp_out_fmt                 (c2h_byp_out_fmt),
    .c2h_byp_out_pfch_tag            (c2h_byp_out_pfch_tag),
    .c2h_byp_out_rdy                 (c2h_byp_out_rdy),

    .c2h_byp_in_st_csh_vld           (c2h_byp_in_st_csh_vld),
    .c2h_byp_in_st_csh_addr          (c2h_byp_in_st_csh_addr),
    .c2h_byp_in_st_csh_port_id       (c2h_byp_in_st_csh_port_id),
    .c2h_byp_in_st_csh_qid           (c2h_byp_in_st_csh_qid),
    .c2h_byp_in_st_csh_error         (c2h_byp_in_st_csh_error),
    .c2h_byp_in_st_csh_func          (c2h_byp_in_st_csh_func),
    .c2h_byp_in_st_csh_pfch_tag      (c2h_byp_in_st_csh_pfch_tag),
    .c2h_byp_in_st_csh_rdy           (c2h_byp_in_st_csh_rdy),

    .pcie_refclk                     (pcie_refclk),
    .pcie_refclk_gt                  (pcie_refclk_gt),
    .pcie_rstn                       (pcie_rstn),
    .user_lnk_up                     (user_lnk_up),
    .phy_ready                       (phy_ready),

    .soft_reset_n                    (axil_aresetn),

    .axil_aclk                       (axil_aclk),
    .clk_100M                        (clk_100M),
    .axis_aclk                       (axis_aclk),
    .aresetn                         (powerup_rstn)
  );
  
  qdma_subsystem_qdma_wrapper #(0)  
  qdma_wrapper_arm (
    .pcie_rxp                        (arm_pcie_mgt_0_rxp),
    .pcie_rxn                        (arm_pcie_mgt_0_rxn),
    .pcie_txp                        (arm_pcie_mgt_0_txp),
    .pcie_txn                        (arm_pcie_mgt_0_txn),

    .m_axil_awvalid                  (arm_m_axil_pcie_awvalid),
    .m_axil_awaddr                   (arm_m_axil_pcie_awaddr),
    .m_axil_awready                  (arm_m_axil_pcie_awready),
    .m_axil_wvalid                   (arm_m_axil_pcie_wvalid),
    .m_axil_wdata                    (arm_m_axil_pcie_wdata),
    .m_axil_wready                   (arm_m_axil_pcie_wready),
    .m_axil_bvalid                   (arm_m_axil_pcie_bvalid),
    .m_axil_bresp                    (arm_m_axil_pcie_bresp),
    .m_axil_bready                   (arm_m_axil_pcie_bready),
    .m_axil_arvalid                  (arm_m_axil_pcie_arvalid),
    .m_axil_araddr                   (arm_m_axil_pcie_araddr),
    .m_axil_arready                  (arm_m_axil_pcie_arready),
    .m_axil_rvalid                   (arm_m_axil_pcie_rvalid),
    .m_axil_rdata                    (arm_m_axil_pcie_rdata),
    .m_axil_rresp                    (arm_m_axil_pcie_rresp),
    .m_axil_rready                   (arm_m_axil_pcie_rready),

    .m_axis_h2c_tvalid               (arm_axis_qdma_h2c_tvalid),
    .m_axis_h2c_tdata                (arm_axis_qdma_h2c_tdata),
    .m_axis_h2c_tcrc                 (arm_axis_qdma_h2c_tcrc),
    .m_axis_h2c_tlast                (arm_axis_qdma_h2c_tlast),
    .m_axis_h2c_tuser_qid            (arm_axis_qdma_h2c_tuser_qid),
    .m_axis_h2c_tuser_port_id        (arm_axis_qdma_h2c_tuser_port_id),
    .m_axis_h2c_tuser_err            (arm_axis_qdma_h2c_tuser_err),
    .m_axis_h2c_tuser_mdata          (arm_axis_qdma_h2c_tuser_mdata),
    .m_axis_h2c_tuser_mty            (arm_axis_qdma_h2c_tuser_mty),
    .m_axis_h2c_tuser_zero_byte      (arm_axis_qdma_h2c_tuser_zero_byte),
    .m_axis_h2c_tready               (arm_axis_qdma_h2c_tready),

    .s_axis_c2h_tvalid               (arm_axis_qdma_c2h_tvalid),
    .s_axis_c2h_tdata                (arm_axis_qdma_c2h_tdata),
    .s_axis_c2h_tcrc                 (arm_axis_qdma_c2h_tcrc),
    .s_axis_c2h_tlast                (arm_axis_qdma_c2h_tlast),
    .s_axis_c2h_ctrl_marker          (arm_axis_qdma_c2h_ctrl_marker),
    .s_axis_c2h_ctrl_port_id         (arm_axis_qdma_c2h_ctrl_port_id),
    .s_axis_c2h_ctrl_ecc             (arm_axis_qdma_c2h_ctrl_ecc),
    .s_axis_c2h_ctrl_len             (arm_axis_qdma_c2h_ctrl_len),
    .s_axis_c2h_ctrl_qid             (arm_axis_qdma_c2h_ctrl_qid),
    .s_axis_c2h_ctrl_has_cmpt        (arm_axis_qdma_c2h_ctrl_has_cmpt),
    .s_axis_c2h_mty                  (arm_axis_qdma_c2h_mty),
    .s_axis_c2h_tready               (arm_axis_qdma_c2h_tready),

    .s_axis_cpl_tvalid               (arm_axis_qdma_cpl_tvalid),
    .s_axis_cpl_tdata                (arm_axis_qdma_cpl_tdata),
    .s_axis_cpl_size                 (arm_axis_qdma_cpl_size),
    .s_axis_cpl_dpar                 (arm_axis_qdma_cpl_dpar),
    .s_axis_cpl_ctrl_qid             (arm_axis_qdma_cpl_ctrl_qid),
    .s_axis_cpl_ctrl_cmpt_type       (arm_axis_qdma_cpl_ctrl_cmpt_type),
    .s_axis_cpl_ctrl_wait_pld_pkt_id (arm_axis_qdma_cpl_ctrl_wait_pld_pkt_id),
    .s_axis_cpl_ctrl_port_id         (arm_axis_qdma_cpl_ctrl_port_id),
    .s_axis_cpl_ctrl_marker          (arm_axis_qdma_cpl_ctrl_marker),
    .s_axis_cpl_ctrl_user_trig       (arm_axis_qdma_cpl_ctrl_user_trig),
    .s_axis_cpl_ctrl_col_idx         (arm_axis_qdma_cpl_ctrl_col_idx),
    .s_axis_cpl_ctrl_err_idx         (arm_axis_qdma_cpl_ctrl_err_idx),
    .s_axis_cpl_ctrl_no_wrb_marker   (arm_axis_qdma_cpl_ctrl_no_wrb_marker),
    .s_axis_cpl_tready               (arm_axis_qdma_cpl_tready),

    .h2c_byp_out_vld                 (arm_h2c_byp_out_vld),
    .h2c_byp_out_dsc                 (arm_h2c_byp_out_dsc),
    .h2c_byp_out_st_mm               (arm_h2c_byp_out_st_mm),
    .h2c_byp_out_dsc_sz              (arm_h2c_byp_out_dsc_sz),
    .h2c_byp_out_qid                 (arm_h2c_byp_out_qid),
    .h2c_byp_out_error               (arm_h2c_byp_out_error),
    .h2c_byp_out_func                (arm_h2c_byp_out_func),
    .h2c_byp_out_cidx                (arm_h2c_byp_out_cidx),
    .h2c_byp_out_port_id             (arm_h2c_byp_out_port_id),
    .h2c_byp_out_fmt                 (arm_h2c_byp_out_fmt),
    .h2c_byp_out_rdy                 (arm_h2c_byp_out_rdy),

    .h2c_byp_in_st_vld               (arm_h2c_byp_in_st_vld),
    .h2c_byp_in_st_addr              (arm_h2c_byp_in_st_addr),
    .h2c_byp_in_st_len               (arm_h2c_byp_in_st_len),
    .h2c_byp_in_st_eop               (arm_h2c_byp_in_st_eop),
    .h2c_byp_in_st_sop               (arm_h2c_byp_in_st_sop),
    .h2c_byp_in_st_mrkr_req          (arm_h2c_byp_in_st_mrkr_req),
    .h2c_byp_in_st_port_id           (arm_h2c_byp_in_st_port_id),
    .h2c_byp_in_st_sdi               (arm_h2c_byp_in_st_sdi),
    .h2c_byp_in_st_qid               (arm_h2c_byp_in_st_qid),
    .h2c_byp_in_st_error             (arm_h2c_byp_in_st_error),
    .h2c_byp_in_st_func              (arm_h2c_byp_in_st_func),
    .h2c_byp_in_st_cidx              (arm_h2c_byp_in_st_cidx),
    .h2c_byp_in_st_no_dma            (arm_h2c_byp_in_st_no_dma),
    .h2c_byp_in_st_rdy               (arm_h2c_byp_in_st_rdy),

    .c2h_byp_out_vld                 (arm_c2h_byp_out_vld),
    .c2h_byp_out_dsc                 (arm_c2h_byp_out_dsc),
    .c2h_byp_out_st_mm               (arm_c2h_byp_out_st_mm),
    .c2h_byp_out_qid                 (arm_c2h_byp_out_qid),
    .c2h_byp_out_dsc_sz              (arm_c2h_byp_out_dsc_sz),
    .c2h_byp_out_error               (arm_c2h_byp_out_error),
    .c2h_byp_out_func                (arm_c2h_byp_out_func),
    .c2h_byp_out_cidx                (arm_c2h_byp_out_cidx),
    .c2h_byp_out_port_id             (arm_c2h_byp_out_port_id),
    .c2h_byp_out_fmt                 (arm_c2h_byp_out_fmt),
    .c2h_byp_out_pfch_tag            (arm_c2h_byp_out_pfch_tag),
    .c2h_byp_out_rdy                 (arm_c2h_byp_out_rdy),

    .c2h_byp_in_st_csh_vld           (arm_c2h_byp_in_st_csh_vld),
    .c2h_byp_in_st_csh_addr          (arm_c2h_byp_in_st_csh_addr),
    .c2h_byp_in_st_csh_port_id       (arm_c2h_byp_in_st_csh_port_id),
    .c2h_byp_in_st_csh_qid           (arm_c2h_byp_in_st_csh_qid),
    .c2h_byp_in_st_csh_error         (arm_c2h_byp_in_st_csh_error),
    .c2h_byp_in_st_csh_func          (arm_c2h_byp_in_st_csh_func),
    .c2h_byp_in_st_csh_pfch_tag      (arm_c2h_byp_in_st_csh_pfch_tag),
    .c2h_byp_in_st_csh_rdy           (arm_c2h_byp_in_st_csh_rdy),

    .pcie_refclk                     (arm_pcie_refclk),
    .pcie_refclk_gt                  (arm_pcie_refclk_gt),
    .pcie_rstn                       (arm_pcie_rstn),
    .user_lnk_up                     (arm_user_lnk_up),
    .phy_ready                       (arm_phy_ready),

    .soft_reset_n                    (arm_axil_aresetn),

    .axil_aclk                       (arm_axil_aclk),
    .clk_100M                        (arm_clk_100M),
    .axis_aclk                       (arm_axis_aclk),
    .aresetn                         (arm_powerup_rstn)
  );

`else // !`ifdef __synthesis__
  initial begin
    axil_aclk = 1'b1;
    axis_aclk = 1'b1;
  end

  always #4000ps axil_aclk = ~axil_aclk;
  always #2000ps axis_aclk = ~axis_aclk;
  
  assign axis_qdma_h2c_tvalid                 = s_axis_qdma_h2c_tvalid;
  assign axis_qdma_h2c_tdata                  = s_axis_qdma_h2c_tdata;
  assign axis_qdma_h2c_tcrc                   = s_axis_qdma_h2c_tcrc;
  assign axis_qdma_h2c_tlast                  = s_axis_qdma_h2c_tlast;
  assign axis_qdma_h2c_tuser_qid              = s_axis_qdma_h2c_tuser_qid;
  assign axis_qdma_h2c_tuser_port_id          = s_axis_qdma_h2c_tuser_port_id;
  assign axis_qdma_h2c_tuser_err              = s_axis_qdma_h2c_tuser_err;
  assign axis_qdma_h2c_tuser_mdata            = s_axis_qdma_h2c_tuser_mdata;
  assign axis_qdma_h2c_tuser_mty              = s_axis_qdma_h2c_tuser_mty;
  assign axis_qdma_h2c_tuser_zero_byte        = s_axis_qdma_h2c_tuser_zero_byte;
  assign s_axis_qdma_h2c_tready               = axis_qdma_h2c_tready;

  assign m_axis_qdma_c2h_tvalid               = axis_qdma_c2h_tvalid;
  assign m_axis_qdma_c2h_tdata                = axis_qdma_c2h_tdata;
  assign m_axis_qdma_c2h_tcrc                 = axis_qdma_c2h_tcrc;
  assign m_axis_qdma_c2h_tlast                = axis_qdma_c2h_tlast;
  assign m_axis_qdma_c2h_ctrl_marker          = axis_qdma_c2h_ctrl_marker;
  assign m_axis_qdma_c2h_ctrl_port_id         = axis_qdma_c2h_ctrl_port_id;
  assign m_axis_qdma_c2h_ctrl_ecc             = axis_qdma_c2h_ctrl_ecc;
  assign m_axis_qdma_c2h_ctrl_len             = axis_qdma_c2h_ctrl_len;
  assign m_axis_qdma_c2h_ctrl_qid             = axis_qdma_c2h_ctrl_qid;
  assign m_axis_qdma_c2h_ctrl_has_cmpt        = axis_qdma_c2h_ctrl_has_cmpt;
  assign m_axis_qdma_c2h_mty                  = axis_qdma_c2h_mty;
  assign axis_qdma_c2h_tready                 = m_axis_qdma_c2h_tready;

  assign m_axis_qdma_cpl_tvalid               = axis_qdma_cpl_tvalid;
  assign m_axis_qdma_cpl_tdata                = axis_qdma_cpl_tdata;
  assign m_axis_qdma_cpl_size                 = axis_qdma_cpl_size;
  assign m_axis_qdma_cpl_dpar                 = axis_qdma_cpl_dpar;
  assign m_axis_qdma_cpl_ctrl_qid             = axis_qdma_cpl_ctrl_qid;
  assign m_axis_qdma_cpl_ctrl_cmpt_type       = axis_qdma_cpl_ctrl_cmpt_type;
  assign m_axis_qdma_cpl_ctrl_wait_pld_pkt_id = axis_qdma_cpl_ctrl_wait_pld_pkt_id;
  assign m_axis_qdma_cpl_ctrl_port_id         = axis_qdma_cpl_ctrl_port_id;
  assign m_axis_qdma_cpl_ctrl_marker          = axis_qdma_cpl_ctrl_marker;
  assign m_axis_qdma_cpl_ctrl_user_trig       = axis_qdma_cpl_ctrl_user_trig;
  assign m_axis_qdma_cpl_ctrl_col_idx         = axis_qdma_cpl_ctrl_col_idx;
  assign m_axis_qdma_cpl_ctrl_err_idx         = axis_qdma_cpl_ctrl_err_idx;
  assign m_axis_qdma_cpl_ctrl_no_wrb_marker   = axis_qdma_cpl_ctrl_no_wrb_marker;
  assign axis_qdma_cpl_tready                 = m_axis_qdma_cpl_tready;
`endif

  generate if (USE_PHYS_FUNC == 0) begin
    // Terminate the AXI-lite interface for QDMA subsystem registers
    axi_lite_slave #(
      .REG_ADDR_W (15),
      .REG_PREFIX (16'h0D0A) // for "QDMA"
    ) qdma_reg_inst (
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

      .aresetn        (axil_aresetn),
      .aclk           (axil_aclk)
    );

    // Terminate H2C and C2H interfaces to QDMA IP
    assign axis_qdma_h2c_tready               = 1'b1;

    assign axis_qdma_c2h_tvalid               = 1'b0;
    assign axis_qdma_c2h_tdata                = 0;
    assign axis_qdma_c2h_tcrc                 = 0;
    assign axis_qdma_c2h_tlast                = 1'b0;
    assign axis_qdma_c2h_ctrl_marker          = 1'b0;
    assign axis_qdma_c2h_ctrl_port_id         = 0;
    assign axis_qdma_c2h_ctrl_ecc             = 0;
    assign axis_qdma_c2h_ctrl_len             = 0;
    assign axis_qdma_c2h_ctrl_qid             = 0;
    assign axis_qdma_c2h_ctrl_has_cmpt        = 1'b0;
    assign axis_qdma_c2h_mty                  = 0;

    assign axis_qdma_cpl_tvalid               = 1'b0;
    assign axis_qdma_cpl_tdata                = 0;
    assign axis_qdma_cpl_size                 = 0;
    assign axis_qdma_cpl_dpar                 = 0;
    assign axis_qdma_cpl_ctrl_qid             = 0;
    assign axis_qdma_cpl_ctrl_cmpt_type       = 0;
    assign axis_qdma_cpl_ctrl_wait_pld_pkt_id = 0;
    assign axis_qdma_cpl_ctrl_port_id         = 0;
    assign axis_qdma_cpl_ctrl_marker          = 1'b0;
    assign axis_qdma_cpl_ctrl_user_trig       = 1'b0;
    assign axis_qdma_cpl_ctrl_col_idx         = 0;
    assign axis_qdma_cpl_ctrl_err_idx         = 0;
    assign axis_qdma_cpl_ctrl_no_wrb_marker   = 1'b0;

    // Terminate H2C and C2H interfaces of the shell
    assign m_axis_h2c_tvalid     = 1'b0;
    assign m_axis_h2c_tdata      = 0;
    assign m_axis_h2c_tkeep      = 0;
    assign m_axis_h2c_tlast      = 1'b0;
    assign m_axis_h2c_tuser_size = 0;
    assign m_axis_h2c_tuser_src  = 0;
    assign m_axis_h2c_tuser_dst  = 0;
    assign m_axis_h2c_tuser_user = 0;

    assign s_axis_c2h_tready     = 1'b1;
  end
  else begin
    wire                         axil_awvalid;
    wire                  [31:0] axil_awaddr;
    wire                         axil_awready;
    wire                         axil_wvalid;
    wire                  [31:0] axil_wdata;
    wire                         axil_wready;
    wire                         axil_bvalid;
    wire                   [1:0] axil_bresp;
    wire                         axil_bready;
    wire                         axil_arvalid;
    wire                  [31:0] axil_araddr;
    wire                         axil_arready;
    wire                         axil_rvalid;
    wire                  [31:0] axil_rdata;
    wire                   [1:0] axil_rresp;
    wire                         axil_rready;

    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_awvalid;
    wire  [32*NUM_PHYS_FUNC-1:0] axil_func_awaddr;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_awready;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_wvalid;
    wire  [32*NUM_PHYS_FUNC-1:0] axil_func_wdata;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_wready;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_bvalid;
    wire   [2*NUM_PHYS_FUNC-1:0] axil_func_bresp;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_bready;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_arvalid;
    wire  [32*NUM_PHYS_FUNC-1:0] axil_func_araddr;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_arready;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_rvalid;
    wire  [32*NUM_PHYS_FUNC-1:0] axil_func_rdata;
    wire   [2*NUM_PHYS_FUNC-1:0] axil_func_rresp;
    wire   [1*NUM_PHYS_FUNC-1:0] axil_func_rready;

    wire     [NUM_PHYS_FUNC-1:0] axis_h2c_tvalid;
    wire [512*NUM_PHYS_FUNC-1:0] axis_h2c_tdata;
    wire     [NUM_PHYS_FUNC-1:0] axis_h2c_tlast;
    wire  [16*NUM_PHYS_FUNC-1:0] axis_h2c_tuser_size;
    wire  [11*NUM_PHYS_FUNC-1:0] axis_h2c_tuser_qid;
    wire     [NUM_PHYS_FUNC-1:0] axis_h2c_tready;

    wire                         h2c_status_valid;
    wire                  [15:0] h2c_status_bytes;
    wire                   [1:0] h2c_status_func_id;

    wire     [NUM_PHYS_FUNC-1:0] axis_c2h_tvalid;
    wire [512*NUM_PHYS_FUNC-1:0] axis_c2h_tdata;
    wire     [NUM_PHYS_FUNC-1:0] axis_c2h_tlast;
    wire  [16*NUM_PHYS_FUNC-1:0] axis_c2h_tuser_size;
    wire  [11*NUM_PHYS_FUNC-1:0] axis_c2h_tuser_qid;
    wire     [NUM_PHYS_FUNC-1:0] axis_c2h_tready;

    wire                         c2h_status_valid;
    wire                  [15:0] c2h_status_bytes;
    wire                   [1:0] c2h_status_func_id;

    qdma_subsystem_address_map #(
      .NUM_PHYS_FUNC (NUM_PHYS_FUNC)
    ) address_map_inst (
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

      .m_axil_awvalid      (axil_awvalid),
      .m_axil_awaddr       (axil_awaddr),
      .m_axil_awready      (axil_awready),
      .m_axil_wvalid       (axil_wvalid),
      .m_axil_wdata        (axil_wdata),
      .m_axil_wready       (axil_wready),
      .m_axil_bvalid       (axil_bvalid),
      .m_axil_bresp        (axil_bresp),
      .m_axil_bready       (axil_bready),
      .m_axil_arvalid      (axil_arvalid),
      .m_axil_araddr       (axil_araddr),
      .m_axil_arready      (axil_arready),
      .m_axil_rvalid       (axil_rvalid),
      .m_axil_rdata        (axil_rdata),
      .m_axil_rresp        (axil_rresp),
      .m_axil_rready       (axil_rready),

      .m_axil_func_awvalid (axil_func_awvalid),
      .m_axil_func_awaddr  (axil_func_awaddr),
      .m_axil_func_awready (axil_func_awready),
      .m_axil_func_wvalid  (axil_func_wvalid),
      .m_axil_func_wdata   (axil_func_wdata),
      .m_axil_func_wready  (axil_func_wready),
      .m_axil_func_bvalid  (axil_func_bvalid),
      .m_axil_func_bresp   (axil_func_bresp),
      .m_axil_func_bready  (axil_func_bready),
      .m_axil_func_arvalid (axil_func_arvalid),
      .m_axil_func_araddr  (axil_func_araddr),
      .m_axil_func_arready (axil_func_arready),
      .m_axil_func_rvalid  (axil_func_rvalid),
      .m_axil_func_rdata   (axil_func_rdata),
      .m_axil_func_rresp   (axil_func_rresp),
      .m_axil_func_rready  (axil_func_rready),

      .aclk                (axil_aclk),
      .aresetn             (axil_aresetn)
    );

    qdma_subsystem_register reg_inst (
      .s_axil_awvalid (axil_awvalid),
      .s_axil_awaddr  (axil_awaddr),
      .s_axil_awready (axil_awready),
      .s_axil_wvalid  (axil_wvalid),
      .s_axil_wdata   (axil_wdata),
      .s_axil_wready  (axil_wready),
      .s_axil_bvalid  (axil_bvalid),
      .s_axil_bresp   (axil_bresp),
      .s_axil_bready  (axil_bready),
      .s_axil_arvalid (axil_arvalid),
      .s_axil_araddr  (axil_araddr),
      .s_axil_arready (axil_arready),
      .s_axil_rvalid  (axil_rvalid),
      .s_axil_rdata   (axil_rdata),
      .s_axil_rresp   (axil_rresp),
      .s_axil_rready  (axil_rready),

      .axil_aclk      (axil_aclk),
      .axis_aclk      (axis_aclk),
      .axil_aresetn   (axil_aresetn)
    );

    qdma_subsystem_h2c #(
      .NUM_PHYS_FUNC (NUM_PHYS_FUNC)
    ) h2c_inst (
      .s_axis_qdma_h2c_tvalid          (axis_qdma_h2c_tvalid),
      .s_axis_qdma_h2c_tdata           (axis_qdma_h2c_tdata),
      .s_axis_qdma_h2c_tcrc            (axis_qdma_h2c_tcrc),
      .s_axis_qdma_h2c_tlast           (axis_qdma_h2c_tlast),
      .s_axis_qdma_h2c_tuser_qid       (axis_qdma_h2c_tuser_qid),
      .s_axis_qdma_h2c_tuser_port_id   (axis_qdma_h2c_tuser_port_id),
      .s_axis_qdma_h2c_tuser_err       (axis_qdma_h2c_tuser_err),
      .s_axis_qdma_h2c_tuser_mdata     (axis_qdma_h2c_tuser_mdata),
      .s_axis_qdma_h2c_tuser_mty       (axis_qdma_h2c_tuser_mty),
      .s_axis_qdma_h2c_tuser_zero_byte (axis_qdma_h2c_tuser_zero_byte),
      .s_axis_qdma_h2c_tready          (axis_qdma_h2c_tready),

      .m_axis_h2c_tvalid               (axis_h2c_tvalid),
      .m_axis_h2c_tdata                (axis_h2c_tdata),
      .m_axis_h2c_tlast                (axis_h2c_tlast),
      .m_axis_h2c_tuser_size           (axis_h2c_tuser_size),
      .m_axis_h2c_tuser_qid            (axis_h2c_tuser_qid),
      .m_axis_h2c_tready               (axis_h2c_tready),

      .h2c_status_valid                (h2c_status_valid),
      .h2c_status_bytes                (h2c_status_bytes),
      .h2c_status_func_id              (h2c_status_func_id),

      .axis_aclk                       (axis_aclk),
      .axil_aresetn                    (axil_aresetn)
    );

    qdma_subsystem_c2h #(
      .NUM_PHYS_FUNC (NUM_PHYS_FUNC)
    ) c2h_inst (
      .s_axis_c2h_tvalid                    (axis_c2h_tvalid),
      .s_axis_c2h_tdata                     (axis_c2h_tdata),
      .s_axis_c2h_tlast                     (axis_c2h_tlast),
      .s_axis_c2h_tuser_size                (axis_c2h_tuser_size),
      .s_axis_c2h_tuser_qid                 (axis_c2h_tuser_qid),
      .s_axis_c2h_tready                    (axis_c2h_tready),

      .m_axis_qdma_c2h_tvalid               (axis_qdma_c2h_tvalid),
      .m_axis_qdma_c2h_tdata                (axis_qdma_c2h_tdata),
      .m_axis_qdma_c2h_tcrc                 (axis_qdma_c2h_tcrc),
      .m_axis_qdma_c2h_tlast                (axis_qdma_c2h_tlast),
      .m_axis_qdma_c2h_ctrl_marker          (axis_qdma_c2h_ctrl_marker),
      .m_axis_qdma_c2h_ctrl_port_id         (axis_qdma_c2h_ctrl_port_id),
      .m_axis_qdma_c2h_ctrl_ecc             (axis_qdma_c2h_ctrl_ecc),
      .m_axis_qdma_c2h_ctrl_len             (axis_qdma_c2h_ctrl_len),
      .m_axis_qdma_c2h_ctrl_qid             (axis_qdma_c2h_ctrl_qid),
      .m_axis_qdma_c2h_ctrl_has_cmpt        (axis_qdma_c2h_ctrl_has_cmpt),
      .m_axis_qdma_c2h_mty                  (axis_qdma_c2h_mty),
      .m_axis_qdma_c2h_tready               (axis_qdma_c2h_tready),

      .m_axis_qdma_cpl_tvalid               (axis_qdma_cpl_tvalid),
      .m_axis_qdma_cpl_tdata                (axis_qdma_cpl_tdata),
      .m_axis_qdma_cpl_size                 (axis_qdma_cpl_size),
      .m_axis_qdma_cpl_dpar                 (axis_qdma_cpl_dpar),
      .m_axis_qdma_cpl_ctrl_qid             (axis_qdma_cpl_ctrl_qid),
      .m_axis_qdma_cpl_ctrl_cmpt_type       (axis_qdma_cpl_ctrl_cmpt_type),
      .m_axis_qdma_cpl_ctrl_wait_pld_pkt_id (axis_qdma_cpl_ctrl_wait_pld_pkt_id),
      .m_axis_qdma_cpl_ctrl_port_id         (axis_qdma_cpl_ctrl_port_id),
      .m_axis_qdma_cpl_ctrl_marker          (axis_qdma_cpl_ctrl_marker),
      .m_axis_qdma_cpl_ctrl_user_trig       (axis_qdma_cpl_ctrl_user_trig),
      .m_axis_qdma_cpl_ctrl_col_idx         (axis_qdma_cpl_ctrl_col_idx),
      .m_axis_qdma_cpl_ctrl_err_idx         (axis_qdma_cpl_ctrl_err_idx),
      .m_axis_qdma_cpl_ctrl_no_wrb_marker   (axis_qdma_cpl_ctrl_no_wrb_marker),
      .m_axis_qdma_cpl_tready               (axis_qdma_cpl_tready),

      .c2h_status_valid                     (c2h_status_valid),
      .c2h_status_bytes                     (c2h_status_bytes),
      .c2h_status_func_id                   (c2h_status_func_id),

      .axis_aclk                            (axis_aclk),
      .axil_aresetn                         (axil_aresetn)
    );

    for (genvar i = 0; i < NUM_PHYS_FUNC; i++) begin
      qdma_subsystem_function #(
        .FUNC_ID     (i),
        .MAX_PKT_LEN (MAX_PKT_LEN),
        .MIN_PKT_LEN (MIN_PKT_LEN)
      ) func_inst (
        .s_axil_awvalid        (axil_func_awvalid[i]),
        .s_axil_awaddr         (axil_func_awaddr[`getvec(32, i)]),
        .s_axil_awready        (axil_func_awready[i]),
        .s_axil_wvalid         (axil_func_wvalid[i]),
        .s_axil_wdata          (axil_func_wdata[`getvec(32, i)]),
        .s_axil_wready         (axil_func_wready[i]),
        .s_axil_bvalid         (axil_func_bvalid[i]),
        .s_axil_bresp          (axil_func_bresp[`getvec(2, i)]),
        .s_axil_bready         (axil_func_bready[i]),
        .s_axil_arvalid        (axil_func_arvalid[i]),
        .s_axil_araddr         (axil_func_araddr[`getvec(32, i)]),
        .s_axil_arready        (axil_func_arready[i]),
        .s_axil_rvalid         (axil_func_rvalid[i]),
        .s_axil_rdata          (axil_func_rdata[`getvec(32, i)]),
        .s_axil_rresp          (axil_func_rresp[`getvec(2, i)]),
        .s_axil_rready         (axil_func_rready[i]),

        .s_axis_h2c_tvalid     (axis_h2c_tvalid[i]),
        .s_axis_h2c_tdata      (axis_h2c_tdata[`getvec(512, i)]),
        .s_axis_h2c_tlast      (axis_h2c_tlast[i]),
        .s_axis_h2c_tuser_size (axis_h2c_tuser_size[`getvec(16, i)]),
        .s_axis_h2c_tuser_qid  (axis_h2c_tuser_qid[`getvec(11, i)]),
        .s_axis_h2c_tready     (axis_h2c_tready[i]),

        .m_axis_h2c_tvalid     (m_axis_h2c_tvalid[i]),
        .m_axis_h2c_tdata      (m_axis_h2c_tdata[`getvec(512, i)]),
        .m_axis_h2c_tkeep      (m_axis_h2c_tkeep[`getvec(64, i)]),
        .m_axis_h2c_tlast      (m_axis_h2c_tlast[i]),
        .m_axis_h2c_tuser_size (m_axis_h2c_tuser_size[`getvec(16, i)]),
        .m_axis_h2c_tuser_src  (m_axis_h2c_tuser_src[`getvec(16, i)]),
        .m_axis_h2c_tuser_dst  (m_axis_h2c_tuser_dst[`getvec(16, i)]),
        .m_axis_h2c_tready     (m_axis_h2c_tready[i]),

        .s_axis_c2h_tvalid     (s_axis_c2h_tvalid[i]),
        .s_axis_c2h_tdata      (s_axis_c2h_tdata[`getvec(512, i)]),
        .s_axis_c2h_tkeep      (s_axis_c2h_tkeep[`getvec(64, i)]),
        .s_axis_c2h_tlast      (s_axis_c2h_tlast[i]),
        .s_axis_c2h_tuser_size (s_axis_c2h_tuser_size[`getvec(16, i)]),
        .s_axis_c2h_tuser_src  (s_axis_c2h_tuser_src[`getvec(16, i)]),
        .s_axis_c2h_tuser_dst  (s_axis_c2h_tuser_dst[`getvec(16, i)]),
        .s_axis_c2h_tready     (s_axis_c2h_tready[i]),

        .m_axis_c2h_tvalid     (axis_c2h_tvalid[i]),
        .m_axis_c2h_tdata      (axis_c2h_tdata[`getvec(512, i)]),
        .m_axis_c2h_tlast      (axis_c2h_tlast[i]),
        .m_axis_c2h_tuser_size (axis_c2h_tuser_size[`getvec(16, i)]),
        .m_axis_c2h_tuser_qid  (axis_c2h_tuser_qid[`getvec(11, i)]),
        .m_axis_c2h_tready     (axis_c2h_tready[i]),

        .axil_aclk             (axil_aclk),
        .axis_aclk             (axis_aclk),
        .axil_aresetn          (axil_aresetn)
      );
    end
  end
  endgenerate

endmodule: qdma_subsystem
