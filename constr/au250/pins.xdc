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
set_property PACKAGE_PIN AM10 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AM11 [get_ports pcie_refclk_p]

set_property -dict {PACKAGE_PIN BD21 IOSTANDARD LVCMOS12} [get_ports pcie_rstn]

set num_ports [llength [get_ports qsfp_refclk_p]]
if {$num_ports >= 1} {
    set_property PACKAGE_PIN M10 [get_ports qsfp_refclk_n[0]]
    set_property PACKAGE_PIN M11 [get_ports qsfp_refclk_p[0]]

}
if {$num_ports >= 2} {
    set_property PACKAGE_PIN T10 [get_ports qsfp_refclk_n[1]]
    set_property PACKAGE_PIN T11 [get_ports qsfp_refclk_p[1]]

}

set_property -dict {PACKAGE_PIN BB19 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports satellite_uart_0_txd]
set_property -dict {PACKAGE_PIN BA19 IOSTANDARD LVCMOS12}         [get_ports satellite_uart_0_rxd]
set_property -dict {PACKAGE_PIN AR20 IOSTANDARD LVCMOS12}         [get_ports satellite_gpio[0]]
set_property -dict {PACKAGE_PIN AM20 IOSTANDARD LVCMOS12}         [get_ports satellite_gpio[1]]
set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS12}         [get_ports satellite_gpio[2]]
set_property -dict {PACKAGE_PIN AN21 IOSTANDARD LVCMOS12}         [get_ports satellite_gpio[3]]


# QSFP Control Signals
#       RESETL  - Active Low Reset output from FPGA to QSFP Module
#       MODPRSL - Active Low Module Present input from QSFP to FPGA
#       INTL    - Active Low Interrupt input from QSFP to FPGA
#       LPMODE  - Active High Control output from FPGA to QSFP Module to put the device in low power mode (Optics Off)
#       MODSEL  - Active Low Enable output from FPGA to QSFP Module to select device for I2C Sideband Communication
#
set_property -dict {PACKAGE_PIN BE17 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_resetl[0]  ]
set_property -dict {PACKAGE_PIN BE20 IOSTANDARD LVCMOS12       }  [get_ports qsfp_modprsl[0] ]
set_property -dict {PACKAGE_PIN BE21 IOSTANDARD LVCMOS12       }  [get_ports qsfp_intl[0]    ]
set_property -dict {PACKAGE_PIN BD18 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_lpmode[0]  ]
set_property -dict {PACKAGE_PIN BE16 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_modsell[0] ]
set_property -dict {PACKAGE_PIN BC18 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_resetl[1]  ]
set_property -dict {PACKAGE_PIN BC19 IOSTANDARD LVCMOS12       }  [get_ports qsfp_modprsl[1] ]
set_property -dict {PACKAGE_PIN AV21 IOSTANDARD LVCMOS12       }  [get_ports qsfp_intl[1]    ]
set_property -dict {PACKAGE_PIN AV22 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_lpmode[1]  ]
set_property -dict {PACKAGE_PIN AY20 IOSTANDARD LVCMOS12 DRIVE 8} [get_ports qsfp_modsell[1] ]
