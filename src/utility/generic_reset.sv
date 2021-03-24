// *************************************************************************
//    ____  ____
//   /   /\/   /
//  /___/  \  /
//  \   \   \/      Copyright 2019 Xilinx, Inc. All rights reserved.
//   \   \        This file contains confidential and proprietary
//   /   /        information of Xilinx, Inc. and is protected under U.S.
//  /___/   /\    and international copyright and other intellectual
//  \   \  /  \   property laws.
//   \___\/\___\
//
//
// *************************************************************************
//
// Disclaimer:
//
//       This disclaimer is not a license and does not grant any rights to
//       the materials distributed herewith. Except as otherwise provided in
//       a valid license issued to you by Xilinx, and to the maximum extent
//       permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE
//       "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
//       WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
//       INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
//       NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//       (2) Xilinx shall not be liable (whether in contract or tort,
//       including negligence, or under any other theory of liability) for
//       any loss or damage of any kind or nature related to, arising under
//       or in connection with these materials, including for any direct, or
//       any indirect, special, incidental, or consequential loss or damage
//       (including loss of data, profits, goodwill, or any type of loss or
//       damage suffered as a result of any action brought by a third party)
//       even if such damage or loss was reasonably foreseeable or Xilinx
//       had been advised of the possibility of the same.
//
// Critical Applications:
//
//       Xilinx products are not designed or intended to be fail-safe, or
//       for use in any application requiring fail-safe performance, such as
//       life-support or safety devices or systems, Class III medical
//       devices, nuclear facilities, applications related to the deployment
//       of airbags, or any other applications that could lead to death,
//       personal injury, or severe property or environmental damage
//       (individually and collectively, "Critical Applications"). Customer
//       assumes the sole risk and liability of any use of Xilinx products
//       in Critical Applications, subject only to applicable laws and
//       regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS
// FILE AT ALL TIMES.
//
// *************************************************************************
// This utility block takes a generic reset pair and generates a long-asserted
// reset signal for each input clock.
//
// The generated reset is asserted for `RESET_DURATION` cycles with respect to
// the slowest input clock.  If there is more than one input clock, the first
// one is assumed to be the slowest.
//
// The parameter `SAMPLE_CLK_INDEX` specifies which input clock `mod_rstn` and
// `mod_rst_done` are synchronized to.  It is not necessarily the slowest clock.
//
`timescale 1ns/1ps
module generic_reset #(
  parameter int NUM_INPUT_CLK    = 1,
  parameter int SAMPLE_CLK_INDEX = 0,
  parameter int RESET_DURATION   = 100
) (
  // Reset handshake signals from the system configuration block
  input                      mod_rstn,
  output                     mod_rst_done,

  // One reset generated for each clock domain
  input  [NUM_INPUT_CLK-1:0] clk,
  output [NUM_INPUT_CLK-1:0] rstn
);

  initial begin
    if (NUM_INPUT_CLK < 1 || NUM_INPUT_CLK > 16) begin
      $fatal("[%m] Number of input clocks should be within [1, 16]");
    end
    if (SAMPLE_CLK_INDEX >= NUM_INPUT_CLK) begin
      $fatal("[%m] Invalid value for SAMPLE_CLK_INDEX");
    end
    if (RESET_DURATION < 1 || RESET_DURATION > 65535) begin
      $fatal("[%m] Reset duration should be within [1, 65535]");
    end
  end

  localparam C_FLUSH_DURATION = 8;

  localparam S_IDLE  = 2'd0;
  localparam S_RESET = 2'd1;
  localparam S_FLUSH = 2'd2;

  wire       sample_clk;
  reg        reset_received = 1'b0;

  reg  [1:0] state_slowest_clk = S_IDLE;
  wire       slowest_clk;
  wire       reset_received_slowest_clk;
  reg        reset_done_slowest_clk = 1'b0;
  reg [15:0] reset_timer_slowest_clk = 0;

  assign sample_clk  = clk[SAMPLE_CLK_INDEX];
  assign slowest_clk = clk[0];

  always @(posedge sample_clk) begin
    if (~mod_rstn) begin
      reset_received <= 1'b1;
    end
    else if (mod_rst_done) begin
      reset_received <= 1'b0;
    end
  end

  generate if (SAMPLE_CLK_INDEX == 0) begin
    // Sample clock is the slowest input clock
    assign reset_received_slowest_clk = reset_received;
    assign mod_rst_done               = reset_done_slowest_clk;
  end
  else begin
    // Synchronize `reset_received` to the slowest input clock
    xpm_cdc_single #(
      .DEST_SYNC_FF  (2),
      .SRC_INPUT_REG (0)
    ) reset_received_sync_inst (
      .dest_clk (slowest_clk),
      .dest_out (reset_received_slowest_clk),
      .src_clk  (sample_clk),
      .src_in   (reset_received)
    );

    // Synchronize `reset_done_slowest_clk` back to the `sample_clk` domain
    xpm_cdc_single #(
      .DEST_SYNC_FF  (2),
      .SRC_INPUT_REG (0)
    ) reset_done_sync_inst (
      .dest_clk (sample_clk),
      .dest_out (mod_rst_done),
      .src_clk  (slowest_clk),
      .src_in   (reset_done_slowest_clk)
    );
  end
  endgenerate

  always @(posedge slowest_clk) begin
    case (state_slowest_clk)
      S_IDLE: begin
        if (reset_received_slowest_clk) begin
          reset_done_slowest_clk <= 1'b0;
          state_slowest_clk      <= S_RESET;
        end
      end

      S_RESET: begin
        if (reset_timer_slowest_clk >= RESET_DURATION) begin
          reset_done_slowest_clk  <= 1'b1;
          reset_timer_slowest_clk <= 0;
          state_slowest_clk       <= S_FLUSH;
        end
        else begin
          reset_timer_slowest_clk <= reset_timer_slowest_clk + 1;
        end
      end

      S_FLUSH: begin
        if (reset_timer_slowest_clk >= C_FLUSH_DURATION) begin
          reset_timer_slowest_clk <= 0;
          state_slowest_clk       <= S_IDLE;
        end
        else begin
          reset_timer_slowest_clk <= reset_timer_slowest_clk + 1;
        end
      end
    endcase
  end

  assign rstn[0] = ~(state_slowest_clk == S_RESET);

  generate for (genvar i = 1; i < NUM_INPUT_CLK; i++) begin
    // Synchronize reset from slowest clock to other clocks
    xpm_cdc_async_rst #(
      .DEST_SYNC_FF    (2),
      .RST_ACTIVE_HIGH (0)
    ) reset_sync_inst (
      .src_arst  (rstn[0]),
      .dest_arst (rstn[i]),
      .dest_clk  (clk[i])
    );
  end
  endgenerate

endmodule: generic_reset
