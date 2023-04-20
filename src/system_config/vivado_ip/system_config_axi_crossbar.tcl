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
set axi_crossbar system_config_axi_crossbar
create_ip -name axi_crossbar -vendor xilinx.com -library ip -module_name $axi_crossbar -dir ${ip_build_dir}
set_property -dict { 
    CONFIG.ADDR_RANGES {3}
    CONFIG.NUM_MI {12}
    CONFIG.PROTOCOL {AXI4LITE}
    CONFIG.M01_A00_BASE_ADDR {0x0000000000001000}
    CONFIG.M01_A01_BASE_ADDR {0x0000000000002000}
    CONFIG.M01_A02_BASE_ADDR {0x0000000000004000}
    CONFIG.M02_A00_BASE_ADDR {0x0000000000008000}
    CONFIG.M02_A01_BASE_ADDR {0x000000000000A000}
    CONFIG.M03_A00_BASE_ADDR {0x000000000000B000}
    CONFIG.M04_A00_BASE_ADDR {0x000000000000C000}
    CONFIG.M04_A01_BASE_ADDR {0x000000000000E000}
    CONFIG.M05_A00_BASE_ADDR {0x000000000000F000}
    CONFIG.M06_A00_BASE_ADDR {0x0000000000010000}
    CONFIG.M07_A00_BASE_ADDR {0x0000000000012000}
    CONFIG.M07_A01_BASE_ADDR {0x0000000000014000}
    CONFIG.M08_A00_BASE_ADDR {0x0000000000200000}
    CONFIG.M09_A00_BASE_ADDR {0x0000000000100000}
    CONFIG.M10_A00_BASE_ADDR {0x0000000000300000}
    CONFIG.M11_A00_BASE_ADDR {0x0000000000340000}
    CONFIG.M01_A00_ADDR_WIDTH {12}
    CONFIG.M01_A01_ADDR_WIDTH {13}
    CONFIG.M01_A02_ADDR_WIDTH {13}
    CONFIG.M02_A00_ADDR_WIDTH {13}
    CONFIG.M02_A01_ADDR_WIDTH {12}
    CONFIG.M03_A00_ADDR_WIDTH {12}
    CONFIG.M04_A00_ADDR_WIDTH {13}
    CONFIG.M04_A01_ADDR_WIDTH {12}
    CONFIG.M05_A00_ADDR_WIDTH {12}
    CONFIG.M06_A00_ADDR_WIDTH {13}
    CONFIG.M07_A00_ADDR_WIDTH {13}
    CONFIG.M07_A01_ADDR_WIDTH {12}
    CONFIG.M08_A00_ADDR_WIDTH {20}
    CONFIG.M09_A00_ADDR_WIDTH {20}
    CONFIG.M10_A00_ADDR_WIDTH {18}
    CONFIG.M11_A00_ADDR_WIDTH {12}    
} [get_ips $axi_crossbar]

set_property CONFIG.NUM_SI [expr {$num_qdma}] [get_ips $axi_crossbar]
