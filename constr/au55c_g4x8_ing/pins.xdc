

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
# PCIE_PERST_LS_65 
set_property PACKAGE_PIN BF41     [get_ports "pcie_rstn"] ;# Bank  65 VCCO - VCC1V8   - IO_T3U_N12_PERSTN0_65
set_property IOSTANDARD  LVCMOS18 [get_ports "pcie_rstn"] ;# Bank  65 VCCO - VCC1V8   - IO_T3U_N12_PERSTN0_65

# 0~7
set_property PACKAGE_PIN AL14 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AL15 [get_ports pcie_refclk_p]

# 8 ~15
# set_property PACKAGE_PIN AR14 [get_ports pcie_refclk_n]
# set_property PACKAGE_PIN AR15 [get_ports pcie_refclk_p]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN AD43 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN AD42 [get_ports qsfp_refclk_p[0]]
}
if {$num_ports >= 2} {
    set_property PACKAGE_PIN AB43 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN AB42 [get_ports qsfp_refclk_p[1]]
}



set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

#set_property PACKAGE_PIN BC7      [get_ports pcie_txp[15]] ;# Bank 224 - MGTYTXP0_224
#set_property PACKAGE_PIN BC11     [get_ports pcie_txp[14]] ;# Bank 224 - MGTYTXP1_224
#set_property PACKAGE_PIN BB9      [get_ports pcie_txp[13]] ;# Bank 224 - MGTYTXP2_224
#set_property PACKAGE_PIN BA11     [get_ports pcie_txp[12]] ;# Bank 224 - MGTYTXP3_224
#set_property PACKAGE_PIN AY9      [get_ports pcie_txp[11]] ;# Bank 225 - MGTYTXP0_225
#set_property PACKAGE_PIN AW11     [get_ports pcie_txp[10]] ;# Bank 225 - MGTYTXP1_225
#set_property PACKAGE_PIN AV9      [get_ports pcie_txp[9]] ;# Bank 225 - MGTYTXP2_225
#set_property PACKAGE_PIN AU7      [get_ports pcie_txp[8]] ;# Bank 225 - MGTYTXP3_225

set_property PACKAGE_PIN AU11     [get_ports pcie_txp[7]] ;# Bank 226 - MGTYTXP0_226
set_property PACKAGE_PIN AT9      [get_ports pcie_txp[6]] ;# Bank 226 - MGTYTXP1_226
set_property PACKAGE_PIN AR7      [get_ports pcie_txp[5]] ;# Bank 226 - MGTYTXP2_226
set_property PACKAGE_PIN AR11     [get_ports pcie_txp[4]] ;# Bank 226 - MGTYTXP3_226
set_property PACKAGE_PIN AP9      [get_ports pcie_txp[3]] ;# Bank 227 - MGTYTXP0_227
set_property PACKAGE_PIN AN11     [get_ports pcie_txp[2]] ;# Bank 227 - MGTYTXP1_227
set_property PACKAGE_PIN AM9      [get_ports pcie_txp[1]] ;# Bank 227 - MGTYTXP2_227
set_property PACKAGE_PIN AL11     [get_ports pcie_txp[0]] ;# Bank 227 - MGTYTXP3_227




# Fix the CATTRIP issue for custom flow
set_property PACKAGE_PIN BE45 [get_ports hbm_cattrip]
set_property IOSTANDARD LVCMOS18 [get_ports hbm_cattrip]

set_property PACKAGE_PIN AD51     [get_ports "qsfp_rxp[0]"] ;# Bank 130 - MGTYRXP0_130
set_property PACKAGE_PIN AC53     [get_ports "qsfp_rxp[1]"] ;# Bank 130 - MGTYRXP1_130
set_property PACKAGE_PIN AC49     [get_ports "qsfp_rxp[2]"] ;# Bank 130 - MGTYRXP2_130
set_property PACKAGE_PIN AB51     [get_ports "qsfp_rxp[3]"] ;# Bank 130 - MGTYRXP3_130

#set_property PACKAGE_PIN AA53     [get_ports "qsfp_rxp[4]"] ;# Bank 131 - MGTYRXP0_131
#set_property PACKAGE_PIN Y51      [get_ports "qsfp_rxp[5]"] ;# Bank 131 - MGTYRXP1_131
#set_property PACKAGE_PIN W53      [get_ports "qsfp_rxp[6]"] ;# Bank 131 - MGTYRXP2_131
#set_property PACKAGE_PIN V51      [get_ports "qsfp_rxp[7]"] ;# Bank 131 - MGTYRXP3_131

