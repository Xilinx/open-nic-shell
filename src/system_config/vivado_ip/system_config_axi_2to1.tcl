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
set axi_interconnect system_config_axi_2to1
create_ip -name axi_interconnect -vendor xilinx.com -library ip -module_name $axi_interconnect -dir ${ip_build_dir}
set_property -dict { 
   CONFIG.NUM_SLAVE_PORTS {2}
   CONFIG.S00_AXI_IS_ACLK_ASYNC {1}
   CONFIG.S01_AXI_IS_ACLK_ASYNC {1}
   CONFIG.M00_AXI_IS_ACLK_ASYNC {1}
   CONFIG.Component_Name {axi_interconnect_2to1}
   CONFIG.SYNCHRONIZATION_STAGES {2}
   CONFIG.S00_AXI_DATA_WIDTH {32}
   CONFIG.S01_AXI_DATA_WIDTH {32}
} [get_ips $axi_interconnect]
