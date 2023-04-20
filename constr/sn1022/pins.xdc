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
set_property PACKAGE_PIN AL9 [get_ports pcie_refclk_n[0]]
set_property PACKAGE_PIN AL10 [get_ports pcie_refclk_p[0]]

set_property PACKAGE_PIN AK18 [get_ports pcie_rstn[0]]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rstn[0]]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN G9 [get_ports dual0_gt_ref_clk_n]
    set_property PACKAGE_PIN G10 [get_ports dual0_gt_ref_clk_p]
    set_property PACKAGE_PIN J9 [get_ports dual1_gt_ref_clk_n]
    set_property PACKAGE_PIN J10 [get_ports dual1_gt_ref_clk_p]
}
if {$num_ports >= 2} {
    set_property PACKAGE_PIN P8 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN P9 [get_ports qsfp_refclk_p[1]]
}

#unplace all GTs
#unplace_cell [get_cells -hierarchical -filter {NAME =~ *qdma_wrapper_arm*gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST}]
#unplace_cell [get_cells -hierarchical -filter {NAME =~ *qdma_wrapper_inst*gen_channel_container[*].*gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST}]

unplace_cell [get_cells cmac_port[0].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/i_cmac_usplus_0_gtm/inst/dual0/gtm_dual_inst]
unplace_cell [get_cells cmac_port[0].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/i_cmac_usplus_0_gtm/inst/dual1/gtm_dual_inst]

