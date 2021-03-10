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
set axis_register_slice axi_stream_pipeline
create_ip -name axis_register_slice -vendor xilinx.com -library ip -module_name $axis_register_slice -dir ${ip_build_dir}
set_property -dict { 
    CONFIG.TDATA_NUM_BYTES {64}
    CONFIG.TUSER_WIDTH {48}
    CONFIG.REG_CONFIG {16}
    CONFIG.HAS_TKEEP {1}
    CONFIG.HAS_TLAST {1}
} [get_ips $axis_register_slice]
