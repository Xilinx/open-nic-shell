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
// Address range: 0x0000 - 0x0FFF
// Address width: 12-bit
//
// Register description (0x0000 - 0x0FFF)
// -----------------------------------------------------------------------------
//  Address | Mode |          Description
// -----------------------------------------------------------------------------
//   0x000  |  RW  | Queue configuration register
//          |      | 
//          |      | 31:16 - Base queue ID
//          |      | 15:0  - Number of queues
// -----------------------------------------------------------------------------
//   0x400  |  RW  | RSS indirection table
//     |    |      | 
//   0x5FF  |      | 31:16 - reserved
//          |      | 15:0  - queue ID at index n
// -----------------------------------------------------------------------------
//   0x600  |  RW  | RSS hash key data register
//     |    |      | 
//   0x627  |      | 
// -----------------------------------------------------------------------------
//   0x800  |  RO  | TX packets from function
//   0x804  |      |
// -----------------------------------------------------------------------------
//   0x808  |  RO  | TX bytes from function
//   0x80C  |      |
// -----------------------------------------------------------------------------
//   0x900  |  RO  | RX packets into function
//   0x904  |      |
// -----------------------------------------------------------------------------
//   0x908  |  RO  | RX bytes into function
//   0x90C  |      |
// -----------------------------------------------------------------------------
`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module qdma_subsystem_function_register (
  input           s_axil_awvalid,
  input    [31:0] s_axil_awaddr,
  output          s_axil_awready,
  input           s_axil_wvalid,
  input    [31:0] s_axil_wdata,
  output          s_axil_wready,
  output          s_axil_bvalid,
  output    [1:0] s_axil_bresp,
  input           s_axil_bready,
  input           s_axil_arvalid,
  input    [31:0] s_axil_araddr,
  output          s_axil_arready,
  output          s_axil_rvalid,
  output   [31:0] s_axil_rdata,
  output    [1:0] s_axil_rresp,
  input           s_axil_rready,

  output   [15:0] q_base,
  output   [15:0] num_q,
  output [2047:0] indir_table,
  output  [319:0] hash_key,

  input           axil_aclk,
  input           axis_aclk,
  input           axil_aresetn
);

  `define DEFAULT_HKEY 320'h7C9C37DE18DC4386D9270F6F260374B8BFD0404B7872E224DC1B91BB011BA7A6376CC87ED6E31417

  localparam C_ADDR_W = 12;

  localparam REG_QCONF      = 12'h000;
  localparam REG_TABLE_BASE = 12'h400;
  localparam REG_TABLE_MASK = 12'h600;
  localparam REG_HKEY_BASE  = 12'h600;

  reg          [31:0] reg_qconf;
  reg          [15:0] reg_table[0:127];
  reg          [31:0] reg_hkey[0:9];

  wire                reg_en;
  wire                reg_we;
  wire [C_ADDR_W-1:0] reg_addr;
  wire         [31:0] reg_din;
  reg          [31:0] reg_dout;

  axi_lite_register #(
    .CLOCKING_MODE ("common_clock"),
    .ADDR_W        (C_ADDR_W),
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

    .axil_aclk      (axil_aclk),
    .axil_aresetn   (axil_aresetn),
    .reg_clk        (axil_aclk),
    .reg_rstn       (axil_aresetn)
  );

  always @(posedge axil_aclk) begin
    if (~axil_aresetn) begin
      reg_dout <= 0;
    end
    else if (reg_en && ~reg_we) begin
      if ((reg_addr & REG_TABLE_MASK) == REG_TABLE_BASE) begin
        reg_dout[15:0] <= reg_table[reg_addr[8:2]];
      end
      else if ((reg_addr >= REG_HKEY_BASE) && (reg_addr < REG_HKEY_BASE + (10 << 2))) begin
        for (int i = 0; i < 10; i++) begin
          if (((reg_addr - REG_HKEY_BASE) >> 2) == i) begin
            reg_dout <= reg_hkey[i];
            break;
          end
        end
      end
      else begin
        case (reg_addr)
          REG_QCONF: begin
            reg_dout <= reg_qconf;
          end
          default: begin
            reg_dout <= 32'hDEADBEEF;
          end
        endcase
      end
    end
  end

  always @(posedge axil_aclk) begin
    if (~axil_aresetn) begin
      reg_qconf <= 0;
    end
    else if (reg_en && reg_we && reg_addr == REG_QCONF) begin
      reg_qconf <= reg_din;
    end
  end

  assign q_base = reg_qconf[31:16];
  assign num_q  = reg_qconf[15:0];

  generate for (genvar i = 0; i < 128; i++) begin
    always @(posedge axil_aclk) begin
      if (~axil_aresetn) begin
        reg_table[i] <= 0;
      end
      else if (reg_en && reg_we && ((reg_addr & REG_TABLE_MASK) == REG_TABLE_BASE) && (reg_addr[8:2] == i)) begin
        reg_table[i] <= reg_din[15:0];
      end
    end

    assign indir_table[`getvec(16, i)] = reg_table[i];
  end
  endgenerate

  generate for (genvar i = 0; i < 10; i++) begin
    wire [319:0] shifted_hkey;

    assign shifted_hkey = (`DEFAULT_HKEY >> (i * 32));

    always @(posedge axil_aclk) begin
      if (~axil_aresetn) begin
        reg_hkey[i] <= shifted_hkey[31:0];
      end
      else if (reg_en && reg_we && ((reg_addr - REG_HKEY_BASE) >> 2) == i) begin
        reg_hkey[i] <= reg_din;
      end
    end

    assign hash_key[`getvec(32, i)] = reg_hkey[i];
  end
  endgenerate

endmodule: qdma_subsystem_function_register