##################################################################################################################################################################
#
#        		 GTY Lanes Connected to PCIe Edge Fingers			
#
##################################################################################################################################################################
set_property PACKAGE_PIN AF3                 [get_ports "pcie_rxn[0]"]                   ;# Bank 227 - MGTYRXN3_227
set_property PACKAGE_PIN AF4                 [get_ports "pcie_rxp[0]"]                   ;# Bank 227 - MGTYRXP3_227
set_property PACKAGE_PIN AT7                 [get_ports "pcie_rxn[10]"]                  ;# Bank 225 - MGTYRXN1_225
set_property PACKAGE_PIN AT8                 [get_ports "pcie_rxp[10]"]                  ;# Bank 225 - MGTYRXP1_225
set_property PACKAGE_PIN AU9                 [get_ports "pcie_rxn[11]"]                  ;# Bank 225 - MGTYRXN0_225
set_property PACKAGE_PIN AU10                [get_ports "pcie_rxp[11]"]                  ;# Bank 225 - MGTYRXP0_225
set_property PACKAGE_PIN AU13                [get_ports "pcie_rxn[12]"]                  ;# Bank 224 - MGTYRXN3_224
set_property PACKAGE_PIN AU14                [get_ports "pcie_rxp[12]"]                  ;# Bank 224 - MGTYRXP3_224
set_property PACKAGE_PIN AT15                [get_ports "pcie_rxn[13]"]                  ;# Bank 224 - MGTYRXN2_224
set_property PACKAGE_PIN AT16                [get_ports "pcie_rxp[13]"]                  ;# Bank 224 - MGTYRXP2_224
set_property PACKAGE_PIN AU17                [get_ports "pcie_rxn[14]"]                  ;# Bank 224 - MGTYRXN1_224
set_property PACKAGE_PIN AU18                [get_ports "pcie_rxp[14]"]                  ;# Bank 224 - MGTYRXP1_224
set_property PACKAGE_PIN AU21                [get_ports "pcie_rxn[15]"]                  ;# Bank 224 - MGTYRXN0_224
set_property PACKAGE_PIN AU22                [get_ports "pcie_rxp[15]"]                  ;# Bank 224 - MGTYRXP0_224
set_property PACKAGE_PIN AG1                 [get_ports "pcie_rxn[1]"]                   ;# Bank 227 - MGTYRXN2_227
set_property PACKAGE_PIN AG2                 [get_ports "pcie_rxp[1]"]                   ;# Bank 227 - MGTYRXP2_227
set_property PACKAGE_PIN AJ1                 [get_ports "pcie_rxn[2]"]                   ;# Bank 227 - MGTYRXN1_227
set_property PACKAGE_PIN AJ2                 [get_ports "pcie_rxp[2]"]                   ;# Bank 227 - MGTYRXP1_227
set_property PACKAGE_PIN AK3                 [get_ports "pcie_rxn[3]"]                   ;# Bank 227 - MGTYRXN0_227
set_property PACKAGE_PIN AK4                 [get_ports "pcie_rxp[3]"]                   ;# Bank 227 - MGTYRXP0_227
set_property PACKAGE_PIN AL1                 [get_ports "pcie_rxn[4]"]                   ;# Bank 226 - MGTYRXN3_226
set_property PACKAGE_PIN AL2                 [get_ports "pcie_rxp[4]"]                   ;# Bank 226 - MGTYRXP3_226
set_property PACKAGE_PIN AM3                 [get_ports "pcie_rxn[5]"]                   ;# Bank 226 - MGTYRXN2_226
set_property PACKAGE_PIN AM4                 [get_ports "pcie_rxp[5]"]                   ;# Bank 226 - MGTYRXP2_226
set_property PACKAGE_PIN AN1                 [get_ports "pcie_rxn[6]"]                   ;# Bank 226 - MGTYRXN1_226
set_property PACKAGE_PIN AN2                 [get_ports "pcie_rxp[6]"]                   ;# Bank 226 - MGTYRXP1_226
set_property PACKAGE_PIN AR1                 [get_ports "pcie_rxn[7]"]                   ;# Bank 226 - MGTYRXN0_226
set_property PACKAGE_PIN AR2                 [get_ports "pcie_rxp[7]"]                   ;# Bank 226 - MGTYRXP0_226
set_property PACKAGE_PIN AT3                 [get_ports "pcie_rxn[8]"]                   ;# Bank 225 - MGTYRXN3_225
set_property PACKAGE_PIN AT4                 [get_ports "pcie_rxp[8]"]                   ;# Bank 225 - MGTYRXP3_225
set_property PACKAGE_PIN AU5                 [get_ports "pcie_rxn[9]"]                   ;# Bank 225 - MGTYRXN2_225
set_property PACKAGE_PIN AU6                 [get_ports "pcie_rxp[9]"]                   ;# Bank 225 - MGTYRXP2_225
set_property PACKAGE_PIN AD7                 [get_ports "pcie_txn[0]"]                   ;# Bank 227 - MGTYTXN3_227
set_property PACKAGE_PIN AD8                 [get_ports "pcie_txp[0]"]                   ;# Bank 227 - MGTYTXP3_227
set_property PACKAGE_PIN AR9                 [get_ports "pcie_txn[10]"]                  ;# Bank 225 - MGTYTXN1_225
set_property PACKAGE_PIN AR10                [get_ports "pcie_txp[10]"]                  ;# Bank 225 - MGTYTXP1_225
set_property PACKAGE_PIN AT11                [get_ports "pcie_txn[11]"]                  ;# Bank 225 - MGTYTXN0_225
set_property PACKAGE_PIN AT12                [get_ports "pcie_txp[11]"]                  ;# Bank 225 - MGTYTXP0_225
set_property PACKAGE_PIN AR13                [get_ports "pcie_txn[12]"]                  ;# Bank 224 - MGTYTXN3_224
set_property PACKAGE_PIN AR14                [get_ports "pcie_txp[12]"]                  ;# Bank 224 - MGTYTXP3_224
set_property PACKAGE_PIN AR17                [get_ports "pcie_txn[13]"]                  ;# Bank 224 - MGTYTXN2_224
set_property PACKAGE_PIN AR18                [get_ports "pcie_txp[13]"]                  ;# Bank 224 - MGTYTXP2_224
set_property PACKAGE_PIN AT19                [get_ports "pcie_txn[14]"]                  ;# Bank 224 - MGTYTXN1_224
set_property PACKAGE_PIN AT20                [get_ports "pcie_txp[14]"]                  ;# Bank 224 - MGTYTXP1_224
set_property PACKAGE_PIN AR21                [get_ports "pcie_txn[15]"]                  ;# Bank 224 - MGTYTXN0_224
set_property PACKAGE_PIN AR22                [get_ports "pcie_txp[15]"]                  ;# Bank 224 - MGTYTXP0_224
set_property PACKAGE_PIN AE5                 [get_ports "pcie_txn[1]"]                   ;# Bank 227 - MGTYTXN2_227
set_property PACKAGE_PIN AE6                 [get_ports "pcie_txp[1]"]                   ;# Bank 227 - MGTYTXP2_227
set_property PACKAGE_PIN AG5                 [get_ports "pcie_txn[2]"]                   ;# Bank 227 - MGTYTXN1_227
set_property PACKAGE_PIN AG6                 [get_ports "pcie_txp[2]"]                   ;# Bank 227 - MGTYTXP1_227
set_property PACKAGE_PIN AH3                 [get_ports "pcie_txn[3]"]                   ;# Bank 227 - MGTYTXN0_227
set_property PACKAGE_PIN AH4                 [get_ports "pcie_txp[3]"]                   ;# Bank 227 - MGTYTXP0_227
set_property PACKAGE_PIN AJ5                 [get_ports "pcie_txn[4]"]                   ;# Bank 226 - MGTYTXN3_226
set_property PACKAGE_PIN AJ6                 [get_ports "pcie_txp[4]"]                   ;# Bank 226 - MGTYTXP3_226
set_property PACKAGE_PIN AL5                 [get_ports "pcie_txn[5]"]                   ;# Bank 226 - MGTYTXN2_226
set_property PACKAGE_PIN AL6                 [get_ports "pcie_txp[5]"]                   ;# Bank 226 - MGTYTXP2_226
set_property PACKAGE_PIN AN5                 [get_ports "pcie_txn[6]"]                   ;# Bank 226 - MGTYTXN1_226
set_property PACKAGE_PIN AN6                 [get_ports "pcie_txp[6]"]                   ;# Bank 226 - MGTYTXP1_226
set_property PACKAGE_PIN AP3                 [get_ports "pcie_txn[7]"]                   ;# Bank 226 - MGTYTXN0_226
set_property PACKAGE_PIN AP4                 [get_ports "pcie_txp[7]"]                   ;# Bank 226 - MGTYTXP0_226
set_property PACKAGE_PIN AP7                 [get_ports "pcie_txn[8]"]                   ;# Bank 225 - MGTYTXN3_225
set_property PACKAGE_PIN AP8                 [get_ports "pcie_txp[8]"]                   ;# Bank 225 - MGTYTXP3_225
set_property PACKAGE_PIN AR5                 [get_ports "pcie_txn[9]"]                   ;# Bank 225 - MGTYTXN2_225
set_property PACKAGE_PIN AR6                 [get_ports "pcie_txp[9]"]                   ;# Bank 225 - MGTYTXP2_225



