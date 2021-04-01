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
