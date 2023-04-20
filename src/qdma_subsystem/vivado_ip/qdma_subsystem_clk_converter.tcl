# *************************************************************************
#
# Copyright 2023 AMD, Inc.
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
set axis_clock_converter qdma_subsystem_clk_converter
create_ip -name axis_clock_converter -vendor xilinx.com -library ip -version 1.1 -module_name $axis_clock_converter -dir ${ip_build_dir}
set_property -dict {
  CONFIG.HAS_TKEEP {1}
  CONFIG.HAS_TLAST {1}
  CONFIG.TDATA_NUM_BYTES {64}
  CONFIG.TUSER_WIDTH {16}
 } [get_ips $axis_clock_converter]