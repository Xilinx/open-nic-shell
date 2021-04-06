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
module box_322mhz #(
  parameter int MIN_PKT_LEN   = 64,
  parameter int MAX_PKT_LEN   = 1518,
  parameter int NUM_CMAC_PORT = 1
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

  input      [NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tuser_err,
  output     [NUM_CMAC_PORT-1:0] s_axis_adap_tx_322mhz_tready,

  output     [NUM_CMAC_PORT-1:0] m_axis_adap_rx_322mhz_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_adap_rx_322mhz_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_adap_rx_322mhz_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_adap_rx_322mhz_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_adap_rx_322mhz_tuser_err,

  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tvalid,
  output [512*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tdata,
  output  [64*NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tkeep,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tlast,
  output     [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tuser_err,
  input      [NUM_CMAC_PORT-1:0] m_axis_cmac_tx_tready,

  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tvalid,
  input  [512*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tdata,
  input   [64*NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tkeep,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tlast,
  input      [NUM_CMAC_PORT-1:0] s_axis_cmac_rx_tuser_err,

  // Reset pairs for modules in the box (synchronized to `axil_aclk`)
  input                    [7:0] mod_rstn,
  output                   [7:0] mod_rst_done,

  // Reset pair for the box itself (synchronized to `axil_aclk`)
  input                          box_rstn,
  output                         box_rst_done,

  // Each CMAC instance has its own phase-independent `cmac_clk`
  input                          axil_aclk,
  input      [NUM_CMAC_PORT-1:0] cmac_clk
);

  wire internal_box_rstn;

  generic_reset #(
    .NUM_INPUT_CLK  (1),
    .RESET_DURATION (100)
  ) reset_inst (
    .mod_rstn     (box_rstn),
    .mod_rst_done (box_rst_done),
    .clk          (axil_aclk),
    .rstn         (internal_box_rstn)
  );

  `include "box_322mhz_address_map_inst.vh"
  `include "user_plugin_322mhz_inst.vh"

endmodule: box_322mhz
