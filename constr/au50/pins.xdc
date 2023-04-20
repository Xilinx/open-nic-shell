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

# Gen3 x16 or Dual x8 Bifrucation on Lane 8-15: AB8(N)/AB9(P)
#	Note: This pair fails timing for PCIe QDMA x16 in this design.
#		[Place 30-739] the GT ref clock should be within 2 quads from all txvrs.
# Dual x8 Bifrucation on Lane 0-7 AF8(N)/AF9(P)
#	Note: The AU50 Vitis shell uses this pair, thus used here.

set_property PACKAGE_PIN AF8 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AF9 [get_ports pcie_refclk_p]

set_property -dict {PACKAGE_PIN AW27 IOSTANDARD LVCMOS18} [get_ports pcie_rstn]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN N37 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN N36 [get_ports qsfp_refclk_p[0]]

# for future implemenation 
#    set_property PACKAGE_PIN E18      [get_ports qsfp_activity_led[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_activity_led[0]]
#    set_property PACKAGE_PIN E16      [get_ports qsfp_link_stat_ledg[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledg[0]]
#    set_property PACKAGE_PIN F17      [get_ports qsfp_link_stat_ledy[0]]
#    set_property IOSTANDARD  LVCMOS18 [get_ports qsfp_link_stat_ledy[0]]
}
if {$num_ports >= 2} {
    puts "Alveo U50 has only one QSFP28 port, got $num_ports . Quitting"
	exit
}

# Fix the CATTRIP issue for custom flow
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18 PULLDOWN TRUE} [get_ports hbm_cattrip]

# Add satellite controller connections
set_property -dict {PACKAGE_PIN BB25 IOSTANDARD LVCMOS18} [get_ports satellite_uart_0_txd]
set_property -dict {PACKAGE_PIN BB26 IOSTANDARD LVCMOS18} [get_ports satellite_uart_0_rxd]
set_property -dict {PACKAGE_PIN C16  IOSTANDARD LVCMOS18} [get_ports satellite_gpio[0]]
set_property -dict {PACKAGE_PIN C17  IOSTANDARD LVCMOS18} [get_ports satellite_gpio[1]]

