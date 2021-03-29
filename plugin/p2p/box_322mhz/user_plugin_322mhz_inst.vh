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
localparam C_NUM_USER_BLOCK = 1;

// Make sure for all the unused reset pair, corresponding bits in
// "mod_rst_done" are tied to 0
assign mod_rst_done[7:C_NUM_USER_BLOCK] = {(8-C_NUM_USER_BLOCK){1'b1}};

p2p_322mhz #(
  .NUM_CMAC_PORT (NUM_CMAC_PORT)
) p2p_322mhz_inst (
  .s_axil_awvalid                  (axil_p2p_awvalid),
  .s_axil_awaddr                   (axil_p2p_awaddr),
  .s_axil_awready                  (axil_p2p_awready),
  .s_axil_wvalid                   (axil_p2p_wvalid),
  .s_axil_wdata                    (axil_p2p_wdata),
  .s_axil_wready                   (axil_p2p_wready),
  .s_axil_bvalid                   (axil_p2p_bvalid),
  .s_axil_bresp                    (axil_p2p_bresp),
  .s_axil_bready                   (axil_p2p_bready),
  .s_axil_arvalid                  (axil_p2p_arvalid),
  .s_axil_araddr                   (axil_p2p_araddr),
  .s_axil_arready                  (axil_p2p_arready),
  .s_axil_rvalid                   (axil_p2p_rvalid),
  .s_axil_rdata                    (axil_p2p_rdata),
  .s_axil_rresp                    (axil_p2p_rresp),
  .s_axil_rready                   (axil_p2p_rready),

  .s_axis_adap_tx_322mhz_tvalid    (s_axis_adap_tx_322mhz_tvalid),
  .s_axis_adap_tx_322mhz_tdata     (s_axis_adap_tx_322mhz_tdata),
  .s_axis_adap_tx_322mhz_tkeep     (s_axis_adap_tx_322mhz_tkeep),
  .s_axis_adap_tx_322mhz_tlast     (s_axis_adap_tx_322mhz_tlast),
  .s_axis_adap_tx_322mhz_tuser_err (s_axis_adap_tx_322mhz_tuser_err),
  .s_axis_adap_tx_322mhz_tready    (s_axis_adap_tx_322mhz_tready),

  .m_axis_adap_rx_322mhz_tvalid    (m_axis_adap_rx_322mhz_tvalid),
  .m_axis_adap_rx_322mhz_tdata     (m_axis_adap_rx_322mhz_tdata),
  .m_axis_adap_rx_322mhz_tkeep     (m_axis_adap_rx_322mhz_tkeep),
  .m_axis_adap_rx_322mhz_tlast     (m_axis_adap_rx_322mhz_tlast),
  .m_axis_adap_rx_322mhz_tuser_err (m_axis_adap_rx_322mhz_tuser_err),

  .m_axis_cmac_tx_tvalid           (m_axis_cmac_tx_tvalid),
  .m_axis_cmac_tx_tdata            (m_axis_cmac_tx_tdata),
  .m_axis_cmac_tx_tkeep            (m_axis_cmac_tx_tkeep),
  .m_axis_cmac_tx_tlast            (m_axis_cmac_tx_tlast),
  .m_axis_cmac_tx_tuser_err        (m_axis_cmac_tx_tuser_err),
  .m_axis_cmac_tx_tready           (m_axis_cmac_tx_tready),

  .s_axis_cmac_rx_tvalid           (s_axis_cmac_rx_tvalid),
  .s_axis_cmac_rx_tdata            (s_axis_cmac_rx_tdata),
  .s_axis_cmac_rx_tkeep            (s_axis_cmac_rx_tkeep),
  .s_axis_cmac_rx_tlast            (s_axis_cmac_rx_tlast),
  .s_axis_cmac_rx_tuser_err        (s_axis_cmac_rx_tuser_err),

  .mod_rstn                        (mod_rstn[0]),
  .mod_rst_done                    (mod_rst_done[0]),

  .axil_aclk                       (axil_aclk),
  .cmac_clk                        (cmac_clk)
);
