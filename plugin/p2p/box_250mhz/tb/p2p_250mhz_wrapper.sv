`timescale 1ns/1ps

// Since cocotb attaches to one AXI stream port at a time, we need the top level
// module to expose each port as a separate interface.

module p2p_250mhz_wrapper (
  input wire                     s_axil_awvalid,
  input wire              [31:0] s_axil_awaddr,
  output wire                    s_axil_awready,
  input wire                     s_axil_wvalid,
  input wire              [31:0] s_axil_wdata,
  input wire               [3:0] s_axil_wstrb, // Dummy, only used for sim.
  output wire                    s_axil_wready,
  output wire                    s_axil_bvalid,
  output wire              [1:0] s_axil_bresp,
  input wire                     s_axil_bready,
  input wire                     s_axil_arvalid,
  input wire              [31:0] s_axil_araddr,
  output wire                    s_axil_arready,
  output wire                    s_axil_rvalid,
  output wire             [31:0] s_axil_rdata,
  output wire              [1:0] s_axil_rresp,
  input wire                     s_axil_rready,

  // From PCIe
  input wire      [1-1:0] s_axis_qdma_h2c_port0_tvalid,
  input wire  [512*1-1:0] s_axis_qdma_h2c_port0_tdata,
  input wire   [64*1-1:0] s_axis_qdma_h2c_port0_tkeep,
  input wire      [1-1:0] s_axis_qdma_h2c_port0_tlast,
  input wire   [48*1-1:0] s_axis_qdma_h2c_port0_tuser,
  output wire     [1-1:0] s_axis_qdma_h2c_port0_tready,

  input wire      [1-1:0] s_axis_qdma_h2c_port1_tvalid,
  input wire  [512*1-1:0] s_axis_qdma_h2c_port1_tdata,
  input wire   [64*1-1:0] s_axis_qdma_h2c_port1_tkeep,
  input wire      [1-1:0] s_axis_qdma_h2c_port1_tlast,
  input wire   [48*1-1:0] s_axis_qdma_h2c_port1_tuser,
  output wire     [1-1:0] s_axis_qdma_h2c_port1_tready,

  // To PCIe
  output wire     [1-1:0] m_axis_qdma_c2h_port0_tvalid,
  output wire [512*1-1:0] m_axis_qdma_c2h_port0_tdata,
  output wire  [64*1-1:0] m_axis_qdma_c2h_port0_tkeep,
  output wire     [1-1:0] m_axis_qdma_c2h_port0_tlast,
  output wire  [48*1-1:0] m_axis_qdma_c2h_port0_tuser,
  input wire      [1-1:0] m_axis_qdma_c2h_port0_tready,

  output wire     [1-1:0] m_axis_qdma_c2h_port1_tvalid,
  output wire [512*1-1:0] m_axis_qdma_c2h_port1_tdata,
  output wire  [64*1-1:0] m_axis_qdma_c2h_port1_tkeep,
  output wire     [1-1:0] m_axis_qdma_c2h_port1_tlast,
  output wire  [48*1-1:0] m_axis_qdma_c2h_port1_tuser,
  input wire      [1-1:0] m_axis_qdma_c2h_port1_tready,

  // To wire
  output wire     [1-1:0] m_axis_adap_tx_250mhz_port0_tvalid,
  output wire [512*1-1:0] m_axis_adap_tx_250mhz_port0_tdata,
  output wire  [64*1-1:0] m_axis_adap_tx_250mhz_port0_tkeep,
  output wire     [1-1:0] m_axis_adap_tx_250mhz_port0_tlast,
  output wire  [48*1-1:0] m_axis_adap_tx_250mhz_port0_tuser,
  input wire      [1-1:0] m_axis_adap_tx_250mhz_port0_tready,

  output wire     [1-1:0] m_axis_adap_tx_250mhz_port1_tvalid,
  output wire [512*1-1:0] m_axis_adap_tx_250mhz_port1_tdata,
  output wire  [64*1-1:0] m_axis_adap_tx_250mhz_port1_tkeep,
  output wire     [1-1:0] m_axis_adap_tx_250mhz_port1_tlast,
  output wire  [48*1-1:0] m_axis_adap_tx_250mhz_port1_tuser,
  input wire      [1-1:0] m_axis_adap_tx_250mhz_port1_tready,

  // From wire
  input wire      [1-1:0] s_axis_adap_rx_250mhz_port0_tvalid,
  input wire  [512*1-1:0] s_axis_adap_rx_250mhz_port0_tdata,
  input wire   [64*1-1:0] s_axis_adap_rx_250mhz_port0_tkeep,
  input wire      [1-1:0] s_axis_adap_rx_250mhz_port0_tlast,
  input wire   [48*1-1:0] s_axis_adap_rx_250mhz_port0_tuser,
  output wire     [1-1:0] s_axis_adap_rx_250mhz_port0_tready,

  input wire      [1-1:0] s_axis_adap_rx_250mhz_port1_tvalid,
  input wire  [512*1-1:0] s_axis_adap_rx_250mhz_port1_tdata,
  input wire   [64*1-1:0] s_axis_adap_rx_250mhz_port1_tkeep,
  input wire      [1-1:0] s_axis_adap_rx_250mhz_port1_tlast,
  input wire   [48*1-1:0] s_axis_adap_rx_250mhz_port1_tuser,
  output wire     [1-1:0] s_axis_adap_rx_250mhz_port1_tready,


  input wire                     mod_rstn,
  output wire                    mod_rst_done,

  input wire                     axil_aclk,
  input wire                     axis_aclk
);

  localparam NUM_INTF = 2;
  wire      [NUM_INTF-1:0] s_axis_qdma_h2c_tvalid;
  wire  [512*NUM_INTF-1:0] s_axis_qdma_h2c_tdata;
  wire   [64*NUM_INTF-1:0] s_axis_qdma_h2c_tkeep;
  wire      [NUM_INTF-1:0] s_axis_qdma_h2c_tlast;
  wire   [16*NUM_INTF-1:0] s_axis_qdma_h2c_tuser_size;
  wire   [16*NUM_INTF-1:0] s_axis_qdma_h2c_tuser_src;
  wire   [16*NUM_INTF-1:0] s_axis_qdma_h2c_tuser_dst;
  wire     [NUM_INTF-1:0] s_axis_qdma_h2c_tready;

  wire     [NUM_INTF-1:0] m_axis_qdma_c2h_tvalid;
  wire [512*NUM_INTF-1:0] m_axis_qdma_c2h_tdata;
  wire  [64*NUM_INTF-1:0] m_axis_qdma_c2h_tkeep;
  wire     [NUM_INTF-1:0] m_axis_qdma_c2h_tlast;
  wire  [16*NUM_INTF-1:0] m_axis_qdma_c2h_tuser_size;
  wire  [16*NUM_INTF-1:0] m_axis_qdma_c2h_tuser_src;
  wire  [16*NUM_INTF-1:0] m_axis_qdma_c2h_tuser_dst;
  wire      [NUM_INTF-1:0] m_axis_qdma_c2h_tready;

  wire     [NUM_INTF-1:0] m_axis_adap_tx_250mhz_tvalid;
  wire [512*NUM_INTF-1:0] m_axis_adap_tx_250mhz_tdata;
  wire  [64*NUM_INTF-1:0] m_axis_adap_tx_250mhz_tkeep;
  wire     [NUM_INTF-1:0] m_axis_adap_tx_250mhz_tlast;
  wire  [16*NUM_INTF-1:0] m_axis_adap_tx_250mhz_tuser_size;
  wire  [16*NUM_INTF-1:0] m_axis_adap_tx_250mhz_tuser_src;
  wire  [16*NUM_INTF-1:0] m_axis_adap_tx_250mhz_tuser_dst;
  wire      [NUM_INTF-1:0] m_axis_adap_tx_250mhz_tready;

  wire      [NUM_INTF-1:0] s_axis_adap_rx_250mhz_tvalid;
  wire  [512*NUM_INTF-1:0] s_axis_adap_rx_250mhz_tdata;
  wire   [64*NUM_INTF-1:0] s_axis_adap_rx_250mhz_tkeep;
  wire      [NUM_INTF-1:0] s_axis_adap_rx_250mhz_tlast;
  wire   [16*NUM_INTF-1:0] s_axis_adap_rx_250mhz_tuser_size;
  wire   [16*NUM_INTF-1:0] s_axis_adap_rx_250mhz_tuser_src;
  wire   [16*NUM_INTF-1:0] s_axis_adap_rx_250mhz_tuser_dst;
  wire     [NUM_INTF-1:0] s_axis_adap_rx_250mhz_tready;

  assign s_axis_qdma_h2c_tvalid = {s_axis_qdma_h2c_port1_tvalid, s_axis_qdma_h2c_port0_tvalid};
  assign s_axis_qdma_h2c_tdata = {s_axis_qdma_h2c_port1_tdata, s_axis_qdma_h2c_port0_tdata};
  assign s_axis_qdma_h2c_tkeep = {s_axis_qdma_h2c_port1_tkeep, s_axis_qdma_h2c_port0_tkeep};
  assign s_axis_qdma_h2c_tlast = {s_axis_qdma_h2c_port1_tlast, s_axis_qdma_h2c_port0_tlast};
  assign s_axis_qdma_h2c_tuser_size = {s_axis_qdma_h2c_port1_tuser[15:0], s_axis_qdma_h2c_port0_tuser[15:0]};
  assign s_axis_qdma_h2c_tuser_src = {s_axis_qdma_h2c_port1_tuser[31:16], s_axis_qdma_h2c_port0_tuser[31:16]};
  assign s_axis_qdma_h2c_tuser_dst = {s_axis_qdma_h2c_port1_tuser[47:32], s_axis_qdma_h2c_port0_tuser[47:32]};
  assign s_axis_qdma_h2c_port1_tready = s_axis_qdma_h2c_tready[1];
  assign s_axis_qdma_h2c_port0_tready = s_axis_qdma_h2c_tready[0];


  assign s_axis_adap_rx_250mhz_tvalid = {s_axis_adap_rx_250mhz_port1_tvalid, s_axis_adap_rx_250mhz_port0_tvalid};
  assign s_axis_adap_rx_250mhz_tdata = {s_axis_adap_rx_250mhz_port1_tdata, s_axis_adap_rx_250mhz_port0_tdata};
  assign s_axis_adap_rx_250mhz_tkeep = {s_axis_adap_rx_250mhz_port1_tkeep, s_axis_adap_rx_250mhz_port0_tkeep};
  assign s_axis_adap_rx_250mhz_tlast = {s_axis_adap_rx_250mhz_port1_tlast, s_axis_adap_rx_250mhz_port0_tlast};
  assign s_axis_adap_rx_250mhz_tuser_size = {s_axis_adap_rx_250mhz_port1_tuser[15:0], s_axis_adap_rx_250mhz_port0_tuser[15:0]};
  assign s_axis_adap_rx_250mhz_tuser_src = {s_axis_adap_rx_250mhz_port1_tuser[31:16], s_axis_adap_rx_250mhz_port0_tuser[31:16]};
  assign s_axis_adap_rx_250mhz_tuser_dst = {s_axis_adap_rx_250mhz_port1_tuser[47:32], s_axis_adap_rx_250mhz_port0_tuser[47:32]};
  assign s_axis_adap_rx_250mhz_port1_tready = s_axis_adap_rx_250mhz_tready[1];
  assign s_axis_adap_rx_250mhz_port0_tready = s_axis_adap_rx_250mhz_tready[0];


  assign m_axis_adap_tx_250mhz_port0_tvalid = m_axis_adap_tx_250mhz_tvalid[0];
  assign m_axis_adap_tx_250mhz_port0_tdata = m_axis_adap_tx_250mhz_tdata[511:0];
  assign m_axis_adap_tx_250mhz_port0_tkeep = m_axis_adap_tx_250mhz_tkeep[63:0];
  assign m_axis_adap_tx_250mhz_port0_tlast = m_axis_adap_tx_250mhz_tlast[0];
  assign m_axis_adap_tx_250mhz_port0_tuser[15:0] = m_axis_adap_tx_250mhz_tuser_size[15:0];
  assign m_axis_adap_tx_250mhz_port0_tuser[31:16] = m_axis_adap_tx_250mhz_tuser_src[15:0];
  assign m_axis_adap_tx_250mhz_port0_tuser[47:32] = m_axis_adap_tx_250mhz_tuser_dst[15:0];
  assign m_axis_adap_tx_250mhz_tready = {m_axis_adap_tx_250mhz_port1_tready, m_axis_adap_tx_250mhz_port0_tready};

  assign m_axis_adap_tx_250mhz_port1_tvalid = m_axis_adap_tx_250mhz_tvalid[1];
  assign m_axis_adap_tx_250mhz_port1_tdata = m_axis_adap_tx_250mhz_tdata[1023:512];
  assign m_axis_adap_tx_250mhz_port1_tkeep = m_axis_adap_tx_250mhz_tkeep[127:64];
  assign m_axis_adap_tx_250mhz_port1_tlast = m_axis_adap_tx_250mhz_tlast[1];
  assign m_axis_adap_tx_250mhz_port1_tuser[15:0] = m_axis_adap_tx_250mhz_tuser_size[31:16];
  assign m_axis_adap_tx_250mhz_port1_tuser[31:16] = m_axis_adap_tx_250mhz_tuser_src[31:16];
  assign m_axis_adap_tx_250mhz_port1_tuser[47:32] = m_axis_adap_tx_250mhz_tuser_dst[31:16];


  assign m_axis_qdma_c2h_port0_tvalid = m_axis_qdma_c2h_tvalid[0];
  assign m_axis_qdma_c2h_port0_tdata = m_axis_qdma_c2h_tdata[511:0];
  assign m_axis_qdma_c2h_port0_tkeep = m_axis_qdma_c2h_tkeep[63:0];
  assign m_axis_qdma_c2h_port0_tlast = m_axis_qdma_c2h_tlast[0];
  assign m_axis_qdma_c2h_port0_tuser[15:0] = m_axis_qdma_c2h_tuser_size[15:0];
  assign m_axis_qdma_c2h_port0_tuser[31:16] = m_axis_qdma_c2h_tuser_src[15:0];
  assign m_axis_qdma_c2h_port0_tuser[47:32] = m_axis_qdma_c2h_tuser_dst[15:0];
  assign m_axis_qdma_c2h_tready = {m_axis_qdma_c2h_port1_tready, m_axis_qdma_c2h_port0_tready};

  assign m_axis_qdma_c2h_port1_tvalid = m_axis_qdma_c2h_tvalid[1];
  assign m_axis_qdma_c2h_port1_tdata = m_axis_qdma_c2h_tdata[1023:512];
  assign m_axis_qdma_c2h_port1_tkeep = m_axis_qdma_c2h_tkeep[127:64];
  assign m_axis_qdma_c2h_port1_tlast = m_axis_qdma_c2h_tlast[1];
  assign m_axis_qdma_c2h_port1_tuser[15:0] = m_axis_qdma_c2h_tuser_size[31:16];
  assign m_axis_qdma_c2h_port1_tuser[31:16] = m_axis_qdma_c2h_tuser_src[31:16];
  assign m_axis_qdma_c2h_port1_tuser[47:32] = m_axis_qdma_c2h_tuser_dst[31:16];

  p2p_250mhz #(
    .NUM_INTF (2)
  ) p2p_250mhz_inst (
    .s_axil_awvalid                   (s_axil_awvalid),
    .s_axil_awaddr                    (s_axil_awaddr),
    .s_axil_awready                   (s_axil_awready),
    .s_axil_wvalid                    (s_axil_wvalid),
    .s_axil_wdata                     (s_axil_wdata),
    .s_axil_wready                    (s_axil_wready),
    .s_axil_bvalid                    (s_axil_bvalid),
    .s_axil_bresp                     (s_axil_bresp),
    .s_axil_bready                    (s_axil_bready),
    .s_axil_arvalid                   (s_axil_arvalid),
    .s_axil_araddr                    (s_axil_araddr),
    .s_axil_arready                   (s_axil_arready),
    .s_axil_rvalid                    (s_axil_rvalid),
    .s_axil_rdata                     (s_axil_rdata),
    .s_axil_rresp                     (s_axil_rresp),
    .s_axil_rready                    (s_axil_rready),

    .s_axis_qdma_h2c_tvalid           (s_axis_qdma_h2c_tvalid),
    .s_axis_qdma_h2c_tdata            (s_axis_qdma_h2c_tdata),
    .s_axis_qdma_h2c_tkeep            (s_axis_qdma_h2c_tkeep),
    .s_axis_qdma_h2c_tlast            (s_axis_qdma_h2c_tlast),
    .s_axis_qdma_h2c_tuser_size       (s_axis_qdma_h2c_tuser_size),
    .s_axis_qdma_h2c_tuser_src        (s_axis_qdma_h2c_tuser_src),
    .s_axis_qdma_h2c_tuser_dst        (s_axis_qdma_h2c_tuser_dst),
    .s_axis_qdma_h2c_tready           (s_axis_qdma_h2c_tready),

    .m_axis_qdma_c2h_tvalid           (m_axis_qdma_c2h_tvalid),
    .m_axis_qdma_c2h_tdata            (m_axis_qdma_c2h_tdata),
    .m_axis_qdma_c2h_tkeep            (m_axis_qdma_c2h_tkeep),
    .m_axis_qdma_c2h_tlast            (m_axis_qdma_c2h_tlast),
    .m_axis_qdma_c2h_tuser_size       (m_axis_qdma_c2h_tuser_size),
    .m_axis_qdma_c2h_tuser_src        (m_axis_qdma_c2h_tuser_src),
    .m_axis_qdma_c2h_tuser_dst        (m_axis_qdma_c2h_tuser_dst),
    .m_axis_qdma_c2h_tready           (m_axis_qdma_c2h_tready),

    .m_axis_adap_tx_250mhz_tvalid     (m_axis_adap_tx_250mhz_tvalid),
    .m_axis_adap_tx_250mhz_tdata      (m_axis_adap_tx_250mhz_tdata),
    .m_axis_adap_tx_250mhz_tkeep      (m_axis_adap_tx_250mhz_tkeep),
    .m_axis_adap_tx_250mhz_tlast      (m_axis_adap_tx_250mhz_tlast),
    .m_axis_adap_tx_250mhz_tuser_size (m_axis_adap_tx_250mhz_tuser_size),
    .m_axis_adap_tx_250mhz_tuser_src  (m_axis_adap_tx_250mhz_tuser_src),
    .m_axis_adap_tx_250mhz_tuser_dst  (m_axis_adap_tx_250mhz_tuser_dst),
    .m_axis_adap_tx_250mhz_tready     (m_axis_adap_tx_250mhz_tready),

    .s_axis_adap_rx_250mhz_tvalid     (s_axis_adap_rx_250mhz_tvalid),
    .s_axis_adap_rx_250mhz_tdata      (s_axis_adap_rx_250mhz_tdata),
    .s_axis_adap_rx_250mhz_tkeep      (s_axis_adap_rx_250mhz_tkeep),
    .s_axis_adap_rx_250mhz_tlast      (s_axis_adap_rx_250mhz_tlast),
    .s_axis_adap_rx_250mhz_tuser_size (s_axis_adap_rx_250mhz_tuser_size),
    .s_axis_adap_rx_250mhz_tuser_src  (s_axis_adap_rx_250mhz_tuser_src),
    .s_axis_adap_rx_250mhz_tuser_dst  (s_axis_adap_rx_250mhz_tuser_dst),
    .s_axis_adap_rx_250mhz_tready     (s_axis_adap_rx_250mhz_tready),

    .mod_rstn                         (mod_rstn),
    .mod_rst_done                     (mod_rst_done),

    .axil_aclk                        (axil_aclk),
    .axis_aclk                        (axis_aclk)
  );

endmodule: p2p_250mhz_wrapper