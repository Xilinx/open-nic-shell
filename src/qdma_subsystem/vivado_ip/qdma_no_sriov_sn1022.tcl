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
set qdma qdma_no_sriov
create_ip -name qdma -vendor xilinx.com -library ip -module_name $qdma -dir ${ip_build_dir}
set_property -dict [list \
  CONFIG.PCIE_BOARD_INTERFACE {Custom} \
  CONFIG.PF0_MSIX_CAP_TABLE_SIZE_qdma {009} \
  CONFIG.PF0_SRIOV_VF_DEVICE_ID {A03F} \
  CONFIG.PF1_MSIX_CAP_TABLE_SIZE_qdma {008} \
  CONFIG.PF1_SRIOV_VF_DEVICE_ID {A13F} \
  CONFIG.PF2_SRIOV_VF_DEVICE_ID {A23F} \
  CONFIG.PF3_SRIOV_VF_DEVICE_ID {A33F} \
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
  CONFIG.mode_selection {Advanced} \
  CONFIG.num_queues {512} \
  CONFIG.pcie_blk_locn {PCIE4C_X0Y0} \
  CONFIG.pf0_bar2_scale_qdma {Megabytes} \
  CONFIG.pf0_bar2_size_qdma {16} \
  CONFIG.pf0_device_id {903F} \
  CONFIG.pf1_bar2_scale_qdma {Megabytes} \
  CONFIG.pf1_bar2_size_qdma {16} \
  CONFIG.pf1_pciebar2axibar_2 {0x0000000000000000} \
  CONFIG.pf2_bar2_scale_qdma {Megabytes} \
  CONFIG.pf2_bar2_size_qdma {16} \
  CONFIG.pf2_device_id {923F} \
  CONFIG.pf3_bar2_scale_qdma {Megabytes} \
  CONFIG.pf3_bar2_size_qdma {16} \
  CONFIG.pf3_device_id {933F} \
  CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
  CONFIG.pl_link_cap_max_link_width {X16} \
  CONFIG.plltype {QPLL1} \
  CONFIG.select_quad {GTY_Quad_227} \
  CONFIG.testname {st} \
  CONFIG.tl_pf_enable_reg {2} \
  CONFIG.vsec_cap_addr {0xe00} \
  CONFIG.xlnx_ref_board {None} \
] [get_ips $qdma]
set_property CONFIG.tl_pf_enable_reg $num_phys_func [get_ips $qdma]
set_property CONFIG.num_queues $num_queue [get_ips $qdma]
