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
// QDMA subsystem address map
//
// System-level address range: 0x01000 - 0x05FFF
//
// --------------------------------------------------
//   BaseAddr |  HighAddr |  Module
// --------------------------------------------------
//    0x0000  |   0x0FFF  |  Function 0 registers
// --------------------------------------------------
//    0x1000  |   0x1FFF  |  Function 1 registers
// --------------------------------------------------
//    0x2000  |   0x2FFF  |  Function 2 registers
// --------------------------------------------------
//    0x3000  |   0x3FFF  |  Function 3 registers
// --------------------------------------------------
//    0x4000  |   0x4FFF  |  Subsystem registers
// --------------------------------------------------
`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module qdma_subsystem_address_map #(
  parameter int NUM_PHYS_FUNC = 1
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

  output    [NUM_PHYS_FUNC-1:0] m_axil_func_awvalid,
  output [32*NUM_PHYS_FUNC-1:0] m_axil_func_awaddr,
  input     [NUM_PHYS_FUNC-1:0] m_axil_func_awready,
  output    [NUM_PHYS_FUNC-1:0] m_axil_func_wvalid,
  output [32*NUM_PHYS_FUNC-1:0] m_axil_func_wdata,
  input     [NUM_PHYS_FUNC-1:0] m_axil_func_wready,
  input     [NUM_PHYS_FUNC-1:0] m_axil_func_bvalid,
  input   [2*NUM_PHYS_FUNC-1:0] m_axil_func_bresp,
  output    [NUM_PHYS_FUNC-1:0] m_axil_func_bready,
  output    [NUM_PHYS_FUNC-1:0] m_axil_func_arvalid,
  output [32*NUM_PHYS_FUNC-1:0] m_axil_func_araddr,
  input     [NUM_PHYS_FUNC-1:0] m_axil_func_arready,
  input     [NUM_PHYS_FUNC-1:0] m_axil_func_rvalid,
  input  [32*NUM_PHYS_FUNC-1:0] m_axil_func_rdata,
  input   [2*NUM_PHYS_FUNC-1:0] m_axil_func_rresp,
  output    [NUM_PHYS_FUNC-1:0] m_axil_func_rready,

  output                        m_axil_awvalid,
  output                 [31:0] m_axil_awaddr,
  input                         m_axil_awready,
  output                        m_axil_wvalid,
  output                 [31:0] m_axil_wdata,
  input                         m_axil_wready,
  input                         m_axil_bvalid,
  input                   [1:0] m_axil_bresp,
  output                        m_axil_bready,
  output                        m_axil_arvalid,
  output                 [31:0] m_axil_araddr,
  input                         m_axil_arready,
  input                         m_axil_rvalid,
  input                  [31:0] m_axil_rdata,
  input                   [1:0] m_axil_rresp,
  output                        m_axil_rready,

  input                         aclk,
  input                         aresetn
);

  localparam C_NUM_SLAVES       = NUM_PHYS_FUNC + 1;
  localparam C_SUBSYS_INDEX     = NUM_PHYS_FUNC;
  localparam C_FUNC_BASE_ADDR   = 32'h0;
  localparam C_FUNC_ADDR_INCR   = 32'h1000;
  localparam C_SUBSYS_BASE_ADDR = 32'h4000;

  wire                [31:0] axil_func_awaddr[0:NUM_PHYS_FUNC-1];
  wire                [31:0] axil_func_araddr[0:NUM_PHYS_FUNC-1];
  wire                [31:0] axil_subsys_awaddr;
  wire                [31:0] axil_subsys_araddr;

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
  generate for (genvar i = 0; i < NUM_PHYS_FUNC; i++) begin
    assign axil_func_awaddr[i] = axil_awaddr[`getvec(32, i)] - (C_FUNC_BASE_ADDR + i * C_FUNC_ADDR_INCR);
    assign axil_func_araddr[i] = axil_araddr[`getvec(32, i)] - (C_FUNC_BASE_ADDR + i * C_FUNC_ADDR_INCR);

    assign m_axil_func_awvalid[i]             = axil_awvalid[i];
    assign m_axil_func_awaddr[`getvec(32, i)] = axil_func_awaddr[i];
    assign axil_awready[i]                    = m_axil_func_awready[i];
    assign m_axil_func_wvalid[i]              = axil_wvalid[i];
    assign m_axil_func_wdata[`getvec(32, i)]  = axil_wdata[`getvec(32, i)];
    assign axil_wready[i]                     = m_axil_func_wready[i];
    assign axil_bvalid[i]                     = m_axil_func_bvalid[i];
    assign axil_bresp[`getvec(2, i)]          = m_axil_func_bresp[`getvec(2, i)];
    assign m_axil_func_bready[i]              = axil_bready[i];
    assign m_axil_func_arvalid[i]             = axil_arvalid[i];
    assign m_axil_func_araddr[`getvec(32, i)] = axil_func_araddr[i];
    assign axil_arready[i]                    = m_axil_func_arready[i];
    assign axil_rvalid[i]                     = m_axil_func_rvalid[i];
    assign axil_rdata[`getvec(32, i)]         = m_axil_func_rdata[`getvec(32, i)];
    assign axil_rresp[`getvec(2, i)]          = m_axil_func_rresp[`getvec(2, i)];
    assign m_axil_func_rready[i]              = axil_rready[i];
  end
  endgenerate
  assign axil_subsys_awaddr = axil_awaddr[`getvec(32, C_SUBSYS_INDEX)] - C_SUBSYS_BASE_ADDR;
  assign axil_subsys_araddr = axil_araddr[`getvec(32, C_SUBSYS_INDEX)] - C_SUBSYS_BASE_ADDR;

  assign m_axil_awvalid                          = axil_awvalid[C_SUBSYS_INDEX];
  assign m_axil_awaddr                           = axil_subsys_awaddr;
  assign axil_awready[C_SUBSYS_INDEX]            = m_axil_awready;
  assign m_axil_wvalid                           = axil_wvalid[C_SUBSYS_INDEX];
  assign m_axil_wdata                            = axil_wdata[`getvec(32, C_SUBSYS_INDEX)];
  assign axil_wready[C_SUBSYS_INDEX]             = m_axil_wready;
  assign axil_bvalid[C_SUBSYS_INDEX]             = m_axil_bvalid;
  assign axil_bresp[`getvec(2, C_SUBSYS_INDEX)]  = m_axil_bresp;
  assign m_axil_bready                           = axil_bready[C_SUBSYS_INDEX];
  assign m_axil_arvalid                          = axil_arvalid[C_SUBSYS_INDEX];
  assign m_axil_araddr                           = axil_subsys_araddr;
  assign axil_arready[C_SUBSYS_INDEX]            = m_axil_arready;
  assign axil_rvalid[C_SUBSYS_INDEX]             = m_axil_rvalid;
  assign axil_rdata[`getvec(32, C_SUBSYS_INDEX)] = m_axil_rdata;
  assign axil_rresp[`getvec(2, C_SUBSYS_INDEX)]  = m_axil_rresp;
  assign m_axil_rready                           = axil_rready[C_SUBSYS_INDEX];

  qdma_subsystem_axi_crossbar xbar_inst (
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

endmodule: qdma_subsystem_address_map
