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
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_awvalid;
wire [32*NUM_CMAC_PORT*2-1:0] axil_p2p_awaddr;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_awready;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_wvalid;
wire [32*NUM_CMAC_PORT*2-1:0] axil_p2p_wdata;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_wready;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_bvalid;
wire  [2*NUM_CMAC_PORT*2-1:0] axil_p2p_bresp;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_bready;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_arvalid;
wire [32*NUM_CMAC_PORT*2-1:0] axil_p2p_araddr;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_arready;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_rvalid;
wire [32*NUM_CMAC_PORT*2-1:0] axil_p2p_rdata;
wire  [2*NUM_CMAC_PORT*2-1:0] axil_p2p_rresp;
wire    [NUM_CMAC_PORT*2-1:0] axil_p2p_rready;

wire        axil_dummy_awvalid;
wire [31:0] axil_dummy_awaddr;
wire        axil_dummy_awready;
wire        axil_dummy_wvalid;
wire [31:0] axil_dummy_wdata;
wire        axil_dummy_wready;
wire        axil_dummy_bvalid;
wire  [1:0] axil_dummy_bresp;
wire        axil_dummy_bready;
wire        axil_dummy_arvalid;
wire [31:0] axil_dummy_araddr;
wire        axil_dummy_arready;
wire        axil_dummy_rvalid;
wire [31:0] axil_dummy_rdata;
wire  [1:0] axil_dummy_rresp;
wire        axil_dummy_rready;

box_250mhz_address_map #(
  .NUM_INTF          (NUM_PHYS_FUNC)
) address_map_inst (
  .s_axil_awvalid       (s_axil_awvalid),
  .s_axil_awaddr        (s_axil_awaddr),
  .s_axil_awready       (s_axil_awready),
  .s_axil_wvalid        (s_axil_wvalid),
  .s_axil_wdata         (s_axil_wdata),
  .s_axil_wready        (s_axil_wready),
  .s_axil_bvalid        (s_axil_bvalid),
  .s_axil_bresp         (s_axil_bresp),
  .s_axil_bready        (s_axil_bready),
  .s_axil_arvalid       (s_axil_arvalid),
  .s_axil_araddr        (s_axil_araddr),
  .s_axil_arready       (s_axil_arready),
  .s_axil_rvalid        (s_axil_rvalid),
  .s_axil_rdata         (s_axil_rdata),
  .s_axil_rresp         (s_axil_rresp),
  .s_axil_rready        (s_axil_rready),

  .m_axil_p2p_awvalid   (axil_p2p_awvalid),
  .m_axil_p2p_awaddr    (axil_p2p_awaddr),
  .m_axil_p2p_awready   (axil_p2p_awready),
  .m_axil_p2p_wvalid    (axil_p2p_wvalid),
  .m_axil_p2p_wdata     (axil_p2p_wdata),
  .m_axil_p2p_wready    (axil_p2p_wready),
  .m_axil_p2p_bvalid    (axil_p2p_bvalid),
  .m_axil_p2p_bresp     (axil_p2p_bresp),
  .m_axil_p2p_bready    (axil_p2p_bready),
  .m_axil_p2p_arvalid   (axil_p2p_arvalid),
  .m_axil_p2p_araddr    (axil_p2p_araddr),
  .m_axil_p2p_arready   (axil_p2p_arready),
  .m_axil_p2p_rvalid    (axil_p2p_rvalid),
  .m_axil_p2p_rdata     (axil_p2p_rdata),
  .m_axil_p2p_rresp     (axil_p2p_rresp),
  .m_axil_p2p_rready    (axil_p2p_rready),

  .m_axil_dummy_awvalid (axil_dummy_awvalid),
  .m_axil_dummy_awaddr  (axil_dummy_awaddr),
  .m_axil_dummy_awready (axil_dummy_awready),
  .m_axil_dummy_wvalid  (axil_dummy_wvalid),
  .m_axil_dummy_wdata   (axil_dummy_wdata),
  .m_axil_dummy_wready  (axil_dummy_wready),
  .m_axil_dummy_bvalid  (axil_dummy_bvalid),
  .m_axil_dummy_bresp   (axil_dummy_bresp),
  .m_axil_dummy_bready  (axil_dummy_bready),
  .m_axil_dummy_arvalid (axil_dummy_arvalid),
  .m_axil_dummy_araddr  (axil_dummy_araddr),
  .m_axil_dummy_arready (axil_dummy_arready),
  .m_axil_dummy_rvalid  (axil_dummy_rvalid),
  .m_axil_dummy_rdata   (axil_dummy_rdata),
  .m_axil_dummy_rresp   (axil_dummy_rresp),
  .m_axil_dummy_rready  (axil_dummy_rready),

  .aclk                 (axil_aclk),
  .aresetn              (internal_box_rstn)
);

// Sink for the unused dummy register interface
axi_lite_slave #(
  .REG_ADDR_W (12),
  .REG_PREFIX (16'hD000)
) dummy_reg_inst (
  .s_axil_awvalid (axil_dummy_awvalid),
  .s_axil_awaddr  (axil_dummy_awaddr),
  .s_axil_awready (axil_dummy_awready),
  .s_axil_wvalid  (axil_dummy_wvalid),
  .s_axil_wdata   (axil_dummy_wdata),
  .s_axil_wready  (axil_dummy_wready),
  .s_axil_bvalid  (axil_dummy_bvalid),
  .s_axil_bresp   (axil_dummy_bresp),
  .s_axil_bready  (axil_dummy_bready),
  .s_axil_arvalid (axil_dummy_arvalid),
  .s_axil_araddr  (axil_dummy_araddr),
  .s_axil_arready (axil_dummy_arready),
  .s_axil_rvalid  (axil_dummy_rvalid),
  .s_axil_rdata   (axil_dummy_rdata),
  .s_axil_rresp   (axil_dummy_rresp),
  .s_axil_rready  (axil_dummy_rready),

  .aresetn        (internal_box_rstn),
  .aclk           (axil_aclk)
);

