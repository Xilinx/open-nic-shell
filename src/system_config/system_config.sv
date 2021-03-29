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
module system_config #(
  parameter [31:0] BUILD_TIMESTAMP = 32'h01010000,
  parameter int    NUM_CMAC_PORT   = 1
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

  output                 [31:0] shell_rstn,
  input                  [31:0] shell_rst_done,
  output                 [31:0] user_rstn,
  input                  [31:0] user_rst_done,

  input                         aclk,
  input                         aresetn
);

  // Parameter DRC
  initial begin
    if (NUM_CMAC_PORT > 2 || NUM_CMAC_PORT < 1) begin
      $fatal("[%m] Number of CMACs should be within the range [1, 2]");
    end
  end

  wire        axil_scfg_awvalid;
  wire [31:0] axil_scfg_awaddr;
  wire        axil_scfg_awready;
  wire        axil_scfg_wvalid;
  wire [31:0] axil_scfg_wdata;
  wire        axil_scfg_wready;
  wire        axil_scfg_bvalid;
  wire  [1:0] axil_scfg_bresp;
  wire        axil_scfg_bready;
  wire        axil_scfg_arvalid;
  wire [31:0] axil_scfg_araddr;
  wire        axil_scfg_arready;
  wire        axil_scfg_rvalid;
  wire [31:0] axil_scfg_rdata;
  wire  [1:0] axil_scfg_rresp;
  wire        axil_scfg_rready;

  system_config_address_map #(
    .NUM_CMAC_PORT (NUM_CMAC_PORT)
  ) scfg_address_map_inst (
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

    .m_axil_scfg_awvalid (axil_scfg_awvalid),
    .m_axil_scfg_awaddr  (axil_scfg_awaddr),
    .m_axil_scfg_awready (axil_scfg_awready),
    .m_axil_scfg_wvalid  (axil_scfg_wvalid),
    .m_axil_scfg_wdata   (axil_scfg_wdata),
    .m_axil_scfg_wready  (axil_scfg_wready),
    .m_axil_scfg_bvalid  (axil_scfg_bvalid),
    .m_axil_scfg_bresp   (axil_scfg_bresp),
    .m_axil_scfg_bready  (axil_scfg_bready),
    .m_axil_scfg_arvalid (axil_scfg_arvalid),
    .m_axil_scfg_araddr  (axil_scfg_araddr),
    .m_axil_scfg_arready (axil_scfg_arready),
    .m_axil_scfg_rvalid  (axil_scfg_rvalid),
    .m_axil_scfg_rdata   (axil_scfg_rdata),
    .m_axil_scfg_rresp   (axil_scfg_rresp),
    .m_axil_scfg_rready  (axil_scfg_rready),

    .m_axil_qdma_awvalid (m_axil_qdma_awvalid),
    .m_axil_qdma_awaddr  (m_axil_qdma_awaddr),
    .m_axil_qdma_awready (m_axil_qdma_awready),
    .m_axil_qdma_wvalid  (m_axil_qdma_wvalid),
    .m_axil_qdma_wdata   (m_axil_qdma_wdata),
    .m_axil_qdma_wready  (m_axil_qdma_wready),
    .m_axil_qdma_bvalid  (m_axil_qdma_bvalid),
    .m_axil_qdma_bresp   (m_axil_qdma_bresp),
    .m_axil_qdma_bready  (m_axil_qdma_bready),
    .m_axil_qdma_arvalid (m_axil_qdma_arvalid),
    .m_axil_qdma_araddr  (m_axil_qdma_araddr),
    .m_axil_qdma_arready (m_axil_qdma_arready),
    .m_axil_qdma_rvalid  (m_axil_qdma_rvalid),
    .m_axil_qdma_rdata   (m_axil_qdma_rdata),
    .m_axil_qdma_rresp   (m_axil_qdma_rresp),
    .m_axil_qdma_rready  (m_axil_qdma_rready),

    .m_axil_adap_awvalid (m_axil_adap_awvalid),
    .m_axil_adap_awaddr  (m_axil_adap_awaddr),
    .m_axil_adap_awready (m_axil_adap_awready),
    .m_axil_adap_wvalid  (m_axil_adap_wvalid),
    .m_axil_adap_wdata   (m_axil_adap_wdata),
    .m_axil_adap_wready  (m_axil_adap_wready),
    .m_axil_adap_bvalid  (m_axil_adap_bvalid),
    .m_axil_adap_bresp   (m_axil_adap_bresp),
    .m_axil_adap_bready  (m_axil_adap_bready),
    .m_axil_adap_arvalid (m_axil_adap_arvalid),
    .m_axil_adap_araddr  (m_axil_adap_araddr),
    .m_axil_adap_arready (m_axil_adap_arready),
    .m_axil_adap_rvalid  (m_axil_adap_rvalid),
    .m_axil_adap_rdata   (m_axil_adap_rdata),
    .m_axil_adap_rresp   (m_axil_adap_rresp),
    .m_axil_adap_rready  (m_axil_adap_rready),

    .m_axil_cmac_awvalid (m_axil_cmac_awvalid),
    .m_axil_cmac_awaddr  (m_axil_cmac_awaddr),
    .m_axil_cmac_awready (m_axil_cmac_awready),
    .m_axil_cmac_wvalid  (m_axil_cmac_wvalid),
    .m_axil_cmac_wdata   (m_axil_cmac_wdata),
    .m_axil_cmac_wready  (m_axil_cmac_wready),
    .m_axil_cmac_bvalid  (m_axil_cmac_bvalid),
    .m_axil_cmac_bresp   (m_axil_cmac_bresp),
    .m_axil_cmac_bready  (m_axil_cmac_bready),
    .m_axil_cmac_arvalid (m_axil_cmac_arvalid),
    .m_axil_cmac_araddr  (m_axil_cmac_araddr),
    .m_axil_cmac_arready (m_axil_cmac_arready),
    .m_axil_cmac_rvalid  (m_axil_cmac_rvalid),
    .m_axil_cmac_rdata   (m_axil_cmac_rdata),
    .m_axil_cmac_rresp   (m_axil_cmac_rresp),
    .m_axil_cmac_rready  (m_axil_cmac_rready),

    .m_axil_box0_awvalid (m_axil_box0_awvalid),
    .m_axil_box0_awaddr  (m_axil_box0_awaddr),
    .m_axil_box0_awready (m_axil_box0_awready),
    .m_axil_box0_wvalid  (m_axil_box0_wvalid),
    .m_axil_box0_wdata   (m_axil_box0_wdata),
    .m_axil_box0_wready  (m_axil_box0_wready),
    .m_axil_box0_bvalid  (m_axil_box0_bvalid),
    .m_axil_box0_bresp   (m_axil_box0_bresp),
    .m_axil_box0_bready  (m_axil_box0_bready),
    .m_axil_box0_arvalid (m_axil_box0_arvalid),
    .m_axil_box0_araddr  (m_axil_box0_araddr),
    .m_axil_box0_arready (m_axil_box0_arready),
    .m_axil_box0_rvalid  (m_axil_box0_rvalid),
    .m_axil_box0_rdata   (m_axil_box0_rdata),
    .m_axil_box0_rresp   (m_axil_box0_rresp),
    .m_axil_box0_rready  (m_axil_box0_rready),

    .m_axil_box1_awvalid (m_axil_box1_awvalid),
    .m_axil_box1_awaddr  (m_axil_box1_awaddr),
    .m_axil_box1_awready (m_axil_box1_awready),
    .m_axil_box1_wvalid  (m_axil_box1_wvalid),
    .m_axil_box1_wdata   (m_axil_box1_wdata),
    .m_axil_box1_wready  (m_axil_box1_wready),
    .m_axil_box1_bvalid  (m_axil_box1_bvalid),
    .m_axil_box1_bresp   (m_axil_box1_bresp),
    .m_axil_box1_bready  (m_axil_box1_bready),
    .m_axil_box1_arvalid (m_axil_box1_arvalid),
    .m_axil_box1_araddr  (m_axil_box1_araddr),
    .m_axil_box1_arready (m_axil_box1_arready),
    .m_axil_box1_rvalid  (m_axil_box1_rvalid),
    .m_axil_box1_rdata   (m_axil_box1_rdata),
    .m_axil_box1_rresp   (m_axil_box1_rresp),
    .m_axil_box1_rready  (m_axil_box1_rready),

    .aclk                (aclk),
    .aresetn             (aresetn)
  );

  system_config_register #(
    .BUILD_TIMESTAMP (BUILD_TIMESTAMP)
  ) scfg_reg_inst (
    .s_axil_awvalid (axil_scfg_awvalid),
    .s_axil_awaddr  (axil_scfg_awaddr),
    .s_axil_awready (axil_scfg_awready),
    .s_axil_wvalid  (axil_scfg_wvalid),
    .s_axil_wdata   (axil_scfg_wdata),
    .s_axil_wready  (axil_scfg_wready),
    .s_axil_bvalid  (axil_scfg_bvalid),
    .s_axil_bresp   (axil_scfg_bresp),
    .s_axil_bready  (axil_scfg_bready),
    .s_axil_arvalid (axil_scfg_arvalid),
    .s_axil_araddr  (axil_scfg_araddr),
    .s_axil_arready (axil_scfg_arready),
    .s_axil_rvalid  (axil_scfg_rvalid),
    .s_axil_rdata   (axil_scfg_rdata),
    .s_axil_rresp   (axil_scfg_rresp),
    .s_axil_rready  (axil_scfg_rready),

    .shell_rstn     (shell_rstn),
    .shell_rst_done (shell_rst_done),
    .user_rstn      (user_rstn),
    .user_rst_done  (user_rst_done),

    .aclk           (aclk),
    .aresetn        (aresetn)
  );

endmodule: system_config
