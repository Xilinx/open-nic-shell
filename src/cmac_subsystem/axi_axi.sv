// *************************************************************************
//
// Copyright 2023 Advanced Micro Devices
// Copyright 2021 Xilinx, Inc
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10/20/2021 11:57:47 AM
// Design Name: 
// Module Name: axi_axi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_axi (
    input clk,
    input reset_n,
    input block_lock,
    //AXIS Slave ports
    input s_axis_tvalid,
    input [511:0] s_axis_tdata,
    input [1:0] s_axis_tdest,
    input [1:0] s_axis_tid,
    input [63:0] s_axis_tkeep,
    input s_axis_tlast,
    input s_axis_tuser,
    output s_axis_tready,
    //AXIS Master ports
    output m_axis_tvalid,
    output [511:0] m_axis_tdata,
    output [1:0] m_axis_tdest,
    output [1:0] m_axis_tid,
    output [63:0] m_axis_tkeep,
    output m_axis_tlast,
    output m_axis_tuser,
    input  m_axis_tready
        
    );



reg drop_packets;


always@(posedge clk)
begin
    if (!reset_n)
    drop_packets <= 1'b0;
    else if (block_lock == 1'b0)
    drop_packets <= 1'b1;
    else if (block_lock == 1'b1 && s_axis_tvalid == 1'b1 && s_axis_tlast == 1'b1)
    drop_packets <= 1'b0;
end

assign m_axis_tvalid = drop_packets? 1'b0 : s_axis_tvalid;
assign m_axis_tlast = drop_packets? 1'b0 : s_axis_tlast;
assign m_axis_tdata = s_axis_tdata;
assign m_axis_tdest = s_axis_tdest;
assign m_axis_tid = s_axis_tid;
assign m_axis_tkeep = s_axis_tkeep;
assign m_axis_tuser = s_axis_tuser;

assign s_axis_tready = drop_packets? 1'b1: m_axis_tready;

endmodule
