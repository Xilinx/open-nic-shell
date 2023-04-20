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
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 72.9 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN DISABLE [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]

set_false_path -from [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]

set_property MAX_FANOUT_MODE CLOCK_REGION [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1034_n_0}]
set_property FORCE_MAX_FANOUT 181 [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1034_n_0}]
set_property MAX_FANOUT_MODE CLOCK_REGION [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1035_n_0}]
set_property FORCE_MAX_FANOUT 202 [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1035_n_0}]
set_property MAX_FANOUT_MODE CLOCK_REGION [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1037_n_0}]
set_property FORCE_MAX_FANOUT 165 [get_nets {qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/rtl_wrapper_inst/dma_wrapper/dma_top/dma_enable.dma_dsc_eng/RAM_ENABLED.xpm_memory_sdpram_inst_loop[0].xpm_memory_sdpram_inst_i_1037_n_0}]
set_max_delay -from [get_clocks -of_objects [get_pins  qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] 10.000
set_false_path -from [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_false_path -from [get_clocks -of_objects [get_pins qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]]

set_false_path -from [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_false_path -from [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins qdma_if[0].qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]]

set_case_analysis 0 [get_pins {qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[2]}]
set_case_analysis 0 [get_pins {qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[1]}]
set_case_analysis 1 [get_pins {qdma_if[1].qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4c_ip_i/inst/qdma_no_sriov_1_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/DIV[0]}]
