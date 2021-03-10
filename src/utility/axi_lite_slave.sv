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
// A placeholder block for AXI-Lite register access
//
// This block serves as a sink for unused AXI-Lite interface.  On write, it
// completes the transaction immediately without writing into any real register.
// On read, it returns the read address (lower 16-bit) and a user-define prefix
// (upper 16-bit).
`timescale 1ns/1ps
module axi_lite_slave #(
  parameter int REG_ADDR_W = 12,
  parameter int REG_PREFIX = 0
)(
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

  input         aclk,
  input         aresetn
);

  wire                  reg_en;
  wire                  reg_we;
  wire [REG_ADDR_W-1:0] reg_addr;
  wire           [31:0] reg_din;
  reg            [31:0] reg_dout;

  axi_lite_register #(
    .CLOCKING_MODE ("common_clock"),
    .ADDR_W        (REG_ADDR_W),
    .DATA_W        (32)
  ) axil_reg_inst (
    .s_axil_awvalid (s_axil_awvalid),
    .s_axil_awaddr  (s_axil_awaddr),
    .s_axil_awready (s_axil_awready),
    .s_axil_wvalid  (s_axil_wvalid),
    .s_axil_wdata   (s_axil_wdata),
    .s_axil_wready  (s_axil_wready),
    .s_axil_bvalid  (s_axil_bvalid),
    .s_axil_bresp   (s_axil_bresp),
    .s_axil_bready  (s_axil_bready),
    .s_axil_arvalid (s_axil_arvalid),
    .s_axil_araddr  (s_axil_araddr),
    .s_axil_arready (s_axil_arready),
    .s_axil_rvalid  (s_axil_rvalid),
    .s_axil_rdata   (s_axil_rdata),
    .s_axil_rresp   (s_axil_rresp),
    .s_axil_rready  (s_axil_rready),

    .reg_en         (reg_en),
    .reg_we         (reg_we),
    .reg_addr       (reg_addr),
    .reg_din        (reg_din),
    .reg_dout       (reg_dout),

    .axil_aclk      (aclk),
    .axil_aresetn   (aresetn),
    .reg_clk        (aclk),
    .reg_rstn       (aresetn)
  );

  always @(posedge aclk) begin
    if (~aresetn) begin
      reg_dout <= 0;
    end
    else if (reg_en && ~reg_we) begin
      reg_dout[31:16] <= REG_PREFIX;
      reg_dout[15:0]  <= reg_addr;
    end
  end

endmodule: axi_lite_slave
