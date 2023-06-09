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
    CONFIG.GT_REF_CLK_FREQ {161.1328125}
    CONFIG.USER_INTERFACE {AXIS}
    CONFIG.GT_DRP_CLK {125.00}
    CONFIG.ENABLE_AXI_INTERFACE {1}
    CONFIG.INCLUDE_STATISTICS_COUNTERS {1}
    CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y0}
    CONFIG.GT_GROUP_SELECT {X0Y28~X0Y31}
    CONFIG.LANE1_GT_LOC {X0Y28}
    CONFIG.LANE2_GT_LOC {X0Y29}
    CONFIG.LANE3_GT_LOC {X0Y30}
    CONFIG.LANE4_GT_LOC {X0Y31}
    CONFIG.LANE5_GT_LOC {NA}
    CONFIG.LANE6_GT_LOC {NA}
    CONFIG.LANE7_GT_LOC {NA}
    CONFIG.LANE8_GT_LOC {NA}
    CONFIG.LANE9_GT_LOC {NA}
    CONFIG.LANE10_GT_LOC {NA}
    CONFIG.PLL_TYPE {QPLL0}
    CONFIG.INS_LOSS_NYQ {20}
    CONFIG.INCLUDE_RS_FEC {1}
    CONFIG.ENABLE_PIPELINE_REG {1}
    CONFIG.DIFFCLK_BOARD_INTERFACE {Custom}
    CONFIG.ETHERNET_BOARD_INTERFACE {Custom}
} [get_ips $cmac_usplus]
set_property CONFIG.RX_MIN_PACKET_LEN $min_pkt_len [get_ips $cmac_usplus]
set_property CONFIG.RX_MAX_PACKET_LEN $max_pkt_len [get_ips $cmac_usplus]