##################################################################################################################################################################
#
#        		 GTM Lanes Connected to QSFP #0 Connector			
#
##################################################################################################################################################################
#set_property PACKAGE_PIN A12                 [get_ports "qsfp_rxn[0]"]              ;# Bank 234 - MGTMRXN0_234
#set_property PACKAGE_PIN A13                 [get_ports "qsfp_rxp[0]"]              ;# Bank 234 - MGTMRXP0_234
#set_property PACKAGE_PIN A15                 [get_ports "qsfp_rxn[1]"]              ;# Bank 234 - MGTMRXN1_234
#set_property PACKAGE_PIN A16                 [get_ports "qsfp_rxp[1]"]              ;# Bank 234 - MGTMRXP1_234
#
#set_property PACKAGE_PIN A6                  [get_ports "qsfp_rxn[2]"]              ;# Bank 233 - MGTMRXN0_233
#set_property PACKAGE_PIN A7                  [get_ports "qsfp_rxp[2]"]              ;# Bank 233 - MGTMRXP0_233
#set_property PACKAGE_PIN A9                  [get_ports "qsfp_rxn[3]"]              ;# Bank 233 - MGTMRXN1_233
#set_property PACKAGE_PIN A10                 [get_ports "qsfp_rxp[3]"]              ;# Bank 233 - MGTMRXP1_233
#
#set_property PACKAGE_PIN C14                 [get_ports "qsfp_txn[0]"]              ;# Bank 234 - MGTMTXN0_234
#set_property PACKAGE_PIN C15                 [get_ports "qsfp_txp[0]"]              ;# Bank 234 - MGTMTXP0_234
#set_property PACKAGE_PIN C17                 [get_ports "qsfp_txn[1]"]              ;# Bank 234 - MGTMTXN1_234
#set_property PACKAGE_PIN C18                 [get_ports "qsfp_txp[1]"]              ;# Bank 234 - MGTMTXP1_234
#
#set_property PACKAGE_PIN C8                  [get_ports "qsfp_txn[2]"]              ;# Bank 233 - MGTMTXN0_233
#set_property PACKAGE_PIN C9                  [get_ports "qsfp_txp[2]"]              ;# Bank 233 - MGTMTXP0_233
#set_property PACKAGE_PIN C11                 [get_ports "qsfp_txn[3]"]              ;# Bank 233 - MGTMTXN1_233
#set_property PACKAGE_PIN C12                 [get_ports "qsfp_txp[3]"]              ;# Bank 233 - MGTMTXP1_233



