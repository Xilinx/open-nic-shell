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
set axi_crossbar box_250mhz_axi_crossbar
create_ip -name axi_crossbar -vendor xilinx.com -library ip -module_name $axi_crossbar
set_property -dict { 
    CONFIG.PROTOCOL {AXI4LITE}
    CONFIG.M01_A00_BASE_ADDR {0x0000000000000080}
    CONFIG.M00_A00_ADDR_WIDTH {7}
    CONFIG.M01_A00_ADDR_WIDTH {7}
} [get_ips $axi_crossbar]
set_property CONFIG.NUM_MI [expr { 2*$num_phys_func + 1}] [get_ips $axi_crossbar]

if {$num_phys_func == 2} {
    set_property CONFIG.M02_A00_ADDR_WIDTH {7} [get_ips $axi_crossbar]
    set_property CONFIG.M03_A00_ADDR_WIDTH {7} [get_ips $axi_crossbar]
    set_property CONFIG.M04_A00_ADDR_WIDTH {12} [get_ips $axi_crossbar]
    set_property CONFIG.M02_A00_BASE_ADDR {0x0000000000000100} [get_ips $axi_crossbar]
    set_property CONFIG.M03_A00_BASE_ADDR {0x0000000000000180} [get_ips $axi_crossbar]
    set_property CONFIG.M04_A00_BASE_ADDR {0x0000000000001000} [get_ips $axi_crossbar]
} else {
    set_property CONFIG.M02_A00_ADDR_WIDTH {12} [get_ips $axi_crossbar]
    set_property CONFIG.M02_A00_BASE_ADDR {0x0000000000001000} [get_ips $axi_crossbar]
}
