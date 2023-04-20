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
set ips {
    qdma_no_sriov
    qdma_subsystem_clk_div
    qdma_subsystem_axi_cdc
    qdma_subsystem_axi_crossbar
    qdma_subsystem_c2h_ecc
}

if {$num_qdma > 1} {
    lappend ips "qdma_no_sriov_1"
    lappend ips "qdma_subsystem_clk_converter"
}