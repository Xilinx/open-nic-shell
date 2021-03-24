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
// CMAC subsystem address map
//
// System-level address range: 
//   - 0x08000 - 0x0AFFF (CMAC-0)
//   - 0x0C000 - 0x0EFFF (CMAC-1)
//
// --------------------------------------------------
//   BaseAddr |  HighAddr |  Module
// --------------------------------------------------
//    0x0000  |   0x1FFF  |  CMAC IP block
// --------------------------------------------------
//    0x2000  |   0x2FFF  |  QSFP28 I2C
// --------------------------------------------------
`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module cmac_subsystem_address_map (
  input         s_axil_awvalid,
  input  [31:0] s_axil_awaddr,
  output        s_axil_awready,
  input         s_axil_wvalid,
  input  [31:0] s_axil_wdata,
  output        s_axil_wready,
  output        s_axil_bvalid,
  output  [1:0] s_axil_bresp,
  input         s_axil_bready,
  input         s_axil_arvalid,
  input  [31:0] s_axil_araddr,
  output        s_axil_arready,
  output        s_axil_rvalid,
  output [31:0] s_axil_rdata,
  output  [1:0] s_axil_rresp,
  input         s_axil_rready,

  output        m_axil_cmac_awvalid,
  output [31:0] m_axil_cmac_awaddr,
  input         m_axil_cmac_awready,
  output        m_axil_cmac_wvalid,
  output [31:0] m_axil_cmac_wdata,
  input         m_axil_cmac_wready,
  input         m_axil_cmac_bvalid,
  input   [1:0] m_axil_cmac_bresp,
  output        m_axil_cmac_bready,
  output        m_axil_cmac_arvalid,
  output [31:0] m_axil_cmac_araddr,
  input         m_axil_cmac_arready,
  input         m_axil_cmac_rvalid,
  input  [31:0] m_axil_cmac_rdata,
  input   [1:0] m_axil_cmac_rresp,
  output        m_axil_cmac_rready,

  output        m_axil_qsfp_awvalid,
  output [31:0] m_axil_qsfp_awaddr,
  input         m_axil_qsfp_awready,
  output        m_axil_qsfp_wvalid,
  output [31:0] m_axil_qsfp_wdata,
  input         m_axil_qsfp_wready,
  input         m_axil_qsfp_bvalid,
  input   [1:0] m_axil_qsfp_bresp,
  output        m_axil_qsfp_bready,
  output        m_axil_qsfp_arvalid,
  output [31:0] m_axil_qsfp_araddr,
  input         m_axil_qsfp_arready,
  input         m_axil_qsfp_rvalid,
  input  [31:0] m_axil_qsfp_rdata,
  input   [1:0] m_axil_qsfp_rresp,
  output        m_axil_qsfp_rready,

  input         aclk,
  input         aresetn
);

  localparam C_NUM_SLAVES = 2;

  localparam C_CMAC_INDEX = 0;
  localparam C_QSFP_INDEX = 1;

  localparam C_CMAC_BASE_ADDR = 32'h0;
  localparam C_QSFP_BASE_ADDR = 32'h2000;

  wire                [31:0] axil_cmac_awaddr;
  wire                [31:0] axil_cmac_araddr;
  wire                [31:0] axil_qsfp_awaddr;
  wire                [31:0] axil_qsfp_araddr;

  wire  [1*C_NUM_SLAVES-1:0] axil_awvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_awaddr;
  wire  [1*C_NUM_SLAVES-1:0] axil_awready;
  wire  [1*C_NUM_SLAVES-1:0] axil_wvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_wdata;
  wire  [1*C_NUM_SLAVES-1:0] axil_wready;
  wire  [1*C_NUM_SLAVES-1:0] axil_bvalid;
  wire  [2*C_NUM_SLAVES-1:0] axil_bresp;
  wire  [1*C_NUM_SLAVES-1:0] axil_bready;
  wire  [1*C_NUM_SLAVES-1:0] axil_arvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_araddr;
  wire  [1*C_NUM_SLAVES-1:0] axil_arready;
  wire  [1*C_NUM_SLAVES-1:0] axil_rvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_rdata;
  wire  [2*C_NUM_SLAVES-1:0] axil_rresp;
  wire  [1*C_NUM_SLAVES-1:0] axil_rready;

  // Adjust AXI-Lite address so that each slave can assume a base address of 0x0
  assign axil_cmac_awaddr                      = axil_awaddr[`getvec(32, C_CMAC_INDEX)] - C_CMAC_BASE_ADDR;
  assign axil_cmac_araddr                      = axil_araddr[`getvec(32, C_CMAC_INDEX)] - C_CMAC_BASE_ADDR;
  assign axil_qsfp_awaddr                      = axil_awaddr[`getvec(32, C_QSFP_INDEX)] - C_QSFP_BASE_ADDR;
  assign axil_qsfp_araddr                      = axil_araddr[`getvec(32, C_QSFP_INDEX)] - C_QSFP_BASE_ADDR;

  assign m_axil_cmac_awvalid                   = axil_awvalid[C_CMAC_INDEX];
  assign m_axil_cmac_awaddr                    = axil_cmac_awaddr;
  assign axil_awready[C_CMAC_INDEX]            = m_axil_cmac_awready;
  assign m_axil_cmac_wvalid                    = axil_wvalid[C_CMAC_INDEX];
  assign m_axil_cmac_wdata                     = axil_wdata[`getvec(32, C_CMAC_INDEX)];
  assign axil_wready[C_CMAC_INDEX]             = m_axil_cmac_wready;
  assign axil_bvalid[C_CMAC_INDEX]             = m_axil_cmac_bvalid;
  assign axil_bresp[`getvec(2, C_CMAC_INDEX)]  = m_axil_cmac_bresp;
  assign m_axil_cmac_bready                    = axil_bready[C_CMAC_INDEX];
  assign m_axil_cmac_arvalid                   = axil_arvalid[C_CMAC_INDEX];
  assign m_axil_cmac_araddr                    = axil_cmac_araddr;
  assign axil_arready[C_CMAC_INDEX]            = m_axil_cmac_arready;
  assign axil_rvalid[C_CMAC_INDEX]             = m_axil_cmac_rvalid;
  assign axil_rdata[`getvec(32, C_CMAC_INDEX)] = m_axil_cmac_rdata;
  assign axil_rresp[`getvec(2, C_CMAC_INDEX)]  = m_axil_cmac_rresp;
  assign m_axil_cmac_rready                    = axil_rready[C_CMAC_INDEX];

  assign m_axil_qsfp_awvalid                   = axil_awvalid[C_QSFP_INDEX];
  assign m_axil_qsfp_awaddr                    = axil_qsfp_awaddr;
  assign axil_awready[C_QSFP_INDEX]            = m_axil_qsfp_awready;
  assign m_axil_qsfp_wvalid                    = axil_wvalid[C_QSFP_INDEX];
  assign m_axil_qsfp_wdata                     = axil_wdata[`getvec(32, C_QSFP_INDEX)];
  assign axil_wready[C_QSFP_INDEX]             = m_axil_qsfp_wready;
  assign axil_bvalid[C_QSFP_INDEX]             = m_axil_qsfp_bvalid;
  assign axil_bresp[`getvec(2, C_QSFP_INDEX)]  = m_axil_qsfp_bresp;
  assign m_axil_qsfp_bready                    = axil_bready[C_QSFP_INDEX];
  assign m_axil_qsfp_arvalid                   = axil_arvalid[C_QSFP_INDEX];
  assign m_axil_qsfp_araddr                    = axil_qsfp_araddr;
  assign axil_arready[C_QSFP_INDEX]            = m_axil_qsfp_arready;
  assign axil_rvalid[C_QSFP_INDEX]             = m_axil_qsfp_rvalid;
  assign axil_rdata[`getvec(32, C_QSFP_INDEX)] = m_axil_qsfp_rdata;
  assign axil_rresp[`getvec(2, C_QSFP_INDEX)]  = m_axil_qsfp_rresp;
  assign m_axil_qsfp_rready                    = axil_rready[C_QSFP_INDEX];

  cmac_subsystem_axi_crossbar xbar_inst (
    .s_axi_awaddr  (s_axil_awaddr),
    .s_axi_awprot  (0),
    .s_axi_awvalid (s_axil_awvalid),
    .s_axi_awready (s_axil_awready),
    .s_axi_wdata   (s_axil_wdata),
    .s_axi_wstrb   (4'hF),
    .s_axi_wvalid  (s_axil_wvalid),
    .s_axi_wready  (s_axil_wready),
    .s_axi_bresp   (s_axil_bresp),
    .s_axi_bvalid  (s_axil_bvalid),
    .s_axi_bready  (s_axil_bready),
    .s_axi_araddr  (s_axil_araddr),
    .s_axi_arprot  (0),
    .s_axi_arvalid (s_axil_arvalid),
    .s_axi_arready (s_axil_arready),
    .s_axi_rdata   (s_axil_rdata),
    .s_axi_rresp   (s_axil_rresp),
    .s_axi_rvalid  (s_axil_rvalid),
    .s_axi_rready  (s_axil_rready),

    .m_axi_awaddr  (axil_awaddr),
    .m_axi_awprot  (),
    .m_axi_awvalid (axil_awvalid),
    .m_axi_awready (axil_awready),
    .m_axi_wdata   (axil_wdata),
    .m_axi_wstrb   (),
    .m_axi_wvalid  (axil_wvalid),
    .m_axi_wready  (axil_wready),
    .m_axi_bresp   (axil_bresp),
    .m_axi_bvalid  (axil_bvalid),
    .m_axi_bready  (axil_bready),
    .m_axi_araddr  (axil_araddr),
    .m_axi_arprot  (),
    .m_axi_arvalid (axil_arvalid),
    .m_axi_arready (axil_arready),
    .m_axi_rdata   (axil_rdata),
    .m_axi_rresp   (axil_rresp),
    .m_axi_rvalid  (axil_rvalid),
    .m_axi_rready  (axil_rready),

    .aclk          (aclk),
    .aresetn       (aresetn)
  );

endmodule: cmac_subsystem_address_map
