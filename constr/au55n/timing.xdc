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
create_clock -period 10.000 -name pcie_refclk [get_ports pcie_refclk_p]

set_false_path -through [get_ports pcie_rstn]

#create_pblock pblock_qdma_subsystem_inst
#add_cells_to_pblock [get_pblocks pblock_qdma_subsystem_inst] [get_cells -quiet [list qdma_subsystem_inst]]
#resize_pblock [get_pblocks pblock_qdma_subsystem_inst] -add {SLICE_X116Y0:SLICE_X232Y239}
#resize_pblock [get_pblocks pblock_qdma_subsystem_inst] -add {DSP48E2_X16Y0:DSP48E2_X31Y89}
#resize_pblock [get_pblocks pblock_qdma_subsystem_inst] -add {RAMB18_X8Y0:RAMB18_X13Y95}
#resize_pblock [get_pblocks pblock_qdma_subsystem_inst] -add {RAMB36_X8Y0:RAMB36_X13Y47}
#resize_pblock [get_pblocks pblock_qdma_subsystem_inst] -add {URAM288_X2Y0:URAM288_X4Y63}

#create_pblock pblock_1
#add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {cmac_port[0].cmac_subsystem_inst} {cmac_port[0].packet_adapter_inst}]]
#resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X0Y4:CLOCKREGION_X3Y7}

# pblock constraints for CMAC system
# create_pblock pblock_1
# add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list {cmac_port[0].cmac_subsystem_inst} {cmac_port[0].packet_adapter_inst}]]
# resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X0Y4:CLOCKREGION_X3Y7}

# pblock constraints for QDMA system
# create_pblock pblock_2
# add_cells_to_pblock [get_pblocks pblock_2] [get_cells -quiet [list qdma_subsystem_inst]]
# resize_pblock [get_pblocks pblock_2] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y3}

# Create pblocks for BCAMs
# create_pblock pblk_bcams
# add_cells_to_pblock [get_pblocks pblk_bcams] [get_cells -hierarchical -quiet [list gen_addr_stores[*].bcam_addr_store_inst bcam_kv_store_inst]]
# resize_pblock [get_pblocks pblk_bcams] -add {CLOCKREGION_X5Y0:CLOCKREGION_X7Y3}
