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

# This file should be read in as unmanaged Tcl constraints to enable the usage
# of if statement
set_property PACKAGE_PIN AM10 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AM11 [get_ports pcie_refclk_p]

set_property PACKAGE_PIN BD21 [get_ports pcie_rstn]
set_property IOSTANDARD LVCMOS12 [get_ports pcie_rstn]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN M10 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN M11 [get_ports qsfp_refclk_p[0]]
}
if {$num_ports >= 2} {
    set_property PACKAGE_PIN T10 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN T11 [get_ports qsfp_refclk_p[1]]
}
