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
set egress_axis_switch box_250mhz_egress_axi_switch
create_ip -name axis_switch -vendor xilinx.com -library ip -module_name $egress_axis_switch
set_property -dict {
    CONFIG.ROUTING_MODE {1} 
    CONFIG.TDATA_NUM_BYTES {64} 
    CONFIG.HAS_TKEEP {1} 
    CONFIG.HAS_TLAST {1} 
    CONFIG.TUSER_WIDTH {48} 
    CONFIG.TDEST_WIDTH {0}
    CONFIG.DECODER_REG {1} 
    CONFIG.OUTPUT_REG {1}
 } [get_ips $egress_axis_switch]
set_property CONFIG.NUM_SI $num_qdma [get_ips $egress_axis_switch]

set ingress_axis_switch box_250mhz_ingress_axi_switch
create_ip -name axis_switch -vendor xilinx.com -library ip -module_name $ingress_axis_switch
set_property -dict {
    CONFIG.HAS_TKEEP {1}
    CONFIG.HAS_TLAST {1}
    CONFIG.NUM_SI {1}
    CONFIG.ROUTING_MODE {1}
    CONFIG.TDATA_NUM_BYTES {64}
    CONFIG.TUSER_WIDTH {48}
    CONFIG.TDEST_WIDTH {0}
 } [get_ips $ingress_axis_switch]
set_property CONFIG.NUM_MI $num_qdma [get_ips $ingress_axis_switch]