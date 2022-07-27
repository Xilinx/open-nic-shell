# *************************************************************************
#
# Copyright 2021 Xilinx, Inc.
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


set_property PACKAGE_PIN  BF41 [get_ports pcie_rstn]
set_property IOSTANDARD LVCMOS18  [get_ports pcie_rstn]

set_property PACKAGE_PIN AR14 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AR15 [get_ports pcie_refclk_p]

# Fix the CATTRIP issue for custom flow
# Read AR72926 for details.
set_property PACKAGE_PIN BE45 [get_ports hbm_cattrip]
set_property IOSTANDARD LVCMOS18 [get_ports hbm_cattrip]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN AD43 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN AD42 [get_ports qsfp_refclk_p[0]]
}
if {$num_ports >= 2} {
    set_property PACKAGE_PIN AB43 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN AB42 [get_ports qsfp_refclk_p[1]]
}

set axis_aclk [get_clocks -of_object [get_nets axis_aclk]]
foreach cmac_clk [get_clocks -of_object [get_nets cmac_clk*]] {
    set_max_delay -datapath_only -from $axis_aclk -to $cmac_clk 4.000
    set_max_delay -datapath_only -from $cmac_clk -to $axis_aclk 3.103
}