set_property PACKAGE_PIN A13 [get_ports {qsfp_rxp[0]}]
set_property PACKAGE_PIN C15 [get_ports {qsfp_txp[0]}]
set_property PACKAGE_PIN A16 [get_ports {qsfp_rxp[1]}]
set_property PACKAGE_PIN C18 [get_ports {qsfp_txp[1]}]
set_property PACKAGE_PIN A7  [get_ports {qsfp_rxp[2]}]
set_property PACKAGE_PIN C9  [get_ports {qsfp_txp[2]}]
set_property PACKAGE_PIN A10 [get_ports {qsfp_rxp[3]}]
set_property PACKAGE_PIN C12 [get_ports {qsfp_txp[3]}]

##################################################################################################################################################################
#
#        		 GTY Lanes Connected to QSFP #1 Connector			
#
##################################################################################################################################################################
set_property PACKAGE_PIN K3                  [get_ports "qsfp_rxn[4]"]              ;# Bank 231 - MGTYRXN0_231
set_property PACKAGE_PIN K4                  [get_ports "qsfp_rxp[4]"]              ;# Bank 231 - MGTYRXP0_231
set_property PACKAGE_PIN J1                  [get_ports "qsfp_rxn[5]"]              ;# Bank 231 - MGTYRXN1_231
set_property PACKAGE_PIN J2                  [get_ports "qsfp_rxp[5]"]              ;# Bank 231 - MGTYRXP1_231
set_property PACKAGE_PIN G1                  [get_ports "qsfp_rxn[6]"]              ;# Bank 231 - MGTYRXN2_231
set_property PACKAGE_PIN G2                  [get_ports "qsfp_rxp[6]"]              ;# Bank 231 - MGTYRXP2_231
set_property PACKAGE_PIN E1                  [get_ports "qsfp_rxn[7]"]              ;# Bank 231 - MGTYRXN3_231
set_property PACKAGE_PIN E2                  [get_ports "qsfp_rxp[7]"]              ;# Bank 231 - MGTYRXP3_231
set_property PACKAGE_PIN J6                  [get_ports "qsfp_txn[4]"]              ;# Bank 231 - MGTYTXN0_231
set_property PACKAGE_PIN J7                  [get_ports "qsfp_txp[4]"]              ;# Bank 231 - MGTYTXP0_231
set_property PACKAGE_PIN H4                  [get_ports "qsfp_txn[5]"]              ;# Bank 231 - MGTYTXN1_231
set_property PACKAGE_PIN H5                  [get_ports "qsfp_txp[5]"]              ;# Bank 231 - MGTYTXP1_231
set_property PACKAGE_PIN G6                  [get_ports "qsfp_txn[6]"]              ;# Bank 231 - MGTYTXN2_231
set_property PACKAGE_PIN G7                  [get_ports "qsfp_txp[6]"]              ;# Bank 231 - MGTYTXP2_231
set_property PACKAGE_PIN F4                  [get_ports "qsfp_txn[7]"]              ;# Bank 231 - MGTYTXN3_231
set_property PACKAGE_PIN F5                  [get_ports "qsfp_txp[7]"]              ;# Bank 231 - MGTYTXP3_231

