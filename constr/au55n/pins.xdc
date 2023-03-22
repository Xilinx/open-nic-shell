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

set_property -dict {PACKAGE_PIN BF41 IOSTANDARD LVCMOS18} [get_ports pcie_rstn]

set_property PACKAGE_PIN AR14 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AR15 [get_ports pcie_refclk_p]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
#    IO pins AD42, AD43 are on IO Bank 130 for use with GTY X0Y24~27
    set_property PACKAGE_PIN AD43 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN AD42 [get_ports qsfp_refclk_p[0]]

#    set_property PACKAGE_PIN BL13     [get_ports qsfp_activity_led[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_activity_led[0]]
#    set_property PACKAGE_PIN BK11     [get_ports qsfp_link_stat_ledg[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledg[0]]
#    set_property PACKAGE_PIN BJ11     [get_ports qsfp_link_stat_ledy[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledy[0]]
}
if {$num_ports >= 2} {
#    IO pins AB43, AB42 are on IO Bank 131 for use with GTY X0Y28~31 
    set_property PACKAGE_PIN AB43 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN AB42 [get_ports qsfp_refclk_p[1]]

#    set_property PACKAGE_PIN BK14     [get_ports qsfp_activity_led[1]] 
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_activity_led[1]] 
#    set_property PACKAGE_PIN BK15     [get_ports qsfp_link_stat_ledg[1]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledg[1]]
#    set_property PACKAGE_PIN BL12     [get_ports qsfp_link_stat_ledy[1]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledy[1]]
}

# Fix the CATTRIP issue for custom flow
# Read AR72926 for details.
set_property -dict {PACKAGE_PIN BE45 IOSTANDARD LVCMOS18 PULLDOWN TRUE} [get_ports hbm_cattrip]

set_property -dict {PACKAGE_PIN BH42 IOSTANDARD LVCMOS18} [get_ports satellite_uart_0_txd]
set_property -dict {PACKAGE_PIN BJ42 IOSTANDARD LVCMOS18} [get_ports satellite_uart_0_rxd]
set_property -dict {PACKAGE_PIN BE46 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[0]]
set_property -dict {PACKAGE_PIN BH46 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[1]]
set_property -dict {PACKAGE_PIN BF45 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[2]]
set_property -dict {PACKAGE_PIN BF46 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[3]]




