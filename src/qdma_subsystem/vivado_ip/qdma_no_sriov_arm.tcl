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
# CREATE IP qdma_no_sriov_arm
##################################################################

set qdma_no_sriov_arm qdma_no_sriov_arm 
create_ip -name qdma -vendor xilinx.com -library ip -module_name qdma_no_sriov_arm -dir ${ip_build_dir}

# User Parameters
set_property -dict [list \
  CONFIG.INS_LOSS_NYQ {5} \
  CONFIG.PCIE_BOARD_INTERFACE {Custom} \
  CONFIG.PF0_MSIX_CAP_TABLE_SIZE_qdma {009} \
  CONFIG.PF0_SRIOV_VF_DEVICE_ID {A048} \
  CONFIG.PF1_MSIX_CAP_TABLE_SIZE_qdma {008} \
  CONFIG.PF1_SRIOV_VF_DEVICE_ID {A148} \
  CONFIG.PF2_SRIOV_VF_DEVICE_ID {A248} \
  CONFIG.PF3_SRIOV_VF_DEVICE_ID {A348} \
  CONFIG.SYS_RST_N_BOARD_INTERFACE {Custom} \
  CONFIG.axi_data_width {512_bit} \
  CONFIG.copy_pf0 {true} \
  CONFIG.coreclk_freq {500} \
  CONFIG.disable_gt_loc {true} \
  CONFIG.dma_intf_sel_qdma {AXI_Stream_with_Completion} \
  CONFIG.dma_reset_source_sel {Phy_Ready} \
  CONFIG.dsc_byp_mode {Descriptor_bypass_and_internal} \
  CONFIG.en_axi_mm_qdma {false} \
  CONFIG.en_gt_selection {false} \
  CONFIG.en_transceiver_status_ports {false} \
  CONFIG.ins_loss_profile {Chip-to-Chip} \
  CONFIG.mode_selection {Advanced} \
  CONFIG.num_queues {512} \
  CONFIG.pcie_blk_locn {PCIE4C_X0Y2} \
  CONFIG.pf0_bar2_scale_qdma {Megabytes} \
  CONFIG.pf0_bar2_size_qdma {16} \
  CONFIG.pf0_device_id {903f} \
  CONFIG.pf1_bar2_scale_qdma {Megabytes} \
  CONFIG.pf1_bar2_size_qdma {16} \
  CONFIG.pf1_device_id {913f} \
  CONFIG.pf1_pciebar2axibar_2 {0x0000000000000000} \
  CONFIG.pf2_bar2_scale_qdma {Megabytes} \
  CONFIG.pf2_bar2_size_qdma {16} \
  CONFIG.pf2_device_id {923F} \
  CONFIG.pf3_bar2_scale_qdma {Megabytes} \
  CONFIG.pf3_bar2_size_qdma {16} \
  CONFIG.pf3_device_id {9348} \
  CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} \
  CONFIG.pl_link_cap_max_link_width {X8} \
  CONFIG.plltype {QPLL0} \
  CONFIG.select_quad {GTY_Quad_231} \
  CONFIG.testname {st} \
  CONFIG.tl_pf_enable_reg {2} \
  CONFIG.vsec_cap_addr {0xe00} \
  CONFIG.xlnx_ref_board {None} \
] [get_ips qdma_no_sriov_arm]

# Runtime Parameters
#set_property -dict { 
#  GENERATE_SYNTH_CHECKPOINT {1}
#} $qdma_no_sriov_arm

##################################################################