################### ARM PCIe

set_property PACKAGE_PIN AJ17 [get_ports pcie_rstn[1]]
set_property -dict {IOSTANDARD LVCMOS18} [get_ports pcie_rstn[1]]

set_property PACKAGE_PIN AC9  [get_ports pcie_refclk_n[1]]
set_property PACKAGE_PIN AC10 [get_ports pcie_refclk_p[1]]

##### TEMP CHANGE  ################## ACTUAL #############
set_property PACKAGE_PIN AE2 [get_ports {pcie_rxp[16]}]
set_property PACKAGE_PIN AD4 [get_ports {pcie_txp[16]}]
set_property PACKAGE_PIN AC2 [get_ports {pcie_rxp[17]}]
set_property PACKAGE_PIN AC6 [get_ports {pcie_txp[17]}]
set_property PACKAGE_PIN AB4 [get_ports {pcie_rxp[18]}]
set_property PACKAGE_PIN AB8 [get_ports {pcie_txp[18]}]
set_property PACKAGE_PIN AA2 [get_ports {pcie_rxp[19]}]
set_property PACKAGE_PIN AA6 [get_ports {pcie_txp[19]}]
set_property PACKAGE_PIN Y4 [get_ports {pcie_rxp[20]}]
set_property PACKAGE_PIN Y8 [get_ports {pcie_txp[20]}]
set_property PACKAGE_PIN W2 [get_ports {pcie_rxp[21]}]
set_property PACKAGE_PIN W6 [get_ports {pcie_txp[21]}]
set_property PACKAGE_PIN V4 [get_ports {pcie_rxp[22]}]
set_property PACKAGE_PIN U7 [get_ports {pcie_txp[22]}]
set_property PACKAGE_PIN U2 [get_ports {pcie_rxp[23]}]
set_property PACKAGE_PIN R7 [get_ports {pcie_txp[23]}]

##### CMS PORTS #######
set_property -dict {PACKAGE_PIN AM17 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[0]]
set_property -dict {PACKAGE_PIN AL18 IOSTANDARD LVCMOS18} [get_ports satellite_gpio[1]]

set_property -dict {PACKAGE_PIN AK21 IOSTANDARD LVCMOS18} [get_ports satellite_uart_0_rxd]
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVCMOS18 DRIVE 4} [get_ports satellite_uart_0_txd]

## QSPI FLASH Interfaec
# set_property PACKAGE_PIN AH14 [get_ports spi_flash_io1_io]
# set_property PACKAGE_PIN AL14 [get_ports spi_flash_io2_io]
# set_property PACKAGE_PIN AL15 [get_ports spi_flash_io3_io]
# set_property PACKAGE_PIN AM15 [get_ports spi_flash_sck_io]
# set_property PACKAGE_PIN AK14 [get_ports spi_flash_ss_io]
# set_property PACKAGE_PIN AN15 [get_ports spi_flash_io0_io]

# set_property -dict {IOSTANDARD LVCMOS18}  [get_ports spi_flash_*]

