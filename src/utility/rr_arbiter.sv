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
// This module implements a round-robin arbiter.  A request from channel k comes
// when `req[k]` is asserted.  It should keep asserted until the requested
// transaction is done.  The trasaction starts when `grant[k]` is asserted,
// which could happen in the same cycle as the assertion of `req[k]`.
//
// Once both `req[k] and `grant[k]` are asserted, the arbiter allocates the
// resource to channel k, and `grant[k]` remains hight until a single-cycle
// `fin[k]` is received.  The arbiter then release the resource and starts
// another round of allocation in the next cycle.
//
// A request cannot be canceled once its req bit is asserted.
//
// Resource is granted to a particular channel based on two criteria: 1)
// first-come-first-serve, and 2) least recently used (LRU).  When a request
// arrives, it will be queued if the resource is temporarily unavailable.  When
// multiple requests arrive at the same time, the LRU channel gets the resource
// if available, and others are pushed into the queue.  The queue tracks the
// relative arrival time, so that queued requests that arrived at the same time
// compete solely based on the LRU principle.
//
// Resource grant is guarded by the `ready` signal.  When `ready` deasserts, no
// grant will be given.
//
`timescale 1ns/1ps
module rr_arbiter #(
  parameter int N = 4
) (
  input      [N-1:0] req,
  input      [N-1:0] fin,
  output reg [N-1:0] grant,
  input              ready,

  input              clk,
  input              rstn
);
  
  localparam M      = $clog2(N);
  localparam S_IDLE = 1'd0;
  localparam S_BUSY = 1'd1;

  reg [N-1:0] valid_req;
  reg [N-1:0] granted;
  reg [N-1:0] pending;
  reg [N-1:0] prio[0:N-1];
  reg   [0:0] state;

  reg [N-1:0] next_granted;
  reg [N-1:0] next_pending;
  reg [N-1:0] next_prio[0:N-1];
  reg   [0:0] next_state;

  reg [N-1:0] queued;

  reg         q_wr_en;
  reg [N-1:0] q_din;
  reg         q_rd_en;
  reg [N-1:0] q_dout;
  wire        q_empty;
  wire        q_full;
  reg [N-1:0] q_mem[0:N-1];
  reg [M-1:0] q_wptr;
  reg [M-1:0] q_rptr;
  reg   [M:0] q_cnt;

  assign q_empty = (q_cnt == 0);
  assign q_full  = (q_cnt == N);
  assign q_dout  = q_mem[q_rptr];

  always @(posedge clk) begin
    if (~rstn) begin
      q_wptr <= 0;
      q_rptr <= 0;
      q_cnt  <= 0;
      for (int i = 0; i < N; i += 1) begin
        q_mem[i] <= 0;
      end
    end
    else if (q_wr_en && ~q_rd_en && ~q_full) begin
      q_wptr        <= q_wptr + 1;
      q_cnt         <= q_cnt + 1;
      q_mem[q_wptr] <= q_din;
    end
    else if (q_rd_en && ~q_wr_en && ~q_empty) begin
      q_rptr <= q_rptr + 1;
      q_cnt  <= q_cnt - 1;
    end
    else if (q_wr_en && q_rd_en) begin
      // When both read and write are asserted, write is fine even if queue is
      // full, as one entry will be read out; but read is only possible when
      // queue is not empty, as the written entry will not be available until
      // next cycle.  When queue is empty, only write takes effect, making the
      // count increment.
      q_wptr        <= q_wptr + 1;
      q_mem[q_wptr] <= q_din;
      if (~q_empty) begin
        q_rptr <= q_rptr + 1;
      end
      else begin
        q_cnt <= q_cnt + 1;
      end
    end
  end

  // Input requests are to be queued when
  // - Not all of them have been queued, and
  // - Either queue is not empty, indicating that there are requests arrived
  //   earlier, or there are still pending requests
  assign q_wr_en = (q_din != 0) && (~q_empty || (pending != 0));
  assign q_din   = req & ~queued;

  // `queued` tracks the channels that have been queued, including the one that
  // currently has the resource
  generate for (genvar i = 0; i < N; i += 1) begin
    always @(posedge clk) begin
      if (~rstn) begin
        queued[i] <= 0;
      end
      else if (req[i] && grant[i] && fin[i]) begin
        queued[i] <= 1'b0;
      end
      else if (~queued[i] && req[i]) begin
        queued[i] <= 1'b1;
      end
    end
  end
  endgenerate

  // Arbitration FSM
  //
  // The FSM uses the `pending` register to track requests that arrived at the
  // same time and have not yet finished.  In the idle state, it first computes
  // the requests that are eligable for arbitration, `valid_req`.  This is done
  // as follows.
  //
  // 1. If `pending` is non-zero, it means that at least one request is there.
  //    The FSM takes `pending` as `valid_req` and update `pending` when that
  //    request is done;
  // 2. If `pending` is zero and the queue is also empty, `valid_req` comes
  //    directly from the input;
  // 3. Otherwise, `valid_req` comes from the queue.
  //
  // Then granting follows the current priorities and is guarded by the `ready`
  // signal.  For single-cycle requests, i.e., `req` and `fin` at the same
  // cycle, the FSM stays at `S_IDLE`.
  //
  // In the `S_BUSY` state, the FSM simply tracks `fin` and moves back to
  // `S_IDLE` when the request finishes.
  //
  always @(*) begin
    q_rd_en      = 1'b0;
    valid_req    = 0;
    grant        = 0;

    next_granted = granted;
    next_pending = pending;
    next_state   = state;

    for (int k = 0; k < N; k += 1) begin
      next_prio[k] = prio[k];
    end

    case (state)
      S_IDLE: begin
        if (pending != 0) begin
          // Take pending requests
          valid_req = pending;
        end
        else if (q_empty) begin
          // No pending requests and queue is empty; take the input requests directly
          valid_req = q_din;
        end
        else begin
          // No pending requests and queue is not empty; read from the queue
          q_rd_en   = 1'b1;
          valid_req = q_dout;
        end

        for (int k = 0; k < N; k += 1) begin
          next_granted = valid_req & prio[k];

          if (next_granted != 0) begin
            for (int j = k; j < N - 1; j += 1) begin
              next_prio[j] = prio[j + 1];
            end
            next_prio[N - 1] = prio[k];
            break;
          end
        end

        for (int i = 0; i < N; i += 1) begin
          grant[i] = next_granted[i] && ready;
        end

        // Regardless whether `ready` is asserted, as long as we would like to
        // grant access to a channel, we should change the FSM state.  An
        // exception is that if `fin` is received at the same cycle that the
        // channel is granted access, we do not need to change state as the
        // packet has only one beat
        if (next_granted != 0) begin
          if ((fin & grant) == 0) begin
            next_pending = valid_req;
            next_state   = S_BUSY;
          end
          else begin
            next_pending = valid_req ^ fin;
          end
        end
      end

      S_BUSY: begin
        for (int i = 0; i < N; i += 1) begin
          grant[i] = granted[i] && ready;
        end

        if ((fin & grant) != 0) begin
          next_pending = pending ^ fin;
          next_granted = 0;
          next_state   = S_IDLE;
        end
      end
    endcase
  end

  always @(posedge clk) begin
    if (~rstn) begin
      granted <= 0;
      pending <= 0;
      state   <= S_IDLE;
      for (int k = 0; k < N; k += 1) begin
        prio[k] <= 1 << k;
      end
    end
    else begin
      granted <= next_granted;
      pending <= next_pending;
      state   <= next_state;
      for (int k = 0; k < N; k += 1) begin
        prio[k] <= next_prio[k];
      end
    end
  end

endmodule: rr_arbiter
