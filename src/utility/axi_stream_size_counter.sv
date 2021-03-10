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
// Count the number of bytes in a stream.  The output `size_valid` is asserted
// one cycle after `p_axis_tvalid`, `p_axis_tready` and `p_axis_tlast` are
// asserted, and `size` shows the total number of bytes.  It supports the
// calculation using either `p_axis_tkeep` or `p_axis_tuser_mty`.
`timescale 1ns/1ps
module axi_stream_size_counter #(
  parameter  int TDATA_W = 512,
  localparam int C_MTY_W = $clog2(TDATA_W / 8)
) (
  input                   p_axis_tvalid,
  input [(TDATA_W/8)-1:0] p_axis_tkeep,
  input                   p_axis_tlast,
  input     [C_MTY_W-1:0] p_axis_tuser_mty,
  input                   p_axis_tready,

  output reg              size_valid,
  output reg       [15:0] size,

  input                   aclk,
  input                   aresetn
);

  localparam C_SIZE = 1 << C_MTY_W;

  reg [15:0] acc;

  always @(posedge aclk) begin
    if (~aresetn) begin
      acc <= 0;
    end
    else if (p_axis_tvalid && p_axis_tready) begin
      acc <= (p_axis_tlast) ? 0 : (acc + C_SIZE);
    end
  end

  always @(posedge aclk) begin
    if (~aresetn) begin
      size_valid <= 1'b0;
      size       <= 0;
    end
    else if (p_axis_tvalid && p_axis_tlast && p_axis_tready) begin
      size_valid <= 1'b1;

      // Decide whether we use tkeep or mty for the calculation
      if (p_axis_tkeep == {(TDATA_W/8){1'b1}}) begin
        size <= acc + C_SIZE - p_axis_tuser_mty;
      end
      else begin
        for (int i = 0; i < (TDATA_W/8); i++) begin
          if (~p_axis_tkeep[i]) begin
            size <= acc + i;
            break;
          end
        end
      end
    end
    else begin
      size_valid <= 1'b0;
    end
  end

endmodule: axi_stream_size_counter
