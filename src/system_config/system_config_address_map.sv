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
// System address map (through PCI-e BAR2 1MB)
//
// --------------------------------------------------
//   BaseAddr |  HighAddr |  Module
// --------------------------------------------------
//   0x00000  |  0x00FFF  |  System configuration
// --------------------------------------------------
//   0x01000  |  0x05FFF  |  QDMA subsystem
// --------------------------------------------------
//   0x08000  |  0x0AFFF  |  CMAC subsystem #0
// --------------------------------------------------
//   0x0B000  |  0x0BFFF  |  Packet adapter #0
// --------------------------------------------------
//   0x0C000  |  0x0EFFF  |  CMAC subsystem #1
// --------------------------------------------------
//   0x0F000  |  0x0FFFF  |  Packet adapter #1
// --------------------------------------------------
//   0x10000  |  0x3FFFF  |  Box1 @ 322MHz
// --------------------------------------------------
//   0x40000  |  0xFFFFF  |  Box0 @ 250MHz
// --------------------------------------------------
`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module system_config_address_map #(
  parameter int NUM_CMAC_PORT = 1
) (
  input                         s_axil_awvalid,
  input                  [31:0] s_axil_awaddr,
  output                        s_axil_awready,
  input                         s_axil_wvalid,
  input                  [31:0] s_axil_wdata,
  output                        s_axil_wready,
  output                        s_axil_bvalid,
  output                  [1:0] s_axil_bresp,
  input                         s_axil_bready,
  input                         s_axil_arvalid,
  input                  [31:0] s_axil_araddr,
  output                        s_axil_arready,
  output                        s_axil_rvalid,
  output                 [31:0] s_axil_rdata,
  output                  [1:0] s_axil_rresp,
  input                         s_axil_rready,

  output                        m_axil_scfg_awvalid,
  output                 [31:0] m_axil_scfg_awaddr,
  input                         m_axil_scfg_awready,
  output                        m_axil_scfg_wvalid,
  output                 [31:0] m_axil_scfg_wdata,
  input                         m_axil_scfg_wready,
  input                         m_axil_scfg_bvalid,
  input                   [1:0] m_axil_scfg_bresp,
  output                        m_axil_scfg_bready,
  output                        m_axil_scfg_arvalid,
  output                 [31:0] m_axil_scfg_araddr,
  input                         m_axil_scfg_arready,
  input                         m_axil_scfg_rvalid,
  input                  [31:0] m_axil_scfg_rdata,
  input                   [1:0] m_axil_scfg_rresp,
  output                        m_axil_scfg_rready,

  output                        m_axil_qdma_awvalid,
  output                 [31:0] m_axil_qdma_awaddr,
  input                         m_axil_qdma_awready,
  output                        m_axil_qdma_wvalid,
  output                 [31:0] m_axil_qdma_wdata,
  input                         m_axil_qdma_wready,
  input                         m_axil_qdma_bvalid,
  input                   [1:0] m_axil_qdma_bresp,
  output                        m_axil_qdma_bready,
  output                        m_axil_qdma_arvalid,
  output                 [31:0] m_axil_qdma_araddr,
  input                         m_axil_qdma_arready,
  input                         m_axil_qdma_rvalid,
  input                  [31:0] m_axil_qdma_rdata,
  input                   [1:0] m_axil_qdma_rresp,
  output                        m_axil_qdma_rready,

  output    [NUM_CMAC_PORT-1:0] m_axil_adap_awvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_awaddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_awready,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_wvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_wdata,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_wready,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_bvalid,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_adap_bresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_bready,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_arvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_araddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_arready,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_rvalid,
  input  [32*NUM_CMAC_PORT-1:0] m_axil_adap_rdata,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_adap_rresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_rready,

  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_awvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_awaddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_awready,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_wvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_wdata,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_wready,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_bvalid,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_cmac_bresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_bready,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_arvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_araddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_arready,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_rvalid,
  input  [32*NUM_CMAC_PORT-1:0] m_axil_cmac_rdata,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_cmac_rresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_rready,

  output                        m_axil_box0_awvalid,
  output                 [31:0] m_axil_box0_awaddr,
  input                         m_axil_box0_awready,
  output                        m_axil_box0_wvalid,
  output                 [31:0] m_axil_box0_wdata,
  input                         m_axil_box0_wready,
  input                         m_axil_box0_bvalid,
  input                   [1:0] m_axil_box0_bresp,
  output                        m_axil_box0_bready,
  output                        m_axil_box0_arvalid,
  output                 [31:0] m_axil_box0_araddr,
  input                         m_axil_box0_arready,
  input                         m_axil_box0_rvalid,
  input                  [31:0] m_axil_box0_rdata,
  input                   [1:0] m_axil_box0_rresp,
  output                        m_axil_box0_rready,

  output                        m_axil_box1_awvalid,
  output                 [31:0] m_axil_box1_awaddr,
  input                         m_axil_box1_awready,
  output                        m_axil_box1_wvalid,
  output                 [31:0] m_axil_box1_wdata,
  input                         m_axil_box1_wready,
  input                         m_axil_box1_bvalid,
  input                   [1:0] m_axil_box1_bresp,
  output                        m_axil_box1_bready,
  output                        m_axil_box1_arvalid,
  output                 [31:0] m_axil_box1_araddr,
  input                         m_axil_box1_arready,
  input                         m_axil_box1_rvalid,
  input                  [31:0] m_axil_box1_rdata,
  input                   [1:0] m_axil_box1_rresp,
  output                        m_axil_box1_rready,

  input                         aclk,
  input                         aresetn
);

  localparam C_NUM_SLAVES  = 8;

  localparam C_SCFG_INDEX  = 0;
  localparam C_QDMA_INDEX  = 1;
  localparam C_CMAC0_INDEX = 2;
  localparam C_ADAP0_INDEX = 3;
  localparam C_CMAC1_INDEX = 4;
  localparam C_ADAP1_INDEX = 5;
  localparam C_BOX1_INDEX  = 6;
  localparam C_BOX0_INDEX  = 7;

  localparam C_SCFG_BASE_ADDR  = 32'h0;
  localparam C_QDMA_BASE_ADDR  = 32'h01000;
  localparam C_CMAC0_BASE_ADDR = 32'h08000;
  localparam C_ADAP0_BASE_ADDR = 32'h0B000;
  localparam C_CMAC1_BASE_ADDR = 32'h0C000;
  localparam C_ADAP1_BASE_ADDR = 32'h0F000;
  localparam C_BOX1_BASE_ADDR  = 32'h10000;
  localparam C_BOX0_BASE_ADDR  = 32'h40000;

  wire                [31:0] axil_scfg_awaddr;
  wire                [31:0] axil_scfg_araddr;
  wire                [31:0] axil_qdma_awaddr;
  wire                [31:0] axil_qdma_araddr;
  wire                [31:0] axil_cmac0_awaddr;
  wire                [31:0] axil_cmac0_araddr;
  wire                [31:0] axil_adap0_awaddr;
  wire                [31:0] axil_adap0_araddr;
  wire                [31:0] axil_cmac1_awaddr;
  wire                [31:0] axil_cmac1_araddr;
  wire                [31:0] axil_adap1_awaddr;
  wire                [31:0] axil_adap1_araddr;
  wire                [31:0] axil_box1_awaddr;
  wire                [31:0] axil_box1_araddr;
  wire                [31:0] axil_box0_awaddr;
  wire                [31:0] axil_box0_araddr;

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
  assign axil_scfg_awaddr                      = axil_awaddr[`getvec(32, C_SCFG_INDEX)] - C_SCFG_BASE_ADDR;
  assign axil_scfg_araddr                      = axil_araddr[`getvec(32, C_SCFG_INDEX)] - C_SCFG_BASE_ADDR;
  assign axil_qdma_awaddr                      = axil_awaddr[`getvec(32, C_QDMA_INDEX)] - C_QDMA_BASE_ADDR;
  assign axil_qdma_araddr                      = axil_araddr[`getvec(32, C_QDMA_INDEX)] - C_QDMA_BASE_ADDR;
  assign axil_cmac0_awaddr                     = axil_awaddr[`getvec(32, C_CMAC0_INDEX)] - C_CMAC0_BASE_ADDR;
  assign axil_cmac0_araddr                     = axil_araddr[`getvec(32, C_CMAC0_INDEX)] - C_CMAC0_BASE_ADDR;
  assign axil_adap0_awaddr                     = axil_awaddr[`getvec(32, C_ADAP0_INDEX)] - C_ADAP0_BASE_ADDR;
  assign axil_adap0_araddr                     = axil_araddr[`getvec(32, C_ADAP0_INDEX)] - C_ADAP0_BASE_ADDR;
  assign axil_cmac1_awaddr                     = axil_awaddr[`getvec(32, C_CMAC1_INDEX)] - C_CMAC1_BASE_ADDR;
  assign axil_cmac1_araddr                     = axil_araddr[`getvec(32, C_CMAC1_INDEX)] - C_CMAC1_BASE_ADDR;
  assign axil_adap1_awaddr                     = axil_awaddr[`getvec(32, C_ADAP1_INDEX)] - C_ADAP1_BASE_ADDR;
  assign axil_adap1_araddr                     = axil_araddr[`getvec(32, C_ADAP1_INDEX)] - C_ADAP1_BASE_ADDR;
  assign axil_box1_awaddr                      = axil_awaddr[`getvec(32, C_BOX1_INDEX)] - C_BOX1_BASE_ADDR;
  assign axil_box1_araddr                      = axil_araddr[`getvec(32, C_BOX1_INDEX)] - C_BOX1_BASE_ADDR;
  assign axil_box0_awaddr                      = axil_awaddr[`getvec(32, C_BOX0_INDEX)] - C_BOX0_BASE_ADDR;
  assign axil_box0_araddr                      = axil_araddr[`getvec(32, C_BOX0_INDEX)] - C_BOX0_BASE_ADDR;

  assign m_axil_scfg_awvalid                   = axil_awvalid[C_SCFG_INDEX];
  assign m_axil_scfg_awaddr                    = axil_scfg_awaddr;
  assign axil_awready[C_SCFG_INDEX]            = m_axil_scfg_awready;
  assign m_axil_scfg_wvalid                    = axil_wvalid[C_SCFG_INDEX];
  assign m_axil_scfg_wdata                     = axil_wdata[`getvec(32, C_SCFG_INDEX)];
  assign axil_wready[C_SCFG_INDEX]             = m_axil_scfg_wready;
  assign axil_bvalid[C_SCFG_INDEX]             = m_axil_scfg_bvalid;
  assign axil_bresp[`getvec(2, C_SCFG_INDEX)]  = m_axil_scfg_bresp;
  assign m_axil_scfg_bready                    = axil_bready[C_SCFG_INDEX];
  assign m_axil_scfg_arvalid                   = axil_arvalid[C_SCFG_INDEX];
  assign m_axil_scfg_araddr                    = axil_scfg_araddr;
  assign axil_arready[C_SCFG_INDEX]            = m_axil_scfg_arready;
  assign axil_rvalid[C_SCFG_INDEX]             = m_axil_scfg_rvalid;
  assign axil_rdata[`getvec(32, C_SCFG_INDEX)] = m_axil_scfg_rdata;
  assign axil_rresp[`getvec(2, C_SCFG_INDEX)]  = m_axil_scfg_rresp;
  assign m_axil_scfg_rready                    = axil_rready[C_SCFG_INDEX];

  assign m_axil_qdma_awvalid                   = axil_awvalid[C_QDMA_INDEX];
  assign m_axil_qdma_awaddr                    = axil_qdma_awaddr;
  assign axil_awready[C_QDMA_INDEX]            = m_axil_qdma_awready;
  assign m_axil_qdma_wvalid                    = axil_wvalid[C_QDMA_INDEX];
  assign m_axil_qdma_wdata                     = axil_wdata[`getvec(32, C_QDMA_INDEX)];
  assign axil_wready[C_QDMA_INDEX]             = m_axil_qdma_wready;
  assign axil_bvalid[C_QDMA_INDEX]             = m_axil_qdma_bvalid;
  assign axil_bresp[`getvec(2, C_QDMA_INDEX)]  = m_axil_qdma_bresp;
  assign m_axil_qdma_bready                    = axil_bready[C_QDMA_INDEX];
  assign m_axil_qdma_arvalid                   = axil_arvalid[C_QDMA_INDEX];
  assign m_axil_qdma_araddr                    = axil_qdma_araddr;
  assign axil_arready[C_QDMA_INDEX]            = m_axil_qdma_arready;
  assign axil_rvalid[C_QDMA_INDEX]             = m_axil_qdma_rvalid;
  assign axil_rdata[`getvec(32, C_QDMA_INDEX)] = m_axil_qdma_rdata;
  assign axil_rresp[`getvec(2, C_QDMA_INDEX)]  = m_axil_qdma_rresp;
  assign m_axil_qdma_rready                    = axil_rready[C_QDMA_INDEX];

  if (NUM_CMAC_PORT == 1) begin
    assign m_axil_cmac_awvalid                    = axil_awvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_awaddr                     = axil_cmac0_awaddr;
    assign axil_awready[C_CMAC0_INDEX]            = m_axil_cmac_awready;
    assign m_axil_cmac_wvalid                     = axil_wvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_wdata                      = axil_wdata[`getvec(32, C_CMAC0_INDEX)];
    assign axil_wready[C_CMAC0_INDEX]             = m_axil_cmac_wready;
    assign axil_bvalid[C_CMAC0_INDEX]             = m_axil_cmac_bvalid;
    assign axil_bresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_bresp;
    assign m_axil_cmac_bready                     = axil_bready[C_CMAC0_INDEX];
    assign m_axil_cmac_arvalid                    = axil_arvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_araddr                     = axil_cmac0_araddr;
    assign axil_arready[C_CMAC0_INDEX]            = m_axil_cmac_arready;
    assign axil_rvalid[C_CMAC0_INDEX]             = m_axil_cmac_rvalid;
    assign axil_rdata[`getvec(32, C_CMAC0_INDEX)] = m_axil_cmac_rdata;
    assign axil_rresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_rresp;
    assign m_axil_cmac_rready                     = axil_rready[C_CMAC0_INDEX];

    assign m_axil_adap_awvalid                    = axil_awvalid[C_ADAP0_INDEX];
    assign m_axil_adap_awaddr                     = axil_adap0_awaddr;
    assign axil_awready[C_ADAP0_INDEX]            = m_axil_adap_awready;
    assign m_axil_adap_wvalid                     = axil_wvalid[C_ADAP0_INDEX];
    assign m_axil_adap_wdata                      = axil_wdata[`getvec(32, C_ADAP0_INDEX)];
    assign axil_wready[C_ADAP0_INDEX]             = m_axil_adap_wready;
    assign axil_bvalid[C_ADAP0_INDEX]             = m_axil_adap_bvalid;
    assign axil_bresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_bresp;
    assign m_axil_adap_bready                     = axil_bready[C_ADAP0_INDEX];
    assign m_axil_adap_arvalid                    = axil_arvalid[C_ADAP0_INDEX];
    assign m_axil_adap_araddr                     = axil_adap0_araddr;
    assign axil_arready[C_ADAP0_INDEX]            = m_axil_adap_arready;
    assign axil_rvalid[C_ADAP0_INDEX]             = m_axil_adap_rvalid;
    assign axil_rdata[`getvec(32, C_ADAP0_INDEX)] = m_axil_adap_rdata;
    assign axil_rresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_rresp;
    assign m_axil_adap_rready                     = axil_rready[C_ADAP0_INDEX];

    // Sink for unused CMAC1 register path
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC100)
    ) cmac1_reg_inst (
      .s_axil_awvalid (axil_awvalid[C_CMAC1_INDEX]),
      .s_axil_awaddr  (axil_cmac1_awaddr),
      .s_axil_awready (axil_awready[C_CMAC1_INDEX]),
      .s_axil_wvalid  (axil_wvalid[C_CMAC1_INDEX]),
      .s_axil_wdata   (axil_wdata[`getvec(32, C_CMAC1_INDEX)]),
      .s_axil_wready  (axil_wready[C_CMAC1_INDEX]),
      .s_axil_bvalid  (axil_bvalid[C_CMAC1_INDEX]),
      .s_axil_bresp   (axil_bresp[`getvec(2, C_CMAC1_INDEX)]),
      .s_axil_bready  (axil_bready[C_CMAC1_INDEX]),
      .s_axil_arvalid (axil_arvalid[C_CMAC1_INDEX]),
      .s_axil_araddr  (axil_cmac1_araddr),
      .s_axil_arready (axil_arready[C_CMAC1_INDEX]),
      .s_axil_rvalid  (axil_rvalid[C_CMAC1_INDEX]),
      .s_axil_rdata   (axil_rdata[`getvec(32, C_CMAC1_INDEX)]),
      .s_axil_rresp   (axil_rresp[`getvec(2, C_CMAC1_INDEX)]),
      .s_axil_rready  (axil_rready[C_CMAC1_INDEX]),

      .aresetn        (aresetn),
      .aclk           (aclk)
    );

    // Sink for unused ADAP1 register path
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC100)
    ) adap1_reg_inst (
      .s_axil_awvalid (axil_awvalid[C_ADAP1_INDEX]),
      .s_axil_awaddr  (axil_adap1_awaddr),
      .s_axil_awready (axil_awready[C_ADAP1_INDEX]),
      .s_axil_wvalid  (axil_wvalid[C_ADAP1_INDEX]),
      .s_axil_wdata   (axil_wdata[`getvec(32, C_ADAP1_INDEX)]),
      .s_axil_wready  (axil_wready[C_ADAP1_INDEX]),
      .s_axil_bvalid  (axil_bvalid[C_ADAP1_INDEX]),
      .s_axil_bresp   (axil_bresp[`getvec(2, C_ADAP1_INDEX)]),
      .s_axil_bready  (axil_bready[C_ADAP1_INDEX]),
      .s_axil_arvalid (axil_arvalid[C_ADAP1_INDEX]),
      .s_axil_araddr  (axil_adap1_araddr),
      .s_axil_arready (axil_arready[C_ADAP1_INDEX]),
      .s_axil_rvalid  (axil_rvalid[C_ADAP1_INDEX]),
      .s_axil_rdata   (axil_rdata[`getvec(32, C_ADAP1_INDEX)]),
      .s_axil_rresp   (axil_rresp[`getvec(2, C_ADAP1_INDEX)]),
      .s_axil_rready  (axil_rready[C_ADAP1_INDEX]),

      .aresetn        (aresetn),
      .aclk           (aclk)
    );
  end
  else begin
    assign m_axil_cmac_awvalid[0]                 = axil_awvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_awaddr[`getvec(32, 0)]     = axil_cmac0_awaddr;
    assign axil_awready[C_CMAC0_INDEX]            = m_axil_cmac_awready[0];
    assign m_axil_cmac_wvalid[0]                  = axil_wvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_wdata[`getvec(32, 0)]      = axil_wdata[`getvec(32, C_CMAC0_INDEX)];
    assign axil_wready[C_CMAC0_INDEX]             = m_axil_cmac_wready[0];
    assign axil_bvalid[C_CMAC0_INDEX]             = m_axil_cmac_bvalid[0];
    assign axil_bresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_bresp[`getvec(2, 0)];
    assign m_axil_cmac_bready[0]                  = axil_bready[C_CMAC0_INDEX];
    assign m_axil_cmac_arvalid[0]                 = axil_arvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_araddr[`getvec(32, 0)]     = axil_cmac0_araddr;
    assign axil_arready[C_CMAC0_INDEX]            = m_axil_cmac_arready[0];
    assign axil_rvalid[C_CMAC0_INDEX]             = m_axil_cmac_rvalid[0];
    assign axil_rdata[`getvec(32, C_CMAC0_INDEX)] = m_axil_cmac_rdata[`getvec(32, 0)];
    assign axil_rresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_rresp[`getvec(2, 0)];
    assign m_axil_cmac_rready[0]                  = axil_rready[C_CMAC0_INDEX];

    assign m_axil_adap_awvalid[0]                 = axil_awvalid[C_ADAP0_INDEX];
    assign m_axil_adap_awaddr[`getvec(32, 0)]     = axil_adap0_awaddr;
    assign axil_awready[C_ADAP0_INDEX]            = m_axil_adap_awready[0];
    assign m_axil_adap_wvalid[0]                  = axil_wvalid[C_ADAP0_INDEX];
    assign m_axil_adap_wdata[`getvec(32, 0)]      = axil_wdata[`getvec(32, C_ADAP0_INDEX)];
    assign axil_wready[C_ADAP0_INDEX]             = m_axil_adap_wready[0];
    assign axil_bvalid[C_ADAP0_INDEX]             = m_axil_adap_bvalid[0];
    assign axil_bresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_bresp[`getvec(2, 0)];
    assign m_axil_adap_bready[0]                  = axil_bready[C_ADAP0_INDEX];
    assign m_axil_adap_arvalid[0]                 = axil_arvalid[C_ADAP0_INDEX];
    assign m_axil_adap_araddr[`getvec(32, 0)]     = axil_adap0_araddr;
    assign axil_arready[C_ADAP0_INDEX]            = m_axil_adap_arready[0];
    assign axil_rvalid[C_ADAP0_INDEX]             = m_axil_adap_rvalid[0];
    assign axil_rdata[`getvec(32, C_ADAP0_INDEX)] = m_axil_adap_rdata[`getvec(32, 0)];
    assign axil_rresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_rresp[`getvec(2, 0)];
    assign m_axil_adap_rready[0]                  = axil_rready[C_ADAP0_INDEX];

    assign m_axil_cmac_awvalid[1]                 = axil_awvalid[C_CMAC1_INDEX];
    assign m_axil_cmac_awaddr[`getvec(32, 1)]     = axil_cmac1_awaddr;
    assign axil_awready[C_CMAC1_INDEX]            = m_axil_cmac_awready[1];
    assign m_axil_cmac_wvalid[1]                  = axil_wvalid[C_CMAC1_INDEX];
    assign m_axil_cmac_wdata[`getvec(32, 1)]      = axil_wdata[`getvec(32, C_CMAC1_INDEX)];
    assign axil_wready[C_CMAC1_INDEX]             = m_axil_cmac_wready[1];
    assign axil_bvalid[C_CMAC1_INDEX]             = m_axil_cmac_bvalid[1];
    assign axil_bresp[`getvec(2, C_CMAC1_INDEX)]  = m_axil_cmac_bresp[`getvec(2, 1)];
    assign m_axil_cmac_bready[1]                  = axil_bready[C_CMAC1_INDEX];
    assign m_axil_cmac_arvalid[1]                 = axil_arvalid[C_CMAC1_INDEX];
    assign m_axil_cmac_araddr[`getvec(32, 1)]     = axil_cmac1_araddr;
    assign axil_arready[C_CMAC1_INDEX]            = m_axil_cmac_arready[1];
    assign axil_rvalid[C_CMAC1_INDEX]             = m_axil_cmac_rvalid[1];
    assign axil_rdata[`getvec(32, C_CMAC1_INDEX)] = m_axil_cmac_rdata[`getvec(32, 1)];
    assign axil_rresp[`getvec(2, C_CMAC1_INDEX)]  = m_axil_cmac_rresp[`getvec(2, 1)];
    assign m_axil_cmac_rready[1]                  = axil_rready[C_CMAC1_INDEX];

    assign m_axil_adap_awvalid[1]                 = axil_awvalid[C_ADAP1_INDEX];
    assign m_axil_adap_awaddr[`getvec(32, 1)]     = axil_adap1_awaddr;
    assign axil_awready[C_ADAP1_INDEX]            = m_axil_adap_awready[1];
    assign m_axil_adap_wvalid[1]                  = axil_wvalid[C_ADAP1_INDEX];
    assign m_axil_adap_wdata[`getvec(32, 1)]      = axil_wdata[`getvec(32, C_ADAP1_INDEX)];
    assign axil_wready[C_ADAP1_INDEX]             = m_axil_adap_wready[1];
    assign axil_bvalid[C_ADAP1_INDEX]             = m_axil_adap_bvalid[1];
    assign axil_bresp[`getvec(2, C_ADAP1_INDEX)]  = m_axil_adap_bresp[`getvec(2, 1)];
    assign m_axil_adap_bready[1]                  = axil_bready[C_ADAP1_INDEX];
    assign m_axil_adap_arvalid[1]                 = axil_arvalid[C_ADAP1_INDEX];
    assign m_axil_adap_araddr[`getvec(32, 1)]     = axil_adap1_araddr;
    assign axil_arready[C_ADAP1_INDEX]            = m_axil_adap_arready[1];
    assign axil_rvalid[C_ADAP1_INDEX]             = m_axil_adap_rvalid[1];
    assign axil_rdata[`getvec(32, C_ADAP1_INDEX)] = m_axil_adap_rdata[`getvec(32, 1)];
    assign axil_rresp[`getvec(2, C_ADAP1_INDEX)]  = m_axil_adap_rresp[`getvec(2, 1)];
    assign m_axil_adap_rready[1]                  = axil_rready[C_ADAP1_INDEX];
  end

  assign m_axil_box1_awvalid                   = axil_awvalid[C_BOX1_INDEX];
  assign m_axil_box1_awaddr                    = axil_box1_awaddr;
  assign axil_awready[C_BOX1_INDEX]            = m_axil_box1_awready;
  assign m_axil_box1_wvalid                    = axil_wvalid[C_BOX1_INDEX];
  assign m_axil_box1_wdata                     = axil_wdata[`getvec(32, C_BOX1_INDEX)];
  assign axil_wready[C_BOX1_INDEX]             = m_axil_box1_wready;
  assign axil_bvalid[C_BOX1_INDEX]             = m_axil_box1_bvalid;
  assign axil_bresp[`getvec(2, C_BOX1_INDEX)]  = m_axil_box1_bresp;
  assign m_axil_box1_bready                    = axil_bready[C_BOX1_INDEX];
  assign m_axil_box1_arvalid                   = axil_arvalid[C_BOX1_INDEX];
  assign m_axil_box1_araddr                    = axil_box1_araddr;
  assign axil_arready[C_BOX1_INDEX]            = m_axil_box1_arready;
  assign axil_rvalid[C_BOX1_INDEX]             = m_axil_box1_rvalid;
  assign axil_rdata[`getvec(32, C_BOX1_INDEX)] = m_axil_box1_rdata;
  assign axil_rresp[`getvec(2, C_BOX1_INDEX)]  = m_axil_box1_rresp;
  assign m_axil_box1_rready                    = axil_rready[C_BOX1_INDEX];

  assign m_axil_box0_awvalid                   = axil_awvalid[C_BOX0_INDEX];
  assign m_axil_box0_awaddr                    = axil_box0_awaddr;
  assign axil_awready[C_BOX0_INDEX]            = m_axil_box0_awready;
  assign m_axil_box0_wvalid                    = axil_wvalid[C_BOX0_INDEX];
  assign m_axil_box0_wdata                     = axil_wdata[`getvec(32, C_BOX0_INDEX)];
  assign axil_wready[C_BOX0_INDEX]             = m_axil_box0_wready;
  assign axil_bvalid[C_BOX0_INDEX]             = m_axil_box0_bvalid;
  assign axil_bresp[`getvec(2, C_BOX0_INDEX)]  = m_axil_box0_bresp;
  assign m_axil_box0_bready                    = axil_bready[C_BOX0_INDEX];
  assign m_axil_box0_arvalid                   = axil_arvalid[C_BOX0_INDEX];
  assign m_axil_box0_araddr                    = axil_box0_araddr;
  assign axil_arready[C_BOX0_INDEX]            = m_axil_box0_arready;
  assign axil_rvalid[C_BOX0_INDEX]             = m_axil_box0_rvalid;
  assign axil_rdata[`getvec(32, C_BOX0_INDEX)] = m_axil_box0_rdata;
  assign axil_rresp[`getvec(2, C_BOX0_INDEX)]  = m_axil_box0_rresp;
  assign m_axil_box0_rready                    = axil_rready[C_BOX0_INDEX];

  system_config_axi_crossbar xbar_inst (
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

endmodule: system_config_address_map
