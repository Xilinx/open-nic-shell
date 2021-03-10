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
// Utility block that converts an AXI-Lite interface to simple register R/W
// signals.  The two interfaces can be configured to run under a common clock
// where signals are directly sampled, or independent clocks where CDC buffers
// are included to guarantee data validity.
`timescale 1ns/1ps
module axi_lite_register #(
  parameter     CLOCKING_MODE = "common_clock",
  parameter int ADDR_W        = 32,
  parameter int DATA_W        = 32
) (
  input               s_axil_awvalid,
  input  [ADDR_W-1:0] s_axil_awaddr,
  output              s_axil_awready,
  input               s_axil_wvalid,
  input  [DATA_W-1:0] s_axil_wdata,
  output              s_axil_wready,
  output              s_axil_bvalid,
  output        [1:0] s_axil_bresp,
  input               s_axil_bready,
  input               s_axil_arvalid,
  input  [ADDR_W-1:0] s_axil_araddr,
  output              s_axil_arready,
  output              s_axil_rvalid,
  output [DATA_W-1:0] s_axil_rdata,
  output        [1:0] s_axil_rresp,
  input               s_axil_rready,

  output              reg_en,
  output              reg_we,
  output [ADDR_W-1:0] reg_addr,
  output [DATA_W-1:0] reg_din,
  input  [DATA_W-1:0] reg_dout,

  input               axil_aclk,
  input               axil_aresetn,
  input               reg_clk,
  input               reg_rstn
);

  // AXI-Lite FSM
  localparam S_AXIL_WCH_IDLE = 3'd0;
  localparam S_AXIL_WCH_W    = 3'd1;
  localparam S_AXIL_WCH_AW   = 3'd2;
  localparam S_AXIL_WCH_B    = 3'd3;
  localparam S_AXIL_WCH_RET  = 3'd4;

  localparam S_AXIL_RCH_IDLE = 2'd0;
  localparam S_AXIL_RCH_RD   = 2'd1;
  localparam S_AXIL_RCH_RET  = 2'd2;

  // AXI-Lite signals
  //
  // For common-clock design, these signals are simply aliases to the slave
  // interface.  To enable multi-clock domain, an asynchronous FIFO should be
  // inserted to bridge the slave interface and these internal signals.
  wire              awvalid;
  wire [ADDR_W-1:0] awaddr;
  reg               awready;
  wire              wvalid;
  wire [DATA_W-1:0] wdata;
  reg               wready;
  reg               bvalid;
  reg         [1:0] bresp;
  wire              bready;
  wire              arvalid;
  wire [ADDR_W-1:0] araddr;
  reg               arready;
  reg               rvalid;
  reg  [DATA_W-1:0] rdata;
  reg         [1:0] rresp;
  wire              rready;

  // Read/write channels
  reg               wch_en;
  wire              wch_ack;
  reg  [ADDR_W-1:0] wch_addr;
  reg  [DATA_W-1:0] wch_din;
  reg               rch_en;
  wire              rch_ack;
  reg  [ADDR_W-1:0] rch_addr;
  wire [DATA_W-1:0] rch_dout;
  reg               reg_ack;

  reg         [2:0] wch_state;
  reg         [1:0] rch_state;

  generate if (CLOCKING_MODE == "common_clock") begin
    assign awvalid        = s_axil_awvalid;
    assign awaddr         = s_axil_awaddr;
    assign s_axil_awready = awready;
    assign wvalid         = s_axil_wvalid;
    assign wdata          = s_axil_wdata;
    assign s_axil_wready  = wready;
    assign s_axil_bvalid  = bvalid;
    assign s_axil_bresp   = bresp;
    assign bready         = s_axil_bready;
    assign arvalid        = s_axil_arvalid;
    assign araddr         = s_axil_araddr;
    assign s_axil_arready = arready;
    assign s_axil_rvalid  = rvalid;
    assign s_axil_rdata   = rdata;
    assign s_axil_rresp   = rresp;
    assign rready         = s_axil_rready;
  end
  else if (CLOCKING_MODE == "independent_clock") begin
    axi_lite_clock_converter clk_conv_inst (
      .s_axi_awaddr  (s_axil_awaddr),
      .s_axi_awprot  (0),
      .s_axi_awvalid (s_axil_awvalid),
      .s_axi_awready (s_axil_awready),
      .s_axi_wdata   (s_axil_wdata),
      .s_axi_wstrb   (4'hF),
      .s_axi_wvalid  (s_axil_wvalid),
      .s_axi_wready  (s_axil_wready),
      .s_axi_bvalid  (s_axil_bvalid),
      .s_axi_bresp   (s_axil_bresp),
      .s_axi_bready  (s_axil_bready),
      .s_axi_araddr  (s_axil_araddr),
      .s_axi_arprot  (0),
      .s_axi_arvalid (s_axil_arvalid),
      .s_axi_arready (s_axil_arready),
      .s_axi_rdata   (s_axil_rdata),
      .s_axi_rresp   (s_axil_rresp),
      .s_axi_rvalid  (s_axil_rvalid),
      .s_axi_rready  (s_axil_rready),

      .m_axi_awaddr  (awaddr),
      .m_axi_awprot  (),
      .m_axi_awvalid (awvalid),
      .m_axi_awready (awready),
      .m_axi_wdata   (wdata),
      .m_axi_wstrb   (),
      .m_axi_wvalid  (wvalid),
      .m_axi_wready  (wready),
      .m_axi_bvalid  (bvalid),
      .m_axi_bresp   (bresp),
      .m_axi_bready  (bready),
      .m_axi_araddr  (araddr),
      .m_axi_arprot  (),
      .m_axi_arvalid (arvalid),
      .m_axi_arready (arready),
      .m_axi_rdata   (rdata),
      .m_axi_rresp   (rresp),
      .m_axi_rvalid  (rvalid),
      .m_axi_rready  (rready),

      .s_axi_aclk    (axil_aclk),
      .s_axi_aresetn (axil_aresetn),
      .m_axi_aclk    (reg_clk),
      .m_axi_aresetn (reg_rstn)
    );
  end
  else begin
    initial begin
      $fatal("[%m] Unsupported clocking mode %s", CLOCKING_MODE);
    end
  end
  endgenerate

  always @(posedge reg_clk) begin
    if (~reg_rstn) begin
      reg_ack <= 1'b0;
    end
    else begin
      reg_ack <= reg_en;
    end
  end

  // Merge register read and write requests
  //
  // If there are write and read reqeust at the same time, read will be ignored
  // and invalid data will be returned to the read channel.
  assign reg_en   = rch_en || wch_en;
  assign reg_we   = wch_en;
  assign reg_addr = (wch_state != S_AXIL_WCH_IDLE) ? wch_addr : rch_addr;
  assign reg_din  = wch_din;
  assign rch_ack  = reg_ack;
  assign wch_ack  = reg_ack;
  assign rch_dout = reg_dout;

  // FSM for write transcations
  always @(posedge reg_clk) begin
    if (~reg_rstn) begin
      awready   <= 1'b1;
      wready    <= 1'b1;
      bvalid    <= 1'b0;
      bresp     <= 0;
      wch_en    <= 1'b0;
      wch_addr  <= 0;
      wch_din   <= 0;
      wch_state <= S_AXIL_WCH_IDLE;
    end
    else begin
      case (wch_state)

        S_AXIL_WCH_IDLE: begin
          if (awvalid && wvalid) begin
            awready   <= 1'b0;
            wch_addr  <= awaddr;
            wready    <= 1'b0;
            wch_en    <= 1'b1;
            wch_din   <= wdata;
            wch_state <= S_AXIL_WCH_B;
          end
          else if (awvalid && ~wvalid) begin
            awready   <= 1'b0;
            wch_addr  <= awaddr;
            wch_state <= S_AXIL_WCH_W;
          end
          else if (wvalid && ~awvalid) begin
            wready    <= 1'b0;
            wch_din   <= wdata;
            wch_state <= S_AXIL_WCH_AW;
          end
        end // case: S_AXIL_WCH_IDLE

        S_AXIL_WCH_W: begin
          if (wvalid) begin
            wready    <= 1'b0;
            wch_en    <= 1'b1;
            wch_din   <= wdata;
            wch_state <= S_AXIL_WCH_B;
          end
        end // case: S_AXIL_WCH_W

        S_AXIL_WCH_AW: begin
          if (awvalid) begin
            awready   <= 1'b0;
            wch_en    <= 1'b1;
            wch_addr  <= awaddr;
            wch_state <= S_AXIL_WCH_B;
          end
        end // case: S_AXIL_WCH_AW

        S_AXIL_WCH_B: begin
          wch_en <= 1'b0;
          if (wch_ack) begin
            bvalid    <= 1'b1;
            bresp     <= 0;
            wch_state <= S_AXIL_WCH_RET;
          end
        end

        S_AXIL_WCH_RET: begin
          if (bready) begin
            awready   <= 1'b1;
            wready    <= 1'b1;
            bvalid    <= 1'b0;
            wch_state <= S_AXIL_WCH_IDLE;
          end
        end

        default: begin
          awready   <= 1'b1;
          wready    <= 1'b1;
          bvalid    <= 1'b0;
          bresp     <= 0;
          wch_en    <= 1'b0;
          wch_addr  <= 0;
          wch_din   <= 0;
          wch_state <= S_AXIL_WCH_IDLE;
        end
      endcase
    end
  end

  // FSM for read transcations
  always @(posedge reg_clk) begin
    if (~reg_rstn) begin
      arready   <= 1'b1;
      rvalid    <= 1'b0;
      rdata     <= 0;
      rresp     <= 0;
      rch_en    <= 1'b0;
      rch_addr  <= 0;
      rch_state <= S_AXIL_RCH_IDLE;
    end
    else begin
      case (rch_state)

        S_AXIL_RCH_IDLE: begin
          if (arvalid) begin
            arready   <= 1'b0;
            rch_en    <= 1'b1;
            rch_addr  <= araddr;
            rch_state <= S_AXIL_RCH_RD;
          end
        end

        S_AXIL_RCH_RD: begin
          rch_en <= 1'b0;
          if (rch_ack) begin
            rvalid    <= 1'b1;
            rdata     <= rch_dout;
            rresp     <= 0;
            rch_state <= S_AXIL_RCH_RET;
          end
        end

        S_AXIL_RCH_RET: begin
          if (rready) begin
            arready   <= 1'b1;
            rvalid    <= 1'b0;
            rdata     <= 0;
            rresp     <= 0;
            rch_state <= S_AXIL_RCH_IDLE;
          end
        end

        default: begin
          arready   <= 1'b1;
          rvalid    <= 1'b0;
          rdata     <= 0;
          rresp     <= 0;
          rch_en    <= 1'b0;
          rch_addr  <= 0;
          rch_state <= S_AXIL_RCH_IDLE;
        end

      endcase
    end
  end

endmodule: axi_lite_register
