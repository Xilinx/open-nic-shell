# *************************************************************************
#
# Copyright 2023 Advanced Micro Devices
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

##################################################################
# CREATE IP vio_0_1
##################################################################

set vio_0_1 vio_0_1
create_ip -name vio -vendor xilinx.com -library ip -module_name vio_0_1 -dir ${ip_build_dir}

# User Parameters
set_property -dict [list \
  CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
  CONFIG.C_NUM_PROBE_IN {0} \
  CONFIG.C_PROBE_OUT0_INIT_VAL {0x1} \
] [get_ips vio_0_1]

# Runtime Parameters
#set_property -dict { 
#  GENERATE_SYNTH_CHECKPOINT {1}
#} $vio_0_1

##################################################################