# set_property PACKAGE_PIN AD52     [get_ports "QSFP28_0_RX1_N"] ;# Bank 130 - MGTYRXN0_130
# set_property PACKAGE_PIN AC54     [get_ports "QSFP28_0_RX2_N"] ;# Bank 130 - MGTYRXN1_130
# set_property PACKAGE_PIN AC50     [get_ports "QSFP28_0_RX3_N"] ;# Bank 130 - MGTYRXN2_130
# set_property PACKAGE_PIN AB52     [get_ports "QSFP28_0_RX4_N"] ;# Bank 130 - MGTYRXN3_130
# set_property PACKAGE_PIN AD51     [get_ports "QSFP28_0_RX1_P"] ;# Bank 130 - MGTYRXP0_130
# set_property PACKAGE_PIN AC53     [get_ports "QSFP28_0_RX2_P"] ;# Bank 130 - MGTYRXP1_130
# set_property PACKAGE_PIN AC49     [get_ports "QSFP28_0_RX3_P"] ;# Bank 130 - MGTYRXP2_130
# set_property PACKAGE_PIN AB51     [get_ports "QSFP28_0_RX4_P"] ;# Bank 130 - MGTYRXP3_130
# set_property PACKAGE_PIN AD47     [get_ports "QSFP28_0_TX1_N"] ;# Bank 130 - MGTYTXN0_130
# set_property PACKAGE_PIN AC45     [get_ports "QSFP28_0_TX2_N"] ;# Bank 130 - MGTYTXN1_130
# set_property PACKAGE_PIN AB47     [get_ports "QSFP28_0_TX3_N"] ;# Bank 130 - MGTYTXN2_130
# set_property PACKAGE_PIN AA49     [get_ports "QSFP28_0_TX4_N"] ;# Bank 130 - MGTYTXN3_130
# set_property PACKAGE_PIN AD46     [get_ports "QSFP28_0_TX1_P"] ;# Bank 130 - MGTYTXP0_130
# set_property PACKAGE_PIN AC44     [get_ports "QSFP28_0_TX2_P"] ;# Bank 130 - MGTYTXP1_130
# set_property PACKAGE_PIN AB46     [get_ports "QSFP28_0_TX3_P"] ;# Bank 130 - MGTYTXP2_130
# set_property PACKAGE_PIN AA48     [get_ports "QSFP28_0_TX4_P"] ;# Bank 130 - MGTYTXP3_130
# 
# set_property PACKAGE_PIN AA54     [get_ports "QSFP28_1_RX1_N"] ;# Bank 131 - MGTYRXN0_131
# set_property PACKAGE_PIN Y52      [get_ports "QSFP28_1_RX2_N"] ;# Bank 131 - MGTYRXN1_131
# set_property PACKAGE_PIN W54      [get_ports "QSFP28_1_RX3_N"] ;# Bank 131 - MGTYRXN2_131
# set_property PACKAGE_PIN V52      [get_ports "QSFP28_1_RX4_N"] ;# Bank 131 - MGTYRXN3_131
# set_property PACKAGE_PIN AA53     [get_ports "QSFP28_1_RX1_P"] ;# Bank 131 - MGTYRXP0_131
# set_property PACKAGE_PIN Y51      [get_ports "QSFP28_1_RX2_P"] ;# Bank 131 - MGTYRXP1_131
# set_property PACKAGE_PIN W53      [get_ports "QSFP28_1_RX3_P"] ;# Bank 131 - MGTYRXP2_131
# set_property PACKAGE_PIN V51      [get_ports "QSFP28_1_RX4_P"] ;# Bank 131 - MGTYRXP3_131
# set_property PACKAGE_PIN AA45     [get_ports "QSFP28_1_TX1_N"] ;# Bank 131 - MGTYTXN0_131
# set_property PACKAGE_PIN Y47      [get_ports "QSFP28_1_TX2_N"] ;# Bank 131 - MGTYTXN1_131
# set_property PACKAGE_PIN W49      [get_ports "QSFP28_1_TX3_N"] ;# Bank 131 - MGTYTXN2_131
# set_property PACKAGE_PIN W45      [get_ports "QSFP28_1_TX4_N"] ;# Bank 131 - MGTYTXN3_131
# set_property PACKAGE_PIN AA44     [get_ports "QSFP28_1_TX1_P"] ;# Bank 131 - MGTYTXP0_131
# set_property PACKAGE_PIN Y46      [get_ports "QSFP28_1_TX2_P"] ;# Bank 131 - MGTYTXP1_131
# set_property PACKAGE_PIN W48      [get_ports "QSFP28_1_TX3_P"] ;# Bank 131 - MGTYTXP2_131
# set_property PACKAGE_PIN W44      [get_ports "QSFP28_1_TX4_P"] ;# Bank 131 - MGTYTXP3_131

