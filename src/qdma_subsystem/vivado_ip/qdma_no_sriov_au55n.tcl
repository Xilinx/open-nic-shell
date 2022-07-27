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
set_property -dict {   
    CONFIG.mode_selection {Advanced} 
    CONFIG.pl_link_cap_max_link_width {X16} 
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} 
    CONFIG.en_transceiver_status_ports {false} 
    CONFIG.dsc_byp_mode {Descriptor_bypass_and_internal} 
    CONFIG.testname {st} CONFIG.dma_reset_source_sel {Phy_Ready} 
    CONFIG.pf0_bar2_scale_qdma {Megabytes} 
    CONFIG.pf0_bar2_size_qdma {1} 
    CONFIG.pf1_bar2_scale_qdma {Megabytes} 
    CONFIG.pf1_bar2_size_qdma {1} 
    CONFIG.pf2_bar2_scale_qdma {Megabytes} 
    CONFIG.pf2_bar2_size_qdma {1} 
    CONFIG.pf3_bar2_scale_qdma {Megabytes} 
    CONFIG.pf3_bar2_size_qdma {1} 
    CONFIG.pf0_device_id {903F} 
    CONFIG.pf2_device_id {923F} 
    CONFIG.pf3_device_id {933F} 
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {A03F} 
    CONFIG.PF1_SRIOV_VF_DEVICE_ID {A13F} 
    CONFIG.PF2_SRIOV_VF_DEVICE_ID {A23F} 
    CONFIG.PF3_SRIOV_VF_DEVICE_ID {A33F} 
    CONFIG.PF0_MSIX_CAP_TABLE_SIZE_qdma {009} 
    CONFIG.dma_intf_sel_qdma {AXI_Stream_with_Completion} 
    CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn}
    CONFIG.PCIE_BOARD_INTERFACE {pci_express_x16}
    CONFIG.en_axi_mm_qdma {false}
    CONFIG.xlnx_ref_board {AU55N}
    CONFIG.en_gt_selection {true} 
    CONFIG.select_quad {GTY_Quad_227}
    CONFIG.pcie_blk_locn {PCIE4C_X1Y1} 

} [get_ips $qdma]
set_property CONFIG.tl_pf_enable_reg $num_phys_func [get_ips $qdma]
set_property CONFIG.num_queues $num_queue [get_ips $qdma]
