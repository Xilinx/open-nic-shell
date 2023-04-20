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
create_clock -period 10.000 -name pcie_refclk [get_ports pcie_refclk_p[0]]
create_clock -period 10.000 -name pcie_refclk_arm [get_ports pcie_refclk_p[1]]

set_false_path -through [get_ports pcie_rstn]

foreach axis_aclk [get_clocks -of_object [get_nets axis_aclk*]] {
    foreach cmac_clk [get_clocks -of_object [get_nets cmac_clk*]] {
        set_max_delay -datapath_only -from $axis_aclk -to $cmac_clk 4.000
        set_max_delay -datapath_only -from $cmac_clk -to $axis_aclk 3.103 
    }
}

#set_case_analysis 0 [get_pins {qdma_subsystem_inst/qdma_wrapper_arm/qdma_no_sriov_arm_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_arm_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[2]}]                         
#set_case_analysis 0 [get_pins {qdma_subsystem_inst/qdma_wrapper_arm/qdma_no_sriov_arm_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_arm_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[1]}]
#set_case_analysis 1 [get_pins {qdma_subsystem_inst/qdma_wrapper_arm/qdma_no_sriov_arm_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_arm_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[0]}]


#set_false_path -from [get_clocks -of_objects [get_pins qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]

########CKVS
#set_property USER_SLR_ASSIGNMENT SLR0 [get_cells dataPath_BD]
########CKVS
#set_max_delay -datapath_only -from [get_pins system_config_inst/scfg_reg_inst/reg_system_rst_reg/C] -to [get_pins dataPath_BD/arb_1/s00_couplers/auto_cc/inst/gen_async_conv.axisc_async_clock_converter_0/s_and_m_areset_r_reg/D] 8.0
#set_max_delay -datapath_only -from [get_pins {system_config_inst/scfg_reg_inst/shell_rst_last_reg[4]/C}] -to [get_pins dataPath_BD/bcam_egress_0/inst/obsnjpqboijpqbcejbcm14epseig/D] 8.0
#set_max_delay -datapath_only -from [get_pins {system_config_inst/scfg_reg_inst/shell_rst_last_reg[4]/C}] -to [get_pins dataPath_BD/bcam_ingress_0/inst/obsnjpqboijpqbcejbcm14epseig/D] 8.0
#set_max_delay -datapath_only -from [get_pins system_config_inst/scfg_reg_inst/reg_system_rst_reg_replica/C] -to [get_pins dataPath_BD/arb_0/s00_couplers/auto_cc/inst/gen_async_conv.axisc_async_clock_converter_0/s_and_m_areset_r_reg/D] 8.0
#set_max_delay -datapath_only -from [get_pins system_config_inst/scfg_reg_inst/reg_system_rst_reg_replica/C] -to [get_pins dataPath_BD/rxFIFO_1/s00_couplers/s00_regslice/inst/areset_r_reg/D] 8.0
#set_max_delay -datapath_only -from [get_pins system_config_inst/scfg_reg_inst/reg_system_rst_reg_replica/C] -to [get_pins dataPath_BD/bcam_egress_1/inst/obsnjpqboijpqbcejbcm14epseig/D] 8.0
#set_max_delay -datapath_only -from [get_pins system_config_inst/scfg_reg_inst/reg_system_rst_reg_replica/C] -to [get_pins dataPath_BD/bcam_ingress_1/inst/obsnjpqboijpqbcejbcm14epseig/D] 8.0


#CKVScreate_pblock pblock_packet_adapter_tx
#CKVSadd_cells_to_pblock [get_pblocks pblock_packet_adapter_tx] [get_cells -quiet {cmac_port*.packet_adapter_inst/tx_inst}]
#CKVSresize_pblock [get_pblocks pblock_packet_adapter_tx] -add {CLOCKREGION_X1Y8:CLOCKREGION_X2Y8}
#CKVS
#CKVScreate_pblock pblock_packet_adapter_rx
#CKVSadd_cells_to_pblock [get_pblocks pblock_packet_adapter_rx] [get_cells -quiet {cmac_port*.packet_adapter_inst/rx_inst}]
#CKVSresize_pblock [get_pblocks pblock_packet_adapter_rx] -add {CLOCKREGION_X5Y8:CLOCKREGION_X6Y8}
#CKVS
#CKVScreate_pblock pblock_qdma_subsystem
#CKVSadd_cells_to_pblock [get_pblocks pblock_qdma_subsystem] [get_cells -quiet [list qdma_subsystem_inst]]
#CKVSresize_pblock [get_pblocks pblock_qdma_subsystem] -add {SLR0}
#CKVS
#CKVScreate_pblock pblock_cmac_subsystem
#CKVSadd_cells_to_pblock [get_pblocks pblock_cmac_subsystem] [get_cells -quiet {cmac_port*.cmac_subsystem_inst}]
#CKVSadd_cells_to_pblock [get_pblocks pblock_cmac_subsystem] [get_cells -quiet {box_322mhz_inst}]
#CKVSresize_pblock [get_pblocks pblock_cmac_subsystem] -add {SLR2}
