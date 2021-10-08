# *************************************************************************
#
# Copyright 2020 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# *************************************************************************
set cmac_usplus cmac_usplus_1
create_ip -name cmac_usplus -vendor xilinx.com -library ip -module_name $cmac_usplus -dir ${ip_build_dir}
set_property -dict { 
    CONFIG.CMAC_CAUI4_MODE {1}
    CONFIG.NUM_LANES {4x25}
    CONFIG.GT_REF_CLK_FREQ {156.25}
    CONFIG.USER_INTERFACE {AXIS}
    CONFIG.GT_DRP_CLK {125.00}
    CONFIG.ENABLE_AXI_INTERFACE {1}
    CONFIG.INCLUDE_STATISTICS_COUNTERS {1}
    CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y7}
    CONFIG.GT_GROUP_SELECT {X1Y44~X1Y47}
    CONFIG.LANE1_GT_LOC {X1Y44}
    CONFIG.LANE2_GT_LOC {X1Y45}
    CONFIG.LANE3_GT_LOC {X1Y46}
    CONFIG.LANE4_GT_LOC {X1Y47}
    CONFIG.LANE5_GT_LOC {NA}
    CONFIG.LANE6_GT_LOC {NA}
    CONFIG.LANE7_GT_LOC {NA}
    CONFIG.LANE8_GT_LOC {NA}
    CONFIG.LANE9_GT_LOC {NA}
    CONFIG.LANE10_GT_LOC {NA}
    CONFIG.PLL_TYPE {QPLL1}
    CONFIG.INS_LOSS_NYQ {20}
    CONFIG.INCLUDE_RS_FEC {1}
    CONFIG.ENABLE_PIPELINE_REG {1}
    CONFIG.ETHERNET_BOARD_INTERFACE {qsfp1_4x}
    CONFIG.DIFFCLK_BOARD_INTERFACE {qsfp1_156mhz}
} [get_ips $cmac_usplus]
set_property CONFIG.RX_MIN_PACKET_LEN $min_pkt_len [get_ips $cmac_usplus]
set_property CONFIG.RX_MAX_PACKET_LEN $max_pkt_len [get_ips $cmac_usplus]
