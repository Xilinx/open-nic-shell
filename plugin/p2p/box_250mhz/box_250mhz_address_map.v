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
// Address map for the box running at 250MHz (through PCI-e BAR2 1MB)
//
// System-level address range: 0x40000 - 0xFFFFF
//
// --------------------------------------------------
//   BaseAddr |  HighAddr |  Module
// --------------------------------------------------
//   0x0000   |  0x007F   |  Ingress of port 0
// --------------------------------------------------
//   0x0080   |  0x00FF   |  Egress of port 0
// --------------------------------------------------
//   0x0100   |  0x017F   |  Ingress of port 1
// --------------------------------------------------
//   0x0180   |  0x01FF   |  Egress of port 1
// --------------------------------------------------
//   0x1000   |  0x1FFF   |  Dummy
// --------------------------------------------------
`timescale 1ns/1ps
module box_250mhz_address_map #(
  parameter integer NUM_INTF = 1
) (
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
  
  output    [NUM_INTF*2-1:0] m_axil_p2p_awvalid,
  output [32*NUM_INTF*2-1:0] m_axil_p2p_awaddr,
  input     [NUM_INTF*2-1:0] m_axil_p2p_awready,
  output    [NUM_INTF*2-1:0] m_axil_p2p_wvalid,
  output [32*NUM_INTF*2-1:0] m_axil_p2p_wdata,
  input     [NUM_INTF*2-1:0] m_axil_p2p_wready,
  input     [NUM_INTF*2-1:0] m_axil_p2p_bvalid,
  input   [2*NUM_INTF*2-1:0] m_axil_p2p_bresp,
  output    [NUM_INTF*2-1:0] m_axil_p2p_bready,
  output    [NUM_INTF*2-1:0] m_axil_p2p_arvalid,
  output [32*NUM_INTF*2-1:0] m_axil_p2p_araddr,
  input     [NUM_INTF*2-1:0] m_axil_p2p_arready,
  input     [NUM_INTF*2-1:0] m_axil_p2p_rvalid,
  input  [32*NUM_INTF*2-1:0] m_axil_p2p_rdata,
  input   [2*NUM_INTF*2-1:0] m_axil_p2p_rresp,
  output    [NUM_INTF*2-1:0] m_axil_p2p_rready,

  input         aclk,
  input         aresetn
);

  localparam C_BASE_ADDR = 32'h0;
  localparam C_SIZE = 32'h80;

  wire    [NUM_INTF*2-1:0] axil_awvalid;
  wire [32*NUM_INTF*2-1:0] axil_awaddr;
  wire    [NUM_INTF*2-1:0] axil_awready;
  wire    [NUM_INTF*2-1:0] axil_wvalid;
  wire [32*NUM_INTF*2-1:0] axil_wdata;
  wire    [NUM_INTF*2-1:0] axil_wready;
  wire    [NUM_INTF*2-1:0] axil_bvalid;
  wire  [2*NUM_INTF*2-1:0] axil_bresp;
  wire    [NUM_INTF*2-1:0] axil_bready;
  wire    [NUM_INTF*2-1:0] axil_arvalid;
  wire [32*NUM_INTF*2-1:0] axil_araddr;
  wire    [NUM_INTF*2-1:0] axil_arready;
  wire    [NUM_INTF*2-1:0] axil_rvalid;
  wire [32*NUM_INTF*2-1:0] axil_rdata;
  wire  [2*NUM_INTF*2-1:0] axil_rresp;
  wire    [NUM_INTF*2-1:0] axil_rready;

  // Adjust AXI-Lite address so that each slave can assume a base address of 0x0
  for (genvar i = 0; i < NUM_INTF*2; i=i+1) begin
    assign m_axil_p2p_awaddr[32*i +: 32] = axil_awaddr[32*i +: 32] - C_SIZE*i - C_BASE_ADDR;
    assign m_axil_p2p_araddr[32*i +: 32] = axil_araddr[32*i +: 32] - C_SIZE*i - C_BASE_ADDR;
  end

  assign m_axil_p2p_awvalid = axil_awvalid;
  assign axil_awready       = m_axil_p2p_awready;
  assign m_axil_p2p_wvalid  = axil_wvalid;
  assign m_axil_p2p_wdata   = axil_wdata;
  assign axil_wready        = m_axil_p2p_wready;
  assign axil_bvalid        = m_axil_p2p_bvalid;
  assign axil_bresp         = m_axil_p2p_bresp;
  assign m_axil_p2p_bready  = axil_bready;
  assign m_axil_p2p_arvalid = axil_arvalid;
  assign axil_arready       = m_axil_p2p_arready;
  assign axil_rvalid        = m_axil_p2p_rvalid;
  assign axil_rdata         = m_axil_p2p_rdata;
  assign axil_rresp         = m_axil_p2p_rresp;
  assign m_axil_p2p_rready  = axil_rready;

  box_250mhz_axi_crossbar xbar_inst (
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

endmodule: box_250mhz_address_map
