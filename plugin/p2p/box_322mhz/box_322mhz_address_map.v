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
// Address map for the box running at 322MHz (through PCI-e BAR2 1MB)
//
// System-level address range: 0x10000 - 0x3FFFF
//
// --------------------------------------------------
//   BaseAddr |  HighAddr |  Module
// --------------------------------------------------
//   0x0000   |  0x0FFF   |  Port-to-port
// --------------------------------------------------
//   0x1000   |  0x1FFF   |  Dummy
// --------------------------------------------------
`timescale 1ns/1ps
module box_322mhz_address_map (
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
  
  output        m_axil_p2p_awvalid,
  output [31:0] m_axil_p2p_awaddr,
  input         m_axil_p2p_awready,
  output        m_axil_p2p_wvalid,
  output [31:0] m_axil_p2p_wdata,
  input         m_axil_p2p_wready,
  input         m_axil_p2p_bvalid,
  input   [1:0] m_axil_p2p_bresp,
  output        m_axil_p2p_bready,
  output        m_axil_p2p_arvalid,
  output [31:0] m_axil_p2p_araddr,
  input         m_axil_p2p_arready,
  input         m_axil_p2p_rvalid,
  input  [31:0] m_axil_p2p_rdata,
  input   [1:0] m_axil_p2p_rresp,
  output        m_axil_p2p_rready,

  output        m_axil_dummy_awvalid,
  output [31:0] m_axil_dummy_awaddr,
  input         m_axil_dummy_awready,
  output        m_axil_dummy_wvalid,
  output [31:0] m_axil_dummy_wdata,
  input         m_axil_dummy_wready,
  input         m_axil_dummy_bvalid,
  input   [1:0] m_axil_dummy_bresp,
  output        m_axil_dummy_bready,
  output        m_axil_dummy_arvalid,
  output [31:0] m_axil_dummy_araddr,
  input         m_axil_dummy_arready,
  input         m_axil_dummy_rvalid,
  input  [31:0] m_axil_dummy_rdata,
  input   [1:0] m_axil_dummy_rresp,
  output        m_axil_dummy_rready,

  input         aclk,
  input         aresetn
);

  localparam C_NUM_SLAVES  = 2;

  localparam C_P2P_INDEX   = 0;
  localparam C_DUMMY_INDEX = 1;

  localparam C_P2P_BASE_ADDR   = 32'h0;
  localparam C_DUMMY_BASE_ADDR = 32'h200000;

  wire                  [31:0] axil_p2p_awaddr;
  wire                  [31:0] axil_p2p_araddr;
  wire                  [31:0] axil_dummy_awaddr;
  wire                  [31:0] axil_dummy_araddr;

  wire  [(1*C_NUM_SLAVES)-1:0] axil_awvalid;
  wire [(32*C_NUM_SLAVES)-1:0] axil_awaddr;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_awready;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_wvalid;
  wire [(32*C_NUM_SLAVES)-1:0] axil_wdata;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_wready;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_bvalid;
  wire  [(2*C_NUM_SLAVES)-1:0] axil_bresp;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_bready;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_arvalid;
  wire [(32*C_NUM_SLAVES)-1:0] axil_araddr;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_arready;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_rvalid;
  wire [(32*C_NUM_SLAVES)-1:0] axil_rdata;
  wire  [(2*C_NUM_SLAVES)-1:0] axil_rresp;
  wire  [(1*C_NUM_SLAVES)-1:0] axil_rready;

  // Adjust AXI-Lite address so that each slave can assume a base address of 0x0
  assign axil_p2p_awaddr                    = axil_awaddr[C_P2P_INDEX*32 +: 32] - C_P2P_BASE_ADDR;
  assign axil_p2p_araddr                    = axil_araddr[C_P2P_INDEX*32 +: 32] - C_P2P_BASE_ADDR;
  assign axil_dummy_awaddr                  = axil_awaddr[C_DUMMY_INDEX*32 +: 32] - C_DUMMY_BASE_ADDR;
  assign axil_dummy_araddr                  = axil_araddr[C_DUMMY_INDEX*32 +: 32] - C_DUMMY_BASE_ADDR;

  assign m_axil_p2p_awvalid                 = axil_awvalid[C_P2P_INDEX];
  assign m_axil_p2p_awaddr                  = axil_p2p_awaddr;
  assign axil_awready[C_P2P_INDEX]          = m_axil_p2p_awready;
  assign m_axil_p2p_wvalid                  = axil_wvalid[C_P2P_INDEX];
  assign m_axil_p2p_wdata                   = axil_wdata[C_P2P_INDEX*32 +: 32];
  assign axil_wready[C_P2P_INDEX]           = m_axil_p2p_wready;
  assign axil_bvalid[C_P2P_INDEX]           = m_axil_p2p_bvalid;
  assign axil_bresp[C_P2P_INDEX*2 +: 2]     = m_axil_p2p_bresp;
  assign m_axil_p2p_bready                  = axil_bready[C_P2P_INDEX];
  assign m_axil_p2p_arvalid                 = axil_arvalid[C_P2P_INDEX];
  assign m_axil_p2p_araddr                  = axil_p2p_araddr;
  assign axil_arready[C_P2P_INDEX]          = m_axil_p2p_arready;
  assign axil_rvalid[C_P2P_INDEX]           = m_axil_p2p_rvalid;
  assign axil_rdata[C_P2P_INDEX*32 +: 32]   = m_axil_p2p_rdata;
  assign axil_rresp[C_P2P_INDEX*2 +: 2]     = m_axil_p2p_rresp;
  assign m_axil_p2p_rready                  = axil_rready[C_P2P_INDEX];

  assign m_axil_dummy_awvalid               = axil_awvalid[C_DUMMY_INDEX];
  assign m_axil_dummy_awaddr                = axil_dummy_awaddr;
  assign axil_awready[C_DUMMY_INDEX]        = m_axil_dummy_awready;
  assign m_axil_dummy_wvalid                = axil_wvalid[C_DUMMY_INDEX];
  assign m_axil_dummy_wdata                 = axil_wdata[C_DUMMY_INDEX*32 +: 32];
  assign axil_wready[C_DUMMY_INDEX]         = m_axil_dummy_wready;
  assign axil_bvalid[C_DUMMY_INDEX]         = m_axil_dummy_bvalid;
  assign axil_bresp[C_DUMMY_INDEX*2 +: 2]   = m_axil_dummy_bresp;
  assign m_axil_dummy_bready                = axil_bready[C_DUMMY_INDEX];
  assign m_axil_dummy_arvalid               = axil_arvalid[C_DUMMY_INDEX];
  assign m_axil_dummy_araddr                = axil_dummy_araddr;
  assign axil_arready[C_DUMMY_INDEX]        = m_axil_dummy_arready;
  assign axil_rvalid[C_DUMMY_INDEX]         = m_axil_dummy_rvalid;
  assign axil_rdata[C_DUMMY_INDEX*32 +: 32] = m_axil_dummy_rdata;
  assign axil_rresp[C_DUMMY_INDEX* 2 +: 2]  = m_axil_dummy_rresp;
  assign m_axil_dummy_rready                = axil_rready[C_DUMMY_INDEX];

  box_322mhz_axi_crossbar xbar_inst (
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

endmodule: box_322mhz_address_map
