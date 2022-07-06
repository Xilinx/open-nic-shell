############################################################################
##	DISCLAIMER:
##  XILINX IS DISCLOSING THIS USER GUIDE, MANUAL, RELEASE NOTE,
##  SCHEMATIC, AND/OR SPECIFICATION (THE "DOCUMENTATION")TO YOU SOLELY
##  FOR USE IN THE DEVELOPMENT OF DESIGNS TO OPERATE WITH XILINX
##  HARDWARE DEVICES. YOU MAY NOT REPRODUCE, DISTRIBUTE, REPUBLISH,
##  DOWNLOAD, DISPLAY, POST, OR TRANSMIT THE DOCUMENTATION IN ANY FORM
##  OR BY ANY MEANS INCLUDING, BUT NOT LIMITED TO, ELECTRONIC,
##  MECHANICAL, PHOTOCOPYING, RECORDING, OR OTHERWISE, WITHOUT THE
##  PRIOR WRITTEN CONSENT OF XILINX. XILINX EXPRESSLY DISCLAIMS ANY
##  LIABILITY ARISING OUT OF YOUR USE OF THE DOCUMENTATION.
##  XILINX RESERVES THE RIGHT, AT ITS SOLE DISCRETION, TO CHANGE THE
##  DOCUMENTATION WITHOUT NOTICE AT ANY TIME. XILINX ASSUMES NO
##  OBLIGATION TO CORRECT ANY ERRORS CONTAINED IN THE DOCUMENTATION,
##  OR TO ADVISE YOU OF ANY CORRECTIONS OR UPDATES. XILINX EXPRESSLY
##  DISCLAIMS ANY LIABILITY IN CONNECTION WITH TECHNICAL SUPPORT OR
##  ASSISTANCETHAT MAY BE PROVIDED TO YOU IN CONNECTION WITH THE
##  DOCUMENTATION.
##  THE DOCUMENTATION IS DISCLOSED TO YOU "AS-IS" WITH NO WARRANTY OF
##  ANY OF THIRD-PARTY RIGHTS. IN NO EVENT WILL XILINXBE LIABLE FOR ANY
##  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
##  NONINFRINGEMENT STATUTORY, REGARDING THEDOCUMENTATION, INCLUDING
##  ANY WARRANTIES OF KIND.
##  XILINX MAKES NO OTHER WARRANTIES, WHETHER EXPRESS, IMPLIED, OR THE
##  DOCUMENTATION. INCLUDING ANY LOSS OF DATA OR LOST PROFITS, ARISING
##  FROM YOUR USE OF CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, OR
##  INCIDENTAL DAMAGES, INCLUDING ANY LOSS OF DATA OR LOST PROFITS,
##  ARISING FROM YOUR USE OF THE DOCUMENTATION.
##
##
##################################################################################################################################################################
##   U55N - Master XDC
##	 Revision 1.00 - Intial Release for U55N
##################################################################################################################################################################
##   Key Notes:
##       1) PCIe Clocks Support x16 and x8 Birfrucation with both syncronous or asyncronous operation
##       2) NA
##       3) NA
##################################################################################################################################################################
##    
##	Clock Trees
##
##    1) Si5394J - SiLabs Si5394B-A11828-GMR Programmable Oscillator (Re-programming I2C access via I2C_SI5394)
##    						   |
##     						   |-> OUT0  SYNCE_CLK0_P/SYNCE_CLK0_N 161.1328125 MHz - onboard QSFP Clock
##                             |   PINS: MGTREFCLK0P_130_AD42/MGTREFCLK0N_130_AD43
##                             |
##                             |-> OUT1 SYNCE_CLK1_P/SYNCE_CLK1_N 161.1328125 MHz - onboard QSFP Clock
##                             |   PINS: MGTREFCLK0P_131_AB42/MGTREFCLK0N_131_AB43
##                             |
##                             |-> OUT2  SI53306-B-GM-1:4 Low Jitter Clock Buffer
##                             |                    |
##                             |                    |-> OUT0  PCIE_SYSCLK0_P/PCIE_SYSCLK0_N 100.000Mhz - onboard PCIe SYSCLK0 Clock
##                             |                    |   PINS: MGTREFCLK1P_227_AK13/MGTREFCLK1N_227_AK12
##                             |                    |
##                             |                    |-> OUT1  PCIE_SYSCLK1_P/PCIE_SYSCLK1_N 100.000Mhz - onboard PCIe SYSCLK1 Clock
##                             |                    |   PINS: MGTREFCLK1P_225_AP13/MGTREFCLK1N_225_AP12
##                             |                    |
##                             |                    |-> OUT2  SYSCLK2_P/SYSCLK2_N 100.000Mhz - onboard SYSCLK2 Clock
##                             |                    |   PINS: IO_L11P_T1U_N8_GC_68_BK10/IO_L11N_T1U_N9_GC_68_BL10
##                             |                    |
##                             |                    |-> OUT3  SYSCLK3_P/SYSCLK3_N 100.000Mhz - onboard SYSCLK3 Clock
##                             |                        PINS: IO_L11P_T1U_N8_GC_A10_D26_65_BK43/IO_L11N_T1U_N9_GC_A11_D27_65_BK44
##                             |-> OUT3  SI53306-B-GM-1:4 Low Jitter Clock Buffer
##                                                  |
##                                                  |-> OUT0  Not Used
##                                                  |   
##                                                  |
##                                                  |-> OUT1  NS2_SYSCLK6_P/NS2_SYSCLK6_N 100.000Mhz - onboard SYSCLK6 Clock
##                                                  |   PINS: MGTREFCLK1P_125_AP42/MGTREFCLK1N_125_AP43
##                                                  |
##                                                  |-> OUT2  NS1_SYSCLK5_P/NS1_SYSCLK5_N 100.000Mhz - onboard SYSCLK5 Clock
##                                                  |   PINS: MGTREFCLK1P_127_AK42/MGTREFCLK1N_127_AK43
##                                                  |
##                                                  |-> OUT3  Not used            
##
##   2) PCIE Fingers PEX_REFCLK_P/PEX_REFCLK_P 100.000Mhz
##           |->  Si53102-A3-GMR --> OUT1  PCIE_REFCLK0_P/PCIE_REFCLK0_N 100.000Mhz - PCIe REFCLK0 for Bifrucated x8 Lanes 0-7 synchronous Clocking
##                             	 |   PINS: MGTREFCLK0P_227_AL15/MGTREFCLK0N_227_AL14
##                             	 |
##                             	 |-> OUT2  PCIE_REFCLK1_P/PCIE_REFCLK1_N 100.000Mhz - PCIe REFCLK0 for x16 and Bifrucated x8 Lanes 8-15 synchronous Clocking
##                                   PINS: MGTREFCLK0P_225_AR15/MGTREFCLK0N_225_AR14
##

##################################################################################################################################################################
##
##	Onboard Clocking
##
##################################################################################################################################################################                  
set_property PACKAGE_PIN BK44     [get_ports "SYSCLK3_N"] ;# Bank  65 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_A11_D27_65
set_property IOSTANDARD  LVDS 	  [get_ports "SYSCLK3_N"] ;# Bank  65 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_A11_D27_65
set_property PACKAGE_PIN BK43     [get_ports "SYSCLK3_P"] ;# Bank  65 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_A10_D26_65
set_property IOSTANDARD  LVDS 	  [get_ports "SYSCLK3_P"] ;# Bank  65 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_A10_D26_65
set_property PACKAGE_PIN BL10     [get_ports "SYSCLK2_N"] ;# Bank  68 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_68
set_property IOSTANDARD  LVDS 	  [get_ports "SYSCLK2_N"] ;# Bank  68 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_68
set_property PACKAGE_PIN BK10     [get_ports "SYSCLK2_P"] ;# Bank  68 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_68
set_property IOSTANDARD  LVDS 	  [get_ports "SYSCLK2_P"] ;# Bank  68 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_68
set_property PACKAGE_PIN BN42     [get_ports "TESTCLK_OUT"] ;# Bank  65 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_RS0_65
set_property IOSTANDARD  LVCMOS18 [get_ports "TESTCLK_OUT"] ;# Bank  65 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_RS0_65
set_property PACKAGE_PIN BJ33     [get_ports "PPS_IN_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_64
set_property IOSTANDARD  LVCMOS18 [get_ports "PPS_IN_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_64
set_property PACKAGE_PIN BH32     [get_ports "PPS_OUT_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_64
set_property IOSTANDARD  LVCMOS18 [get_ports "PPS_OUT_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_64
set_property PACKAGE_PIN AR41     [get_ports "NS2_REFCLK0_N"] ;# Bank 125 - MGTREFCLK0N_125
set_property PACKAGE_PIN AR40     [get_ports "NS2_REFCLK0_P"] ;# Bank 125 - MGTREFCLK0P_125
set_property PACKAGE_PIN AP43     [get_ports "NS2_SYSCLK6_N"] ;# Bank 125 - MGTREFCLK1N_125
set_property PACKAGE_PIN AP42     [get_ports "NS2_SYSCLK6_P"] ;# Bank 125 - MGTREFCLK1P_125
set_property PACKAGE_PIN AL41     [get_ports "NS1_REFCLK0_N"] ;# Bank 127 - MGTREFCLK0N_127
set_property PACKAGE_PIN AL40     [get_ports "NS1_REFCLK0_P"] ;# Bank 127 - MGTREFCLK0P_127
set_property PACKAGE_PIN AK43     [get_ports "NS1_SYSCLK5_N"] ;# Bank 127 - MGTREFCLK1N_127
set_property PACKAGE_PIN AK42     [get_ports "NS1_SYSCLK5_P"] ;# Bank 127 - MGTREFCLK1P_127
set_property PACKAGE_PIN AD43     [get_ports "SYNCE_CLK0_N"] ;# Bank 130 - MGTREFCLK0N_130
set_property PACKAGE_PIN AD42     [get_ports "SYNCE_CLK0_P"] ;# Bank 130 - MGTREFCLK0P_130
set_property PACKAGE_PIN AB43     [get_ports "SYNCE_CLK1_N"] ;# Bank 131 - MGTREFCLK0N_131
set_property PACKAGE_PIN AB42     [get_ports "SYNCE_CLK1_P"] ;# Bank 131 - MGTREFCLK0P_131
set_property PACKAGE_PIN AR14     [get_ports "PCIE_REFCLK1_N"] ;# Bank 225 - MGTREFCLK0N_225
set_property PACKAGE_PIN AR15     [get_ports "PCIE_REFCLK1_P"] ;# Bank 225 - MGTREFCLK0P_225
set_property PACKAGE_PIN AP12     [get_ports "PCIE_SYSCLK1_N"] ;# Bank 225 - MGTREFCLK1N_225
set_property PACKAGE_PIN AP13     [get_ports "PCIE_SYSCLK1_P"] ;# Bank 225 - MGTREFCLK1P_225
set_property PACKAGE_PIN AL14     [get_ports "PCIE_REFCLK0_N"] ;# Bank 227 - MGTREFCLK0N_227
set_property PACKAGE_PIN AL15     [get_ports "PCIE_REFCLK0_P"] ;# Bank 227 - MGTREFCLK0P_227
set_property PACKAGE_PIN AK12     [get_ports "PCIE_SYSCLK0_N"] ;# Bank 227 - MGTREFCLK1N_227
set_property PACKAGE_PIN AK13     [get_ports "PCIE_SYSCLK0_P"] ;# Bank 227 - MGTREFCLK1P_227
create_clock -period 10.000 -name SYSCLK3         [get_ports "SYSCLK3_P"]
create_clock -period 10.000 -name SYSCLK2         [get_ports "SYSCLK2_P"]
create_clock -period 10.000 -name TESTCLK         [get_ports "TESTCLK_OUT"]
create_clock -period 10.000 -name NS2REFCLK0      [get_ports "NS2_REFCLK0_P"]
create_clock -period 10.000 -name NS2SYSCLK6      [get_ports "NS2_SYSCLK6_P"]
create_clock -period 10.000 -name NS1REFCLK0      [get_ports "NS1_REFCLK0_P"]
create_clock -period 10.000 -name NS1SYSCLK5      [get_ports "NS1_SYSCLK5_P"]
create_clock -period 6.206  -name SYNCECLK0       [get_ports "SYNCE_CLK0_P"]
create_clock -period 6.206  -name SYNCECLK1       [get_ports "SYNCE_CLK1_P"]
create_clock -period 10.000 -name PCIEREFCLK1     [get_ports "PCIE_REFCLK1_P"]
create_clock -period 10.000 -name PCIESYSCLK1     [get_ports "PCIE_SYSCLK1_P"]
create_clock -period 10.000 -name PCIEREFCLK0     [get_ports "PCIE_REFCLK0_P"]
create_clock -period 10.000 -name PCIESYSCLK0     [get_ports "PCIE_SYSCLK0_P"]
##################################################################################################################################################################
##
##    SI_RSTBB           Active low reset output from FPGA to Si5394B input
##    SI_INTRB           Active low interrupt output from Si5394B to FPGA input
##    SI_PLL_LOCK        Active low PLL Loss of Lock output from Si5394B to FPGA input
##    SI_IN_LOS          Active low PLL Loss of Signal output from Si5394B to FPGA input
##    I2C_SI5394_SCLK    Master I2C clock connection from FPGA to Si5394B
##    I2C_SI5394_SDA     Master I2C data connection from FPGA to Si5394B##  	
##
##################################################################################################################################################################
set_property PACKAGE_PIN BM8      [get_ports "SI_RSTBB"] ;# Bank  68 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SI_RSTBB"] ;# Bank  68 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_68
set_property PACKAGE_PIN BM9      [get_ports "SI_INTRB"] ;# Bank  68 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SI_INTRB"] ;# Bank  68 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_68
set_property PACKAGE_PIN BN10     [get_ports "SI_PLL_LOCK"] ;# Bank  68 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SI_PLL_LOCK"] ;# Bank  68 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_68
set_property PACKAGE_PIN BM10     [get_ports "SI_IN_LOS"] ;# Bank  68 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "SI_IN_LOS"] ;# Bank  68 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_68
set_property PACKAGE_PIN BM14     [get_ports "I2C_SI5394_SCL"] ;# Bank  68 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "I2C_SI5394_SCL"] ;# Bank  68 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_68
set_property PACKAGE_PIN BN14     [get_ports "I2C_SI5394_SDA"] ;# Bank  68 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "I2C_SI5394_SDA"] ;# Bank  68 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_68
##################################################################################################################################################################
##
## 	HBM Catastrophic Over temperature Output signal to Satellite Controller
##  HBM_CATTRIP Active hgh indicator to Satellite controller to indicate the HBM has exceded its maximum allowable temperature.
##  This signal is not a dedicated FPGA output and is a derived signal in RTL. Making the signal Active will shut the FPGA power rails off.
##	PCIE_PERST_LS_65 Active low input from PCIe Connector to FPGA . 
## 	PEX_PWRBRKN_FPGA_65 Active low input from PCIe Connector Signaling PCIe card to shut down card power in Server failing condition.
##  PCIE_WAKE_FPGA Active low input from PCIe Connector
##	PCIE_PERST_LS_R Active low input from PCIe Connector to FPGA- Not Used in U55
##	PEX_PWRBRKN_FPGA_R	Active low input from PCIe Connector Signaling PCIe card to shut down card power in Server failing condition.Not used in U55 Board
##
##################################################################################################################################################################
set_property PACKAGE_PIN BE45     [get_ports "HBM_CATTRIP_LS"] ;# Bank  65 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_D04_65
set_property IOSTANDARD  LVCMOS18 [get_ports "HBM_CATTRIP_LS"] ;# Bank  65 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_D04_65
set_property PACKAGE_PIN BF41     [get_ports "PCIE_PERST_LS_65"] ;# Bank  65 VCCO - VCC1V8   - IO_T3U_N12_PERSTN0_65
set_property IOSTANDARD  LVCMOS18 [get_ports "PCIE_PERST_LS_65"] ;# Bank  65 VCCO - VCC1V8   - IO_T3U_N12_PERSTN0_65
set_property PACKAGE_PIN BG43     [get_ports "PEX_PWRBRKN_FPGA_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_D15_65
set_property IOSTANDARD  LVCMOS18 [get_ports "PEX_PWRBRKN_FPGA_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_D15_65
#set_property PACKAGE_PIN BP8      [get_ports "PCIE_PERST_LS_R"] ;# Bank  68 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "PCIE_PERST_LS_R"] ;# Bank  68 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_68
#set_property PACKAGE_PIN BN11     [get_ports "PEX_PWRBRKN_FPGA_R"] ;# Bank  68 VCCO - VCC1V8   - IO_T0U_N12_VRP_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "PEX_PWRBRKN_FPGA_R"] ;# Bank  68 VCCO - VCC1V8   - IO_T0U_N12_VRP_68
##################################################################################################################################################################
##
##  	CPU_RESET_FPGA Connects to SW1 push button On the top side of PCB Assembly, also connects to Satellite Contoller \ Desinged to be a active low reset input to the FPGA.
##  	RSTN_68 Satellite Contoller reset Signal.Pulling low reset the SC-- Not Used in U55
##
##################################################################################################################################################################
set_property PACKAGE_PIN BG45     [get_ports "CPU_RESET_FPGA"] ;# Bank  65 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_D13_65
set_property IOSTANDARD  LVCMOS18 [get_ports "CPU_RESET_FPGA"] ;# Bank  65 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_D13_65
#set_property PACKAGE_PIN BM12     [get_ports "RSTN_68"] ;# Bank  68 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "RSTN_68"] ;# Bank  68 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_68
###################################################################################################################################################################    
##    
##	  Bank 65 FPGA UART Interface 0/1/2 to DMB-01 (User selectable Baud)/ UART Interface 0/1 also avilable front pannel USB.When DMB is Not pluged  
##    FPGA_UART0/1/2_RXD  Input from DBM-01 UART to FPGA
##    FPGA_UART0/1/2_TXD  Output from FPGA to DBM-01 UART
##
##################################################################################################################################################################
set_property PACKAGE_PIN BK41     [get_ports "FPGA_UART0_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_A03_D19_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART0_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_A03_D19_65
set_property PACKAGE_PIN BJ41     [get_ports "FPGA_UART0_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_A02_D18_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART0_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_A02_D18_65
set_property PACKAGE_PIN BL46     [get_ports "FPGA_UART2_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_A17_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART2_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_A17_65
set_property PACKAGE_PIN BL45     [get_ports "FPGA_UART2_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_A16_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART2_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_A16_65
set_property PACKAGE_PIN BP47     [get_ports "FPGA_UART1_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L2N_T0L_N3_FWE_FCS2_B_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART1_RXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L2N_T0L_N3_FWE_FCS2_B_65
set_property PACKAGE_PIN BN47     [get_ports "FPGA_UART1_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L2P_T0L_N2_FOE_B_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_UART1_TXD"] ;# Bank  65 VCCO - VCC1V8   - IO_L2P_T0L_N2_FOE_B_65
##################################################################################################################################################################
##
## 	  Bank 94 FPGA to Sattelite Controller CMS UART Interface (115200, No parity, 8 bits, 1 stop bit)
##    FPGA_RXD_MSP_65  Input from Satellite Controller UART to FPGA
##    FPGA_TXD_MSP_65  Output from FPGA to Satellite Controller UART
##    This interface is used for the CMS command path, refer to https://www.xilinx.com/products/intellectual-property/cms-subsystem.html and Xilinx PG348
##	  FPGA_TXD_MSP_R/FPGA_RXD_MSP_R Not used in U55 Design.
##
##################################################################################################################################################################
#set_property PACKAGE_PIN BH12     [get_ports "FPGA_TXD_MSP_R"] ;# Bank  68 VCCO - VCC1V8   - IO_T2U_N12_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_TXD_MSP_R"] ;# Bank  68 VCCO - VCC1V8   - IO_T2U_N12_68
#set_property PACKAGE_PIN BH14     [get_ports "FPGA_RXD_MSP_R"] ;# Bank  68 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_68
#set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_RXD_MSP_R"] ;# Bank  68 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_68
set_property PACKAGE_PIN BJ42     [get_ports "FPGA_RXD_MSP_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_RXD_MSP_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
set_property PACKAGE_PIN BH42     [get_ports "FPGA_TXD_MSP_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_A06_D22_65
set_property IOSTANDARD  LVCMOS18 [get_ports "FPGA_TXD_MSP_65"] ;# Bank  65 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_A06_D22_65
##################################################################################################################################################################
##
##						General perpose IO interconnects between FPGA and Satellite Controller. 
##  					GPIO_0 > I/P TO FPGA FROM MSP  - POWER THROTTLE WARNING / GPIO_1 > I/P TO FPGA FROM MSP - POWER THROTTLE CRITICAL/ 
##						GPIO_2 > O/P TBD -TBD/GPIO_3 > TBD -TBD
##
##################################################################################################################################################################
set_property PACKAGE_PIN BE46     [get_ports "MSP_GPIO0"] ;# Bank  65 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_D05_65
set_property IOSTANDARD  LVCMOS18 [get_ports "MSP_GPIO0"] ;# Bank  65 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_D05_65
set_property PACKAGE_PIN BF46     [get_ports "MSP_GPIO3"] ;# Bank  65 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_D09_65
set_property IOSTANDARD  LVCMOS18 [get_ports "MSP_GPIO3"] ;# Bank  65 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_D09_65
set_property PACKAGE_PIN BF45     [get_ports "MSP_GPIO2"] ;# Bank  65 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_D08_65
set_property IOSTANDARD  LVCMOS18 [get_ports "MSP_GPIO2"] ;# Bank  65 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_D08_65
set_property PACKAGE_PIN BH46     [get_ports "MSP_GPIO1"] ;# Bank  65 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65
set_property IOSTANDARD  LVCMOS18 [get_ports "MSP_GPIO1"] ;# Bank  65 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65
##################################################################################################################################################################
##
##						
##    Near Stake connector sideband signals.
##
##################################################################################################################################################################
set_property PACKAGE_PIN BJ31     [get_ports "NS1_SMB_SCL"] ;# Bank  64 VCCO - VCC1V8   - IO_L24N_T3U_N11_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS1_SMB_SCL"] ;# Bank  64 VCCO - VCC1V8   - IO_L24N_T3U_N11_64
set_property PACKAGE_PIN BH31     [get_ports "NS1_SMB_SDA"] ;# Bank  64 VCCO - VCC1V8   - IO_L24P_T3U_N10_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS1_SMB_SDA"] ;# Bank  64 VCCO - VCC1V8   - IO_L24P_T3U_N10_64
set_property PACKAGE_PIN BG30     [get_ports "NS2_SMB_SCL"] ;# Bank  64 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS2_SMB_SCL"] ;# Bank  64 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_64
set_property PACKAGE_PIN BG29     [get_ports "NS2_SMB_SDA"] ;# Bank  64 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS2_SMB_SDA"] ;# Bank  64 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_64
#
set_property PACKAGE_PIN BF32     [get_ports "NS1_SMB_INT_RST"] ;# Bank  64 VCCO - VCC1V8   - IO_L23P_T3U_N8_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS1_SMB_INT_RST"] ;# Bank  64 VCCO - VCC1V8   - IO_L23P_T3U_N8_64
set_property PACKAGE_PIN BH35     [get_ports "NS2_SMB_INT_RST"] ;# Bank  64 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS2_SMB_INT_RST"] ;# Bank  64 VCCO - VCC1V8   - IO_L18N_T2U_N11_AD2N_64
set_property PACKAGE_PIN BJ29     [get_ports "NS1_SPARE1_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS1_SPARE1_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_64
set_property PACKAGE_PIN BF31     [get_ports "NS1_SPARE2_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS1_SPARE2_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_64
set_property PACKAGE_PIN BF36     [get_ports "NS2_SPARE1_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS2_SPARE1_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_64
set_property PACKAGE_PIN BK35     [get_ports "NS2_SPARE2_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_64
set_property IOSTANDARD  LVCMOS18 [get_ports "NS2_SPARE2_FPGA"] ;# Bank  64 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_64
##################################################################################################################################################################
##
##																// default illuminate //
##							QSFP28_*_ACTIVITY_LED	  Active high signal from FPGA to illuminate QSFP green Activity LED		
##							QSFP28_*_LINK_STAT_LEDG   Active high signal from FPGA to illuminate QSFP green Status LED 
##							QSFP28_*_LINK_STAT_LEDY   Active high signal from FPGA to illuminate QSFP yellow Status LED
##							
##################################################################################################################################################################
set_property PACKAGE_PIN BK14     [get_ports "QSFP28_1_ACTIVITY_LED"] ;# Bank  68 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_1_ACTIVITY_LED"] ;# Bank  68 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_68
set_property PACKAGE_PIN BK15     [get_ports "QSFP28_1_LINK_STAT_LEDG"] ;# Bank  68 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_1_LINK_STAT_LEDG"] ;# Bank  68 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_68
set_property PACKAGE_PIN BL12     [get_ports "QSFP28_1_LINK_STAT_LEDY"] ;# Bank  68 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_1_LINK_STAT_LEDY"] ;# Bank  68 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_68
set_property PACKAGE_PIN BL13     [get_ports "QSFP28_0_ACTIVITY_LED"] ;# Bank  68 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_0_ACTIVITY_LED"] ;# Bank  68 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_68
set_property PACKAGE_PIN BK11     [get_ports "QSFP28_0_LINK_STAT_LEDG"] ;# Bank  68 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_0_LINK_STAT_LEDG"] ;# Bank  68 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_68
set_property PACKAGE_PIN BJ11     [get_ports "QSFP28_0_LINK_STAT_LEDY"] ;# Bank  68 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_68
set_property IOSTANDARD  LVCMOS18 [get_ports "QSFP28_0_LINK_STAT_LEDY"] ;# Bank  68 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_68
##################################################################################################################################################################
##
##																QSFP28 MGTY Interface QUAD 124,125,126 and 127
##							
##################################################################################################################################################################
#set_property PACKAGE_PIN BC54     [get_ports "NS2_RX7_N"] ;# Bank 124 - MGTYRXN0_124
#set_property PACKAGE_PIN BB52     [get_ports "NS2_RX6_N"] ;# Bank 124 - MGTYRXN1_124
#set_property PACKAGE_PIN BA54     [get_ports "NS2_RX5_N"] ;# Bank 124 - MGTYRXN2_124
#set_property PACKAGE_PIN BA50     [get_ports "NS2_RX4_N"] ;# Bank 124 - MGTYRXN3_124
#set_property PACKAGE_PIN BC53     [get_ports "NS2_RX7_P"] ;# Bank 124 - MGTYRXP0_124
#set_property PACKAGE_PIN BB51     [get_ports "NS2_RX6_P"] ;# Bank 124 - MGTYRXP1_124
#set_property PACKAGE_PIN BA53     [get_ports "NS2_RX5_P"] ;# Bank 124 - MGTYRXP2_124
#set_property PACKAGE_PIN BA49     [get_ports "NS2_RX4_P"] ;# Bank 124 - MGTYRXP3_124
#set_property PACKAGE_PIN BC49     [get_ports "NS2_TX7_N"] ;# Bank 124 - MGTYTXN0_124
#set_property PACKAGE_PIN BC45     [get_ports "NS2_TX6_N"] ;# Bank 124 - MGTYTXN1_124
#set_property PACKAGE_PIN BB47     [get_ports "NS2_TX5_N"] ;# Bank 124 - MGTYTXN2_124
#set_property PACKAGE_PIN BA45     [get_ports "NS2_TX4_N"] ;# Bank 124 - MGTYTXN3_124
#set_property PACKAGE_PIN BC48     [get_ports "NS2_TX7_P"] ;# Bank 124 - MGTYTXP0_124
#set_property PACKAGE_PIN BC44     [get_ports "NS2_TX6_P"] ;# Bank 124 - MGTYTXP1_124
#set_property PACKAGE_PIN BB46     [get_ports "NS2_TX5_P"] ;# Bank 124 - MGTYTXP2_124
#set_property PACKAGE_PIN BA44     [get_ports "NS2_TX4_P"] ;# Bank 124 - MGTYTXP3_124
#set_property PACKAGE_PIN AY52     [get_ports "NS2_RX3_N"] ;# Bank 125 - MGTYRXN0_125
#set_property PACKAGE_PIN AW54     [get_ports "NS2_RX2_N"] ;# Bank 125 - MGTYRXN1_125
#set_property PACKAGE_PIN AW50     [get_ports "NS2_RX1_N"] ;# Bank 125 - MGTYRXN2_125
#set_property PACKAGE_PIN AV52     [get_ports "NS2_RX0_N"] ;# Bank 125 - MGTYRXN3_125
#set_property PACKAGE_PIN AY51     [get_ports "NS2_RX3_P"] ;# Bank 125 - MGTYRXP0_125
#set_property PACKAGE_PIN AW53     [get_ports "NS2_RX2_P"] ;# Bank 125 - MGTYRXP1_125
#set_property PACKAGE_PIN AW49     [get_ports "NS2_RX1_P"] ;# Bank 125 - MGTYRXP2_125
#set_property PACKAGE_PIN AV51     [get_ports "NS2_RX0_P"] ;# Bank 125 - MGTYRXP3_125
#set_property PACKAGE_PIN AY47     [get_ports "NS2_TX3_N"] ;# Bank 125 - MGTYTXN0_125
#set_property PACKAGE_PIN AW45     [get_ports "NS2_TX2_N"] ;# Bank 125 - MGTYTXN1_125
#set_property PACKAGE_PIN AV47     [get_ports "NS2_TX1_N"] ;# Bank 125 - MGTYTXN2_125
#set_property PACKAGE_PIN AU45     [get_ports "NS2_TX0_N"] ;# Bank 125 - MGTYTXN3_125
#set_property PACKAGE_PIN AY46     [get_ports "NS2_TX3_P"] ;# Bank 125 - MGTYTXP0_125
#set_property PACKAGE_PIN AW44     [get_ports "NS2_TX2_P"] ;# Bank 125 - MGTYTXP1_125
#set_property PACKAGE_PIN AV46     [get_ports "NS2_TX1_P"] ;# Bank 125 - MGTYTXP2_125
#set_property PACKAGE_PIN AU44     [get_ports "NS2_TX0_P"] ;# Bank 125 - MGTYTXP3_125
#set_property PACKAGE_PIN AU54     [get_ports "NS1_RX7_N"] ;# Bank 126 - MGTYRXN0_126
#set_property PACKAGE_PIN AT52     [get_ports "NS1_RX6_N"] ;# Bank 126 - MGTYRXN1_126
#set_property PACKAGE_PIN AR54     [get_ports "NS1_RX5_N"] ;# Bank 126 - MGTYRXN2_126
#set_property PACKAGE_PIN AP52     [get_ports "NS1_RX4_N"] ;# Bank 126 - MGTYRXN3_126
#set_property PACKAGE_PIN AU53     [get_ports "NS1_RX7_P"] ;# Bank 126 - MGTYRXP0_126
#set_property PACKAGE_PIN AT51     [get_ports "NS1_RX6_P"] ;# Bank 126 - MGTYRXP1_126
#set_property PACKAGE_PIN AR53     [get_ports "NS1_RX5_P"] ;# Bank 126 - MGTYRXP2_126
#set_property PACKAGE_PIN AP51     [get_ports "NS1_RX4_P"] ;# Bank 126 - MGTYRXP3_126
#set_property PACKAGE_PIN AU49     [get_ports "NS1_TX7_N"] ;# Bank 126 - MGTYTXN0_126
#set_property PACKAGE_PIN AT47     [get_ports "NS1_TX6_N"] ;# Bank 126 - MGTYTXN1_126
#set_property PACKAGE_PIN AR49     [get_ports "NS1_TX5_N"] ;# Bank 126 - MGTYTXN2_126
#set_property PACKAGE_PIN AR45     [get_ports "NS1_TX4_N"] ;# Bank 126 - MGTYTXN3_126
#set_property PACKAGE_PIN AU48     [get_ports "NS1_TX7_P"] ;# Bank 126 - MGTYTXP0_126
#set_property PACKAGE_PIN AT46     [get_ports "NS1_TX6_P"] ;# Bank 126 - MGTYTXP1_126
#set_property PACKAGE_PIN AR48     [get_ports "NS1_TX5_P"] ;# Bank 126 - MGTYTXP2_126
#set_property PACKAGE_PIN AR44     [get_ports "NS1_TX4_P"] ;# Bank 126 - MGTYTXP3_126
#set_property PACKAGE_PIN AN54     [get_ports "NS1_RX3_N"] ;# Bank 127 - MGTYRXN0_127
#set_property PACKAGE_PIN AN50     [get_ports "NS1_RX2_N"] ;# Bank 127 - MGTYRXN1_127
#set_property PACKAGE_PIN AM52     [get_ports "NS1_RX1_N"] ;# Bank 127 - MGTYRXN2_127
#set_property PACKAGE_PIN AL54     [get_ports "NS1_RX0_N"] ;# Bank 127 - MGTYRXN3_127
#set_property PACKAGE_PIN AN53     [get_ports "NS1_RX3_P"] ;# Bank 127 - MGTYRXP0_127
#set_property PACKAGE_PIN AN49     [get_ports "NS1_RX2_P"] ;# Bank 127 - MGTYRXP1_127
#set_property PACKAGE_PIN AM51     [get_ports "NS1_RX1_P"] ;# Bank 127 - MGTYRXP2_127
#set_property PACKAGE_PIN AL53     [get_ports "NS1_RX0_P"] ;# Bank 127 - MGTYRXP3_127
#set_property PACKAGE_PIN AP47     [get_ports "NS1_TX3_N"] ;# Bank 127 - MGTYTXN0_127
#set_property PACKAGE_PIN AN45     [get_ports "NS1_TX2_N"] ;# Bank 127 - MGTYTXN1_127
#set_property PACKAGE_PIN AM47     [get_ports "NS1_TX1_N"] ;# Bank 127 - MGTYTXN2_127
#set_property PACKAGE_PIN AL45     [get_ports "NS1_TX0_N"] ;# Bank 127 - MGTYTXN3_127
#set_property PACKAGE_PIN AP46     [get_ports "NS1_TX3_P"] ;# Bank 127 - MGTYTXP0_127
#set_property PACKAGE_PIN AN44     [get_ports "NS1_TX2_P"] ;# Bank 127 - MGTYTXP1_127
#set_property PACKAGE_PIN AM46     [get_ports "NS1_TX1_P"] ;# Bank 127 - MGTYTXP2_127
#set_property PACKAGE_PIN AL44     [get_ports "NS1_TX0_P"] ;# Bank 127 - MGTYTXP3_127
#set_property PACKAGE_PIN AE41     [get_ports "N46843036"] ;# Bank 129 - MGTRREF_LC
#set_property PACKAGE_PIN AU41     [get_ports "N46888322"] ;# Bank 125 - MGTRREF_LS
##################################################################################################################################################################
##
##																QSFP28 MGTY Interface QUAD 130 and QUAD 131
##							
##################################################################################################################################################################
set_property PACKAGE_PIN AD52     [get_ports "QSFP28_0_RX1_N"] ;# Bank 130 - MGTYRXN0_130
set_property PACKAGE_PIN AC54     [get_ports "QSFP28_0_RX2_N"] ;# Bank 130 - MGTYRXN1_130
set_property PACKAGE_PIN AC50     [get_ports "QSFP28_0_RX3_N"] ;# Bank 130 - MGTYRXN2_130
set_property PACKAGE_PIN AB52     [get_ports "QSFP28_0_RX4_N"] ;# Bank 130 - MGTYRXN3_130
set_property PACKAGE_PIN AD51     [get_ports "QSFP28_0_RX1_P"] ;# Bank 130 - MGTYRXP0_130
set_property PACKAGE_PIN AC53     [get_ports "QSFP28_0_RX2_P"] ;# Bank 130 - MGTYRXP1_130
set_property PACKAGE_PIN AC49     [get_ports "QSFP28_0_RX3_P"] ;# Bank 130 - MGTYRXP2_130
set_property PACKAGE_PIN AB51     [get_ports "QSFP28_0_RX4_P"] ;# Bank 130 - MGTYRXP3_130
set_property PACKAGE_PIN AD47     [get_ports "QSFP28_0_TX1_N"] ;# Bank 130 - MGTYTXN0_130
set_property PACKAGE_PIN AC45     [get_ports "QSFP28_0_TX2_N"] ;# Bank 130 - MGTYTXN1_130
set_property PACKAGE_PIN AB47     [get_ports "QSFP28_0_TX3_N"] ;# Bank 130 - MGTYTXN2_130
set_property PACKAGE_PIN AA49     [get_ports "QSFP28_0_TX4_N"] ;# Bank 130 - MGTYTXN3_130
set_property PACKAGE_PIN AD46     [get_ports "QSFP28_0_TX1_P"] ;# Bank 130 - MGTYTXP0_130
set_property PACKAGE_PIN AC44     [get_ports "QSFP28_0_TX2_P"] ;# Bank 130 - MGTYTXP1_130
set_property PACKAGE_PIN AB46     [get_ports "QSFP28_0_TX3_P"] ;# Bank 130 - MGTYTXP2_130
set_property PACKAGE_PIN AA48     [get_ports "QSFP28_0_TX4_P"] ;# Bank 130 - MGTYTXP3_130
set_property PACKAGE_PIN AA54     [get_ports "QSFP28_1_RX1_N"] ;# Bank 131 - MGTYRXN0_131
set_property PACKAGE_PIN Y52      [get_ports "QSFP28_1_RX2_N"] ;# Bank 131 - MGTYRXN1_131
set_property PACKAGE_PIN W54      [get_ports "QSFP28_1_RX3_N"] ;# Bank 131 - MGTYRXN2_131
set_property PACKAGE_PIN V52      [get_ports "QSFP28_1_RX4_N"] ;# Bank 131 - MGTYRXN3_131
set_property PACKAGE_PIN AA53     [get_ports "QSFP28_1_RX1_P"] ;# Bank 131 - MGTYRXP0_131
set_property PACKAGE_PIN Y51      [get_ports "QSFP28_1_RX2_P"] ;# Bank 131 - MGTYRXP1_131
set_property PACKAGE_PIN W53      [get_ports "QSFP28_1_RX3_P"] ;# Bank 131 - MGTYRXP2_131
set_property PACKAGE_PIN V51      [get_ports "QSFP28_1_RX4_P"] ;# Bank 131 - MGTYRXP3_131
set_property PACKAGE_PIN AA45     [get_ports "QSFP28_1_TX1_N"] ;# Bank 131 - MGTYTXN0_131
set_property PACKAGE_PIN Y47      [get_ports "QSFP28_1_TX2_N"] ;# Bank 131 - MGTYTXN1_131
set_property PACKAGE_PIN W49      [get_ports "QSFP28_1_TX3_N"] ;# Bank 131 - MGTYTXN2_131
set_property PACKAGE_PIN W45      [get_ports "QSFP28_1_TX4_N"] ;# Bank 131 - MGTYTXN3_131
set_property PACKAGE_PIN AA44     [get_ports "QSFP28_1_TX1_P"] ;# Bank 131 - MGTYTXP0_131
set_property PACKAGE_PIN Y46      [get_ports "QSFP28_1_TX2_P"] ;# Bank 131 - MGTYTXP1_131
set_property PACKAGE_PIN W48      [get_ports "QSFP28_1_TX3_P"] ;# Bank 131 - MGTYTXP2_131
set_property PACKAGE_PIN W44      [get_ports "QSFP28_1_TX4_P"] ;# Bank 131 - MGTYTXP3_131
##################################################################################################################################################################
##
##																PCIe MGTY Interface QUAD 224,225,226 and 227 
##							
##################################################################################################################################################################
set_property PACKAGE_PIN BC1      [get_ports "PEX_RX15_N"] ;# Bank 224 - MGTYRXN0_224
set_property PACKAGE_PIN BB3      [get_ports "PEX_RX14_N"] ;# Bank 224 - MGTYRXN1_224
set_property PACKAGE_PIN BA1      [get_ports "PEX_RX13_N"] ;# Bank 224 - MGTYRXN2_224
set_property PACKAGE_PIN BA5      [get_ports "PEX_RX12_N"] ;# Bank 224 - MGTYRXN3_224
set_property PACKAGE_PIN AY3      [get_ports "PEX_RX11_N"] ;# Bank 225 - MGTYRXN0_225
set_property PACKAGE_PIN AW1      [get_ports "PEX_RX10_N"] ;# Bank 225 - MGTYRXN1_225
set_property PACKAGE_PIN AW5      [get_ports "PEX_RX9_N"] ;# Bank 225 - MGTYRXN2_225
set_property PACKAGE_PIN AV3      [get_ports "PEX_RX8_N"] ;# Bank 225 - MGTYRXN3_225
set_property PACKAGE_PIN AU1      [get_ports "PEX_RX7_N"] ;# Bank 226 - MGTYRXN0_226
set_property PACKAGE_PIN AT3      [get_ports "PEX_RX6_N"] ;# Bank 226 - MGTYRXN1_226
set_property PACKAGE_PIN AR1      [get_ports "PEX_RX5_N"] ;# Bank 226 - MGTYRXN2_226
set_property PACKAGE_PIN AP3      [get_ports "PEX_RX4_N"] ;# Bank 226 - MGTYRXN3_226
set_property PACKAGE_PIN AN1      [get_ports "PEX_RX3_N"] ;# Bank 227 - MGTYRXN0_227
set_property PACKAGE_PIN AN5      [get_ports "PEX_RX2_N"] ;# Bank 227 - MGTYRXN1_227
set_property PACKAGE_PIN AM3      [get_ports "PEX_RX1_N"] ;# Bank 227 - MGTYRXN2_227
set_property PACKAGE_PIN AL1      [get_ports "PEX_RX0_N"] ;# Bank 227 - MGTYRXN3_227

set_property PACKAGE_PIN BC2      [get_ports "PEX_RX15_P"] ;# Bank 224 - MGTYRXP0_224
set_property PACKAGE_PIN BB4      [get_ports "PEX_RX14_P"] ;# Bank 224 - MGTYRXP1_224
set_property PACKAGE_PIN BA2      [get_ports "PEX_RX13_P"] ;# Bank 224 - MGTYRXP2_224
set_property PACKAGE_PIN BA6      [get_ports "PEX_RX12_P"] ;# Bank 224 - MGTYRXP3_224
set_property PACKAGE_PIN AY4      [get_ports "PEX_RX11_P"] ;# Bank 225 - MGTYRXP0_225
set_property PACKAGE_PIN AW2      [get_ports "PEX_RX10_P"] ;# Bank 225 - MGTYRXP1_225
set_property PACKAGE_PIN AW6      [get_ports "PEX_RX9_P"] ;# Bank 225 - MGTYRXP2_225
set_property PACKAGE_PIN AV4      [get_ports "PEX_RX8_P"] ;# Bank 225 - MGTYRXP3_225
set_property PACKAGE_PIN AU2      [get_ports "PEX_RX7_P"] ;# Bank 226 - MGTYRXP0_226
set_property PACKAGE_PIN AT4      [get_ports "PEX_RX6_P"] ;# Bank 226 - MGTYRXP1_226
set_property PACKAGE_PIN AR2      [get_ports "PEX_RX5_P"] ;# Bank 226 - MGTYRXP2_226
set_property PACKAGE_PIN AP4      [get_ports "PEX_RX4_P"] ;# Bank 226 - MGTYRXP3_226
set_property PACKAGE_PIN AN2      [get_ports "PEX_RX3_P"] ;# Bank 227 - MGTYRXP0_227
set_property PACKAGE_PIN AN6      [get_ports "PEX_RX2_P"] ;# Bank 227 - MGTYRXP1_227
set_property PACKAGE_PIN AM4      [get_ports "PEX_RX1_P"] ;# Bank 227 - MGTYRXP2_227
set_property PACKAGE_PIN AL2      [get_ports "PEX_RX0_P"] ;# Bank 227 - MGTYRXP3_227

set_property PACKAGE_PIN BC6      [get_ports "PEX_TX15_N"] ;# Bank 224 - MGTYTXN0_224
set_property PACKAGE_PIN BC10     [get_ports "PEX_TX14_N"] ;# Bank 224 - MGTYTXN1_224
set_property PACKAGE_PIN BB8      [get_ports "PEX_TX13_N"] ;# Bank 224 - MGTYTXN2_224
set_property PACKAGE_PIN BA10     [get_ports "PEX_TX12_N"] ;# Bank 224 - MGTYTXN3_224
set_property PACKAGE_PIN AY8      [get_ports "PEX_TX11_N"] ;# Bank 225 - MGTYTXN0_225
set_property PACKAGE_PIN AW10     [get_ports "PEX_TX10_N"] ;# Bank 225 - MGTYTXN1_225
set_property PACKAGE_PIN AV8      [get_ports "PEX_TX9_N"] ;# Bank 225 - MGTYTXN2_225
set_property PACKAGE_PIN AU6      [get_ports "PEX_TX8_N"] ;# Bank 225 - MGTYTXN3_225
set_property PACKAGE_PIN AU10     [get_ports "PEX_TX7_N"] ;# Bank 226 - MGTYTXN0_226
set_property PACKAGE_PIN AT8      [get_ports "PEX_TX6_N"] ;# Bank 226 - MGTYTXN1_226
set_property PACKAGE_PIN AR6      [get_ports "PEX_TX5_N"] ;# Bank 226 - MGTYTXN2_226
set_property PACKAGE_PIN AR10     [get_ports "PEX_TX4_N"] ;# Bank 226 - MGTYTXN3_226
set_property PACKAGE_PIN AP8      [get_ports "PEX_TX3_N"] ;# Bank 227 - MGTYTXN0_227
set_property PACKAGE_PIN AN10     [get_ports "PEX_TX2_N"] ;# Bank 227 - MGTYTXN1_227
set_property PACKAGE_PIN AM8      [get_ports "PEX_TX1_N"] ;# Bank 227 - MGTYTXN2_227
set_property PACKAGE_PIN AL10     [get_ports "PEX_TX0_N"] ;# Bank 227 - MGTYTXN3_227

set_property PACKAGE_PIN BC7      [get_ports "PEX_TX15_P"] ;# Bank 224 - MGTYTXP0_224
set_property PACKAGE_PIN BC11     [get_ports "PEX_TX14_P"] ;# Bank 224 - MGTYTXP1_224
set_property PACKAGE_PIN BB9      [get_ports "PEX_TX13_P"] ;# Bank 224 - MGTYTXP2_224
set_property PACKAGE_PIN BA11     [get_ports "PEX_TX12_P"] ;# Bank 224 - MGTYTXP3_224
set_property PACKAGE_PIN AY9      [get_ports "PEX_TX11_P"] ;# Bank 225 - MGTYTXP0_225
set_property PACKAGE_PIN AW11     [get_ports "PEX_TX10_P"] ;# Bank 225 - MGTYTXP1_225
set_property PACKAGE_PIN AV9      [get_ports "PEX_TX9_P"] ;# Bank 225 - MGTYTXP2_225
set_property PACKAGE_PIN AU7      [get_ports "PEX_TX8_P"] ;# Bank 225 - MGTYTXP3_225
set_property PACKAGE_PIN AU11     [get_ports "PEX_TX7_P"] ;# Bank 226 - MGTYTXP0_226
set_property PACKAGE_PIN AT9      [get_ports "PEX_TX6_P"] ;# Bank 226 - MGTYTXP1_226
set_property PACKAGE_PIN AR7      [get_ports "PEX_TX5_P"] ;# Bank 226 - MGTYTXP2_226
set_property PACKAGE_PIN AR11     [get_ports "PEX_TX4_P"] ;# Bank 226 - MGTYTXP3_226
set_property PACKAGE_PIN AP9      [get_ports "PEX_TX3_P"] ;# Bank 227 - MGTYTXP0_227
set_property PACKAGE_PIN AN11     [get_ports "PEX_TX2_P"] ;# Bank 227 - MGTYTXP1_227
set_property PACKAGE_PIN AM9      [get_ports "PEX_TX1_P"] ;# Bank 227 - MGTYTXP2_227
set_property PACKAGE_PIN AL11     [get_ports "PEX_TX0_P"] ;# Bank 227 - MGTYTXP3_227

#set_property PACKAGE_PIN AU14     [get_ports "N45904402"] ;# Bank 225 - MGTRREF_RS

# Bitstream Configuration
# ------------------------------------------------------------------------
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
# ------------------------------------------------------------------------

##################################################################################################################################################################
##
##																// GND and Unsused//
##							
##################################################################################################################################################################
#set_property PACKAGE_PIN AL50     [get_ports "GND"] ;# Bank 128 - MGTYRXN0_128
#set_property PACKAGE_PIN AK52     [get_ports "GND"] ;# Bank 128 - MGTYRXN1_128
#set_property PACKAGE_PIN AJ54     [get_ports "GND"] ;# Bank 128 - MGTYRXN2_128
#set_property PACKAGE_PIN AH52     [get_ports "GND"] ;# Bank 128 - MGTYRXN3_128
#set_property PACKAGE_PIN AL49     [get_ports "GND"] ;# Bank 128 - MGTYRXP0_128
#set_property PACKAGE_PIN AK51     [get_ports "GND"] ;# Bank 128 - MGTYRXP1_128
#set_property PACKAGE_PIN AJ53     [get_ports "GND"] ;# Bank 128 - MGTYRXP2_128
#set_property PACKAGE_PIN AH51     [get_ports "GND"] ;# Bank 128 - MGTYRXP3_128
#set_property PACKAGE_PIN AG54     [get_ports "GND"] ;# Bank 129 - MGTYRXN0_129
#set_property PACKAGE_PIN AF52     [get_ports "GND"] ;# Bank 129 - MGTYRXN1_129
#set_property PACKAGE_PIN AE54     [get_ports "GND"] ;# Bank 129 - MGTYRXN2_129
#set_property PACKAGE_PIN AE50     [get_ports "GND"] ;# Bank 129 - MGTYRXN3_129
#set_property PACKAGE_PIN AG53     [get_ports "GND"] ;# Bank 129 - MGTYRXP0_129
#set_property PACKAGE_PIN AF51     [get_ports "GND"] ;# Bank 129 - MGTYRXP1_129
#set_property PACKAGE_PIN AE53     [get_ports "GND"] ;# Bank 129 - MGTYRXP2_129
#set_property PACKAGE_PIN AE49     [get_ports "GND"] ;# Bank 129 - MGTYRXP3_129
#set_property PACKAGE_PIN AL5      [get_ports "GND"] ;# Bank 228 - MGTYRXN0_228
#set_property PACKAGE_PIN AK3      [get_ports "GND"] ;# Bank 228 - MGTYRXN1_228
#set_property PACKAGE_PIN AJ1      [get_ports "GND"] ;# Bank 228 - MGTYRXN2_228
#set_property PACKAGE_PIN AH3      [get_ports "GND"] ;# Bank 228 - MGTYRXN3_228
#set_property PACKAGE_PIN AL6      [get_ports "GND"] ;# Bank 228 - MGTYRXP0_228
#set_property PACKAGE_PIN AK4      [get_ports "GND"] ;# Bank 228 - MGTYRXP1_228
#set_property PACKAGE_PIN AJ2      [get_ports "GND"] ;# Bank 228 - MGTYRXP2_228
#set_property PACKAGE_PIN AH4      [get_ports "GND"] ;# Bank 228 - MGTYRXP3_228
#set_property PACKAGE_PIN AE14     [get_ports "GND"] ;# Bank 229 - MGTRREF_RC
#set_property PACKAGE_PIN AG1      [get_ports "GND"] ;# Bank 229 - MGTYRXN0_229
#set_property PACKAGE_PIN AF3      [get_ports "GND"] ;# Bank 229 - MGTYRXN1_229
#set_property PACKAGE_PIN AE1      [get_ports "GND"] ;# Bank 229 - MGTYRXN2_229
#set_property PACKAGE_PIN AE5      [get_ports "GND"] ;# Bank 229 - MGTYRXN3_229
#set_property PACKAGE_PIN AG2      [get_ports "GND"] ;# Bank 229 - MGTYRXP0_229
#set_property PACKAGE_PIN AF4      [get_ports "GND"] ;# Bank 229 - MGTYRXP1_229
#set_property PACKAGE_PIN AE2      [get_ports "GND"] ;# Bank 229 - MGTYRXP2_229
#set_property PACKAGE_PIN AE6      [get_ports "GND"] ;# Bank 229 - MGTYRXP3_229
#set_property PACKAGE_PIN AD3      [get_ports "GND"] ;# Bank 230 - MGTYRXN0_230
#set_property PACKAGE_PIN AC1      [get_ports "GND"] ;# Bank 230 - MGTYRXN1_230
#set_property PACKAGE_PIN AC5      [get_ports "GND"] ;# Bank 230 - MGTYRXN2_230
#set_property PACKAGE_PIN AB3      [get_ports "GND"] ;# Bank 230 - MGTYRXN3_230
#set_property PACKAGE_PIN AD4      [get_ports "GND"] ;# Bank 230 - MGTYRXP0_230
#set_property PACKAGE_PIN AC2      [get_ports "GND"] ;# Bank 230 - MGTYRXP1_230
#set_property PACKAGE_PIN AC6      [get_ports "GND"] ;# Bank 230 - MGTYRXP2_230
#set_property PACKAGE_PIN AB4      [get_ports "GND"] ;# Bank 230 - MGTYRXP3_230
#set_property PACKAGE_PIN AA1      [get_ports "GND"] ;# Bank 231 - MGTYRXN0_231
#set_property PACKAGE_PIN Y3       [get_ports "GND"] ;# Bank 231 - MGTYRXN1_231
#set_property PACKAGE_PIN W1       [get_ports "GND"] ;# Bank 231 - MGTYRXN2_231
#set_property PACKAGE_PIN V3       [get_ports "GND"] ;# Bank 231 - MGTYRXN3_231
#set_property PACKAGE_PIN AA2      [get_ports "GND"] ;# Bank 231 - MGTYRXP0_231
#set_property PACKAGE_PIN Y4       [get_ports "GND"] ;# Bank 231 - MGTYRXP1_231
#set_property PACKAGE_PIN W2       [get_ports "GND"] ;# Bank 231 - MGTYRXP2_231
#set_property PACKAGE_PIN V4       [get_ports "GND"] ;# Bank 231 - MGTYRXP3_231
########################################################################################################################################################
#set_property PACKAGE_PIN BF21     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L24N_T3U_N11_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L24N_T3U_N11_67
#set_property PACKAGE_PIN BF22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L24P_T3U_N10_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L24P_T3U_N10_67
#set_property PACKAGE_PIN BH22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L23N_T3U_N9_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L23N_T3U_N9_67
#set_property PACKAGE_PIN BG22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L23P_T3U_N8_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L23P_T3U_N8_67
#set_property PACKAGE_PIN BJ21     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L22N_T3U_N7_DBC_AD0N_67
#set_property PACKAGE_PIN BH21     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L22P_T3U_N6_DBC_AD0P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L22P_T3U_N6_DBC_AD0P_67
#set_property PACKAGE_PIN BK21     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L21N_T3L_N5_AD8N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L21N_T3L_N5_AD8N_67
#set_property PACKAGE_PIN BJ22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L21P_T3L_N4_AD8P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L21P_T3L_N4_AD8P_67
#set_property PACKAGE_PIN BK23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L20N_T3L_N3_AD1N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L20N_T3L_N3_AD1N_67
#set_property PACKAGE_PIN BK24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L20P_T3L_N2_AD1P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L20P_T3L_N2_AD1P_67
#set_property PACKAGE_PIN BL22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L19N_T3L_N1_DBC_AD9N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L19N_T3L_N1_DBC_AD9N_67
#set_property PACKAGE_PIN BL23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L19P_T3L_N0_DBC_AD9P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L19P_T3L_N0_DBC_AD9P_67
#set_property PACKAGE_PIN BG23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T3U_N12_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T3U_N12_67
#set_property PACKAGE_PIN BF23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T2U_N12_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T2U_N12_67
#set_property PACKAGE_PIN BH24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L18N_T2U_N11_AD2N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L18N_T2U_N11_AD2N_67
#set_property PACKAGE_PIN BG24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L18P_T2U_N10_AD2P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L18P_T2U_N10_AD2P_67
#set_property PACKAGE_PIN BG25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L17N_T2U_N9_AD10N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L17N_T2U_N9_AD10N_67
#set_property PACKAGE_PIN BF25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L17P_T2U_N8_AD10P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L17P_T2U_N8_AD10P_67
#set_property PACKAGE_PIN BF26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L16N_T2U_N7_QBC_AD3N_67
#set_property PACKAGE_PIN BF27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L16P_T2U_N6_QBC_AD3P_67
#set_property PACKAGE_PIN BG27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L15N_T2L_N5_AD11N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L15N_T2L_N5_AD11N_67
#set_property PACKAGE_PIN BG28     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L15P_T2L_N4_AD11P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L15P_T2L_N4_AD11P_67
#set_property PACKAGE_PIN BJ23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L14N_T2L_N3_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L14N_T2L_N3_GC_67
#set_property PACKAGE_PIN BJ24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L14P_T2L_N2_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L14P_T2L_N2_GC_67
#set_property PACKAGE_PIN BH25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L13N_T2L_N1_GC_QBC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L13N_T2L_N1_GC_QBC_67
#set_property PACKAGE_PIN BH26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L13P_T2L_N0_GC_QBC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L13P_T2L_N0_GC_QBC_67
#set_property PACKAGE_PIN BJ27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L12N_T1U_N11_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L12N_T1U_N11_GC_67
#set_property PACKAGE_PIN BH27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L12P_T1U_N10_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L12P_T1U_N10_GC_67
#set_property PACKAGE_PIN BK25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L11N_T1U_N9_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L11N_T1U_N9_GC_67
#set_property PACKAGE_PIN BJ26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L11P_T1U_N8_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L11P_T1U_N8_GC_67
#set_property PACKAGE_PIN BL25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L10N_T1U_N7_QBC_AD4N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L10N_T1U_N7_QBC_AD4N_67
#set_property PACKAGE_PIN BK26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L10P_T1U_N6_QBC_AD4P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L10P_T1U_N6_QBC_AD4P_67
#set_property PACKAGE_PIN BK28     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L9N_T1L_N5_AD12N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L9N_T1L_N5_AD12N_67
#set_property PACKAGE_PIN BJ28     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L9P_T1L_N4_AD12P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L9P_T1L_N4_AD12P_67
#set_property PACKAGE_PIN BL26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L8N_T1L_N3_AD5N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L8N_T1L_N3_AD5N_67
#set_property PACKAGE_PIN BL27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L8P_T1L_N2_AD5P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L8P_T1L_N2_AD5P_67
#set_property PACKAGE_PIN BM27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L7N_T1L_N1_QBC_AD13N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L7N_T1L_N1_QBC_AD13N_67
#set_property PACKAGE_PIN BL28     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L7P_T1L_N0_QBC_AD13P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L7P_T1L_N0_QBC_AD13P_67
#set_property PACKAGE_PIN BN27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T1U_N12_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T1U_N12_67
#set_property PACKAGE_PIN BP27     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T0U_N12_VRP_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_T0U_N12_VRP_67
#set_property PACKAGE_PIN BN22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L6N_T0U_N11_AD6N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L6N_T0U_N11_AD6N_67
#set_property PACKAGE_PIN BM22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L6P_T0U_N10_AD6P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L6P_T0U_N10_AD6P_67
#set_property PACKAGE_PIN BM23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L5N_T0U_N9_AD14N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L5N_T0U_N9_AD14N_67
#set_property PACKAGE_PIN BM24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L5P_T0U_N8_AD14P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L5P_T0U_N8_AD14P_67
#set_property PACKAGE_PIN BN25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L4N_T0U_N7_DBC_AD7N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L4N_T0U_N7_DBC_AD7N_67
#set_property PACKAGE_PIN BM25     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L4P_T0U_N6_DBC_AD7P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L4P_T0U_N6_DBC_AD7P_67
#set_property PACKAGE_PIN BP24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L3N_T0L_N5_AD15N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L3N_T0L_N5_AD15N_67
#set_property PACKAGE_PIN BN24     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L3P_T0L_N4_AD15P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L3P_T0L_N4_AD15P_67
#set_property PACKAGE_PIN BP26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L2N_T0L_N3_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L2N_T0L_N3_67
#set_property PACKAGE_PIN BN26     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L2P_T0L_N2_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L2P_T0L_N2_67
#set_property PACKAGE_PIN BP22     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L1N_T0L_N1_DBC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L1N_T0L_N1_DBC_67
#set_property PACKAGE_PIN BP23     [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L1P_T0L_N0_DBC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  67 VCCO - VCCO_67_BG26 - IO_L1P_T0L_N0_DBC_67
#set_property PACKAGE_PIN BE51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L24N_T3U_N11_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L24N_T3U_N11_66
#set_property PACKAGE_PIN BD51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L24P_T3U_N10_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L24P_T3U_N10_66
#set_property PACKAGE_PIN BE50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L23N_T3U_N9_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L23N_T3U_N9_66
#set_property PACKAGE_PIN BE49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L23P_T3U_N8_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L23P_T3U_N8_66
#set_property PACKAGE_PIN BF48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L22N_T3U_N7_DBC_AD0N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L22N_T3U_N7_DBC_AD0N_66
#set_property PACKAGE_PIN BF47     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L22P_T3U_N6_DBC_AD0P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L22P_T3U_N6_DBC_AD0P_66
#set_property PACKAGE_PIN BF52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L21N_T3L_N5_AD8N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L21N_T3L_N5_AD8N_66
#set_property PACKAGE_PIN BF51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L21P_T3L_N4_AD8P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L21P_T3L_N4_AD8P_66
#set_property PACKAGE_PIN BG50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L20N_T3L_N3_AD1N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L20N_T3L_N3_AD1N_66
#set_property PACKAGE_PIN BF50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L20P_T3L_N2_AD1P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L20P_T3L_N2_AD1P_66
#set_property PACKAGE_PIN BG49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L19N_T3L_N1_DBC_AD9N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L19N_T3L_N1_DBC_AD9N_66
#set_property PACKAGE_PIN BG48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L19P_T3L_N0_DBC_AD9P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L19P_T3L_N0_DBC_AD9P_66
#set_property PACKAGE_PIN BG47     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T3U_N12_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T3U_N12_66
#set_property PACKAGE_PIN BF53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T2U_N12_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T2U_N12_66
#set_property PACKAGE_PIN BE54     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L18N_T2U_N11_AD2N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L18N_T2U_N11_AD2N_66
#set_property PACKAGE_PIN BE53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L18P_T2U_N10_AD2P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L18P_T2U_N10_AD2P_66
#set_property PACKAGE_PIN BG54     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L17N_T2U_N9_AD10N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L17N_T2U_N9_AD10N_66
#set_property PACKAGE_PIN BG53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L17P_T2U_N8_AD10P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L17P_T2U_N8_AD10P_66
#set_property PACKAGE_PIN BJ54     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L16N_T2U_N7_QBC_AD3N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L16N_T2U_N7_QBC_AD3N_66
#set_property PACKAGE_PIN BH54     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L16P_T2U_N6_QBC_AD3P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L16P_T2U_N6_QBC_AD3P_66
#set_property PACKAGE_PIN BK54     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L15N_T2L_N5_AD11N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L15N_T2L_N5_AD11N_66
#set_property PACKAGE_PIN BK53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L15P_T2L_N4_AD11P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L15P_T2L_N4_AD11P_66
#set_property PACKAGE_PIN BH52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L14N_T2L_N3_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L14N_T2L_N3_GC_66
#set_property PACKAGE_PIN BG52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L14P_T2L_N2_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L14P_T2L_N2_GC_66
#set_property PACKAGE_PIN BJ53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L13N_T2L_N1_GC_QBC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L13N_T2L_N1_GC_QBC_66
#set_property PACKAGE_PIN BJ52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L13P_T2L_N0_GC_QBC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L13P_T2L_N0_GC_QBC_66
#set_property PACKAGE_PIN BH50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L12N_T1U_N11_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L12N_T1U_N11_GC_66
#set_property PACKAGE_PIN BH49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L12P_T1U_N10_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L12P_T1U_N10_GC_66
#set_property PACKAGE_PIN BJ51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L11N_T1U_N9_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L11N_T1U_N9_GC_66
#set_property PACKAGE_PIN BH51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L11P_T1U_N8_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L11P_T1U_N8_GC_66
#set_property PACKAGE_PIN BJ47     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L10N_T1U_N7_QBC_AD4N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L10N_T1U_N7_QBC_AD4N_66
#set_property PACKAGE_PIN BH47     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L10P_T1U_N6_QBC_AD4P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L10P_T1U_N6_QBC_AD4P_66
#set_property PACKAGE_PIN BJ49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L9N_T1L_N5_AD12N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L9N_T1L_N5_AD12N_66
#set_property PACKAGE_PIN BJ48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L9P_T1L_N4_AD12P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L9P_T1L_N4_AD12P_66
#set_property PACKAGE_PIN BK51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L8N_T1L_N3_AD5N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L8N_T1L_N3_AD5N_66
#set_property PACKAGE_PIN BK50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L8P_T1L_N2_AD5P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L8P_T1L_N2_AD5P_66
#set_property PACKAGE_PIN BK49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L7N_T1L_N1_QBC_AD13N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L7N_T1L_N1_QBC_AD13N_66
#set_property PACKAGE_PIN BK48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L7P_T1L_N0_QBC_AD13P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L7P_T1L_N0_QBC_AD13P_66
#set_property PACKAGE_PIN BL48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T1U_N12_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T1U_N12_66
#set_property PACKAGE_PIN BL50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T0U_N12_VRP_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_T0U_N12_VRP_66
#set_property PACKAGE_PIN BL53     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L6N_T0U_N11_AD6N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L6N_T0U_N11_AD6N_66
#set_property PACKAGE_PIN BL52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L6P_T0U_N10_AD6P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L6P_T0U_N10_AD6P_66
#set_property PACKAGE_PIN BM52     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L5N_T0U_N9_AD14N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L5N_T0U_N9_AD14N_66
#set_property PACKAGE_PIN BL51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L5P_T0U_N8_AD14P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L5P_T0U_N8_AD14P_66
#set_property PACKAGE_PIN BM50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L4N_T0U_N7_DBC_AD7N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L4N_T0U_N7_DBC_AD7N_66
#set_property PACKAGE_PIN BM49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L4P_T0U_N6_DBC_AD7P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L4P_T0U_N6_DBC_AD7P_66
#set_property PACKAGE_PIN BN49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L3N_T0L_N5_AD15N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L3N_T0L_N5_AD15N_66
#set_property PACKAGE_PIN BM48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L3P_T0L_N4_AD15P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L3P_T0L_N4_AD15P_66
#set_property PACKAGE_PIN BN51     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L2N_T0L_N3_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L2N_T0L_N3_66
#set_property PACKAGE_PIN BN50     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L2P_T0L_N2_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L2P_T0L_N2_66
#set_property PACKAGE_PIN BP49     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L1N_T0L_N1_DBC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L1N_T0L_N1_DBC_66
#set_property PACKAGE_PIN BP48     [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L1P_T0L_N0_DBC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  66 VCCO - VCCO_66_BG51 - IO_L1P_T0L_N0_DBC_66
#set_property PACKAGE_PIN BE44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L24N_T3U_N11_DOUT_CSO_B_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L24N_T3U_N11_DOUT_CSO_B_65
#set_property PACKAGE_PIN BE43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L24P_T3U_N10_EMCCLK_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L24P_T3U_N10_EMCCLK_65
#set_property PACKAGE_PIN BD42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65
#set_property PACKAGE_PIN BC42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L23P_T3U_N8_I2C_SCLK_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L23P_T3U_N8_I2C_SCLK_65
#set_property PACKAGE_PIN BF43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_D07_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_D07_65
#set_property PACKAGE_PIN BF42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_D06_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_D06_65
#set_property PACKAGE_PIN BE41     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_D11_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_D11_65
#set_property PACKAGE_PIN BD41     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_D10_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_D10_65
#set_property PACKAGE_PIN BH41     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T2U_N12_CSI_ADV_B_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T2U_N12_CSI_ADV_B_65
#set_property PACKAGE_PIN BG44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_D12_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_D12_65
#set_property PACKAGE_PIN BG42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_D14_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_D14_65
#set_property PACKAGE_PIN BJ46     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65
#set_property PACKAGE_PIN BH45     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_A05_D21_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_A05_D21_65
#set_property PACKAGE_PIN BH44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_A04_D20_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L14P_T2L_N2_GC_A04_D20_65
#set_property PACKAGE_PIN BJ44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property PACKAGE_PIN BJ43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property PACKAGE_PIN BK46     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
#set_property PACKAGE_PIN BK45     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
#set_property PACKAGE_PIN BL43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_A15_D31_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_A15_D31_65
#set_property PACKAGE_PIN BL42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_A14_D30_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_A14_D30_65
#set_property PACKAGE_PIN BM47     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_A19_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_A19_65
#set_property PACKAGE_PIN BL47     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property PACKAGE_PIN BM42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T1U_N12_SMBALERT_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T1U_N12_SMBALERT_65
#set_property PACKAGE_PIN BM43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T0U_N12_VRP_A28_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_T0U_N12_VRP_A28_65
#set_property PACKAGE_PIN BN45     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_A21_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_A21_65
#set_property PACKAGE_PIN BM45     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_A20_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_A20_65
#set_property PACKAGE_PIN BN44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_A23_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_A23_65
#set_property PACKAGE_PIN BM44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_A22_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_A22_65
#set_property PACKAGE_PIN BP46     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_A25_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_A25_65
#set_property PACKAGE_PIN BN46     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_A24_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_A24_65
#set_property PACKAGE_PIN BP44     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_A27_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_A27_65
#set_property PACKAGE_PIN BP43     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_A26_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_A26_65
#set_property PACKAGE_PIN BP42     [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_RS1_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  65 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_RS1_65
#set_property PACKAGE_PIN BF33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L23N_T3U_N9_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L23N_T3U_N9_64
#set_property PACKAGE_PIN BK30     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_64
#set_property PACKAGE_PIN BG32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_64
#set_property PACKAGE_PIN BH30     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_64
#set_property PACKAGE_PIN BH29     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_64
#set_property PACKAGE_PIN BK29     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T3U_N12_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T3U_N12_64
#set_property PACKAGE_PIN BG33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T2U_N12_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T2U_N12_64
#set_property PACKAGE_PIN BH34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_64
#set_property PACKAGE_PIN BF35     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_64
#set_property PACKAGE_PIN BK34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_64
#set_property PACKAGE_PIN BG35     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L15N_T2L_N5_AD11N_64
#set_property PACKAGE_PIN BG34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L15P_T2L_N4_AD11P_64
#set_property PACKAGE_PIN BJ34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L14N_T2L_N3_GC_64
#set_property PACKAGE_PIN BJ32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L13N_T2L_N1_GC_QBC_64
#set_property PACKAGE_PIN BL33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_64
#set_property PACKAGE_PIN BK33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_64
#set_property PACKAGE_PIN BL31     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L11N_T1U_N9_GC_64
#set_property PACKAGE_PIN BK31     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L11P_T1U_N8_GC_64
#set_property PACKAGE_PIN BM35     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L10N_T1U_N7_QBC_AD4N_64
#set_property PACKAGE_PIN BL35     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_64
#set_property PACKAGE_PIN BM33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_64
#set_property PACKAGE_PIN BL32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L9P_T1L_N4_AD12P_64
#set_property PACKAGE_PIN BP34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L8N_T1L_N3_AD5N_64
#set_property PACKAGE_PIN BN34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L8P_T1L_N2_AD5P_64
#set_property PACKAGE_PIN BN35     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L7N_T1L_N1_QBC_AD13N_64
#set_property PACKAGE_PIN BM34     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_64
#set_property PACKAGE_PIN BP33     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T1U_N12_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T1U_N12_64
#set_property PACKAGE_PIN BM32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T0U_N12_VRP_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_T0U_N12_VRP_64
#set_property PACKAGE_PIN BP32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_64
#set_property PACKAGE_PIN BN32     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_64
#set_property PACKAGE_PIN BM30     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_64
#set_property PACKAGE_PIN BL30     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L5P_T0U_N8_AD14P_64
#set_property PACKAGE_PIN BN30     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L4N_T0U_N7_DBC_AD7N_64
#set_property PACKAGE_PIN BN29     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_64
#set_property PACKAGE_PIN BP31     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_64
#set_property PACKAGE_PIN BN31     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L3P_T0L_N4_AD15P_64
#set_property PACKAGE_PIN BP29     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L2N_T0L_N3_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L2N_T0L_N3_64
#set_property PACKAGE_PIN BP28     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L2P_T0L_N2_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L2P_T0L_N2_64
#set_property PACKAGE_PIN BM29     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_64
#set_property PACKAGE_PIN BM28     [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_64
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  64 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_64
#set_property PACKAGE_PIN A16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L24N_T3U_N11_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L24N_T3U_N11_71
#set_property PACKAGE_PIN B16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L24P_T3U_N10_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L24P_T3U_N10_71
#set_property PACKAGE_PIN A18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L23N_T3U_N9_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L23N_T3U_N9_71
#set_property PACKAGE_PIN A19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L23P_T3U_N8_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L23P_T3U_N8_71
#set_property PACKAGE_PIN A20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L22N_T3U_N7_DBC_AD0N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L22N_T3U_N7_DBC_AD0N_71
#set_property PACKAGE_PIN A21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L22P_T3U_N6_DBC_AD0P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L22P_T3U_N6_DBC_AD0P_71
#set_property PACKAGE_PIN B17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L21N_T3L_N5_AD8N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L21N_T3L_N5_AD8N_71
#set_property PACKAGE_PIN B18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L21P_T3L_N4_AD8P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L21P_T3L_N4_AD8P_71
#set_property PACKAGE_PIN B20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L20N_T3L_N3_AD1N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L20N_T3L_N3_AD1N_71
#set_property PACKAGE_PIN B21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L20P_T3L_N2_AD1P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L20P_T3L_N2_AD1P_71
#set_property PACKAGE_PIN C17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L19N_T3L_N1_DBC_AD9N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L19N_T3L_N1_DBC_AD9N_71
#set_property PACKAGE_PIN C18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L19P_T3L_N0_DBC_AD9P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L19P_T3L_N0_DBC_AD9P_71
#set_property PACKAGE_PIN C19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T3U_N12_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T3U_N12_71
#set_property PACKAGE_PIN C20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T2U_N12_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T2U_N12_71
#set_property PACKAGE_PIN D19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L18N_T2U_N11_AD2N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L18N_T2U_N11_AD2N_71
#set_property PACKAGE_PIN D20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L18P_T2U_N10_AD2P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L18P_T2U_N10_AD2P_71
#set_property PACKAGE_PIN D16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L17N_T2U_N9_AD10N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L17N_T2U_N9_AD10N_71
#set_property PACKAGE_PIN D17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L17P_T2U_N8_AD10P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L17P_T2U_N8_AD10P_71
#set_property PACKAGE_PIN D21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L16N_T2U_N7_QBC_AD3N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L16N_T2U_N7_QBC_AD3N_71
#set_property PACKAGE_PIN E21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L16P_T2U_N6_QBC_AD3P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L16P_T2U_N6_QBC_AD3P_71
#set_property PACKAGE_PIN E16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L15N_T2L_N5_AD11N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L15N_T2L_N5_AD11N_71
#set_property PACKAGE_PIN F16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L15P_T2L_N4_AD11P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L15P_T2L_N4_AD11P_71
#set_property PACKAGE_PIN E18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L14N_T2L_N3_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L14N_T2L_N3_GC_71
#set_property PACKAGE_PIN E19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L14P_T2L_N2_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L14P_T2L_N2_GC_71
#set_property PACKAGE_PIN E17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L13N_T2L_N1_GC_QBC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L13N_T2L_N1_GC_QBC_71
#set_property PACKAGE_PIN F18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L13P_T2L_N0_GC_QBC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L13P_T2L_N0_GC_QBC_71
#set_property PACKAGE_PIN F19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L12N_T1U_N11_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L12N_T1U_N11_GC_71
#set_property PACKAGE_PIN F20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L12P_T1U_N10_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L12P_T1U_N10_GC_71
#set_property PACKAGE_PIN G17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L11N_T1U_N9_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L11N_T1U_N9_GC_71
#set_property PACKAGE_PIN G18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L11P_T1U_N8_GC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L11P_T1U_N8_GC_71
#set_property PACKAGE_PIN F21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L10N_T1U_N7_QBC_AD4N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L10N_T1U_N7_QBC_AD4N_71
#set_property PACKAGE_PIN G21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L10P_T1U_N6_QBC_AD4P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L10P_T1U_N6_QBC_AD4P_71
#set_property PACKAGE_PIN H18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L9N_T1L_N5_AD12N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L9N_T1L_N5_AD12N_71
#set_property PACKAGE_PIN H19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L9P_T1L_N4_AD12P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L9P_T1L_N4_AD12P_71
#set_property PACKAGE_PIN G20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L8N_T1L_N3_AD5N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L8N_T1L_N3_AD5N_71
#set_property PACKAGE_PIN H20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L8P_T1L_N2_AD5P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L8P_T1L_N2_AD5P_71
#set_property PACKAGE_PIN G16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L7N_T1L_N1_QBC_AD13N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L7N_T1L_N1_QBC_AD13N_71
#set_property PACKAGE_PIN H17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L7P_T1L_N0_QBC_AD13P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L7P_T1L_N0_QBC_AD13P_71
#set_property PACKAGE_PIN J16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T1U_N12_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T1U_N12_71
#set_property PACKAGE_PIN J17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T0U_N12_VRP_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_T0U_N12_VRP_71
#set_property PACKAGE_PIN J19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L6N_T0U_N11_AD6N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L6N_T0U_N11_AD6N_71
#set_property PACKAGE_PIN J20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L6P_T0U_N10_AD6P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L6P_T0U_N10_AD6P_71
#set_property PACKAGE_PIN J21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L5N_T0U_N9_AD14N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L5N_T0U_N9_AD14N_71
#set_property PACKAGE_PIN K21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L5P_T0U_N8_AD14P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L5P_T0U_N8_AD14P_71
#set_property PACKAGE_PIN K18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L4N_T0U_N7_DBC_AD7N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L4N_T0U_N7_DBC_AD7N_71
#set_property PACKAGE_PIN K19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L4P_T0U_N6_DBC_AD7P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L4P_T0U_N6_DBC_AD7P_71
#set_property PACKAGE_PIN L20      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L3N_T0L_N5_AD15N_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L3N_T0L_N5_AD15N_71
#set_property PACKAGE_PIN L21      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L3P_T0L_N4_AD15P_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L3P_T0L_N4_AD15P_71
#set_property PACKAGE_PIN L18      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L2N_T0L_N3_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L2N_T0L_N3_71
#set_property PACKAGE_PIN L19      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L2P_T0L_N2_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L2P_T0L_N2_71
#set_property PACKAGE_PIN K16      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L1N_T0L_N1_DBC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L1N_T0L_N1_DBC_71
#set_property PACKAGE_PIN K17      [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L1P_T0L_N0_DBC_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  71 VCCO - VCCO_71_F17 - IO_L1P_T0L_N0_DBC_71
#set_property PACKAGE_PIN A8       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L24N_T3U_N11_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L24N_T3U_N11_70
#set_property PACKAGE_PIN A9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L24P_T3U_N10_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L24P_T3U_N10_70
#set_property PACKAGE_PIN A10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L23N_T3U_N9_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L23N_T3U_N9_70
#set_property PACKAGE_PIN A11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L23P_T3U_N8_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L23P_T3U_N8_70
#set_property PACKAGE_PIN A13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L22N_T3U_N7_DBC_AD0N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L22N_T3U_N7_DBC_AD0N_70
#set_property PACKAGE_PIN B13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L22P_T3U_N6_DBC_AD0P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L22P_T3U_N6_DBC_AD0P_70
#set_property PACKAGE_PIN B12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L21N_T3L_N5_AD8N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L21N_T3L_N5_AD8N_70
#set_property PACKAGE_PIN C12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L21P_T3L_N4_AD8P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L21P_T3L_N4_AD8P_70
#set_property PACKAGE_PIN B10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L20N_T3L_N3_AD1N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L20N_T3L_N3_AD1N_70
#set_property PACKAGE_PIN B11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L20P_T3L_N2_AD1P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L20P_T3L_N2_AD1P_70
#set_property PACKAGE_PIN C9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L19N_T3L_N1_DBC_AD9N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L19N_T3L_N1_DBC_AD9N_70
#set_property PACKAGE_PIN C10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L19P_T3L_N0_DBC_AD9P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L19P_T3L_N0_DBC_AD9P_70
#set_property PACKAGE_PIN C13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T3U_N12_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T3U_N12_70
#set_property PACKAGE_PIN C14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T2U_N12_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T2U_N12_70
#set_property PACKAGE_PIN A14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L18N_T2U_N11_AD2N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L18N_T2U_N11_AD2N_70
#set_property PACKAGE_PIN A15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L18P_T2U_N10_AD2P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L18P_T2U_N10_AD2P_70
#set_property PACKAGE_PIN B15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L17N_T2U_N9_AD10N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L17N_T2U_N9_AD10N_70
#set_property PACKAGE_PIN C15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L17P_T2U_N8_AD10P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L17P_T2U_N8_AD10P_70
#set_property PACKAGE_PIN D14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L16N_T2U_N7_QBC_AD3N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L16N_T2U_N7_QBC_AD3N_70
#set_property PACKAGE_PIN D15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L16P_T2U_N6_QBC_AD3P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L16P_T2U_N6_QBC_AD3P_70
#set_property PACKAGE_PIN E14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L15N_T2L_N5_AD11N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L15N_T2L_N5_AD11N_70
#set_property PACKAGE_PIN F15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L15P_T2L_N4_AD11P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L15P_T2L_N4_AD11P_70
#set_property PACKAGE_PIN F13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L14N_T2L_N3_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L14N_T2L_N3_GC_70
#set_property PACKAGE_PIN F14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L14P_T2L_N2_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L14P_T2L_N2_GC_70
#set_property PACKAGE_PIN D12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L13N_T2L_N1_GC_QBC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L13N_T2L_N1_GC_QBC_70
#set_property PACKAGE_PIN E13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L13P_T2L_N0_GC_QBC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L13P_T2L_N0_GC_QBC_70
#set_property PACKAGE_PIN E11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L12N_T1U_N11_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L12N_T1U_N11_GC_70
#set_property PACKAGE_PIN F11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L12P_T1U_N10_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L12P_T1U_N10_GC_70
#set_property PACKAGE_PIN D11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L11N_T1U_N9_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L11N_T1U_N9_GC_70
#set_property PACKAGE_PIN E12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L11P_T1U_N8_GC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L11P_T1U_N8_GC_70
#set_property PACKAGE_PIN D9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L10N_T1U_N7_QBC_AD4N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L10N_T1U_N7_QBC_AD4N_70
#set_property PACKAGE_PIN D10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L10P_T1U_N6_QBC_AD4P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L10P_T1U_N6_QBC_AD4P_70
#set_property PACKAGE_PIN E9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L9N_T1L_N5_AD12N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L9N_T1L_N5_AD12N_70
#set_property PACKAGE_PIN F9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L9P_T1L_N4_AD12P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L9P_T1L_N4_AD12P_70
#set_property PACKAGE_PIN F10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L8N_T1L_N3_AD5N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L8N_T1L_N3_AD5N_70
#set_property PACKAGE_PIN G11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L8P_T1L_N2_AD5P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L8P_T1L_N2_AD5P_70
#set_property PACKAGE_PIN G10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L7N_T1L_N1_QBC_AD13N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L7N_T1L_N1_QBC_AD13N_70
#set_property PACKAGE_PIN H10      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L7P_T1L_N0_QBC_AD13P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L7P_T1L_N0_QBC_AD13P_70
#set_property PACKAGE_PIN H9       [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T1U_N12_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T1U_N12_70
#set_property PACKAGE_PIN G12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T0U_N12_VRP_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_T0U_N12_VRP_70
#set_property PACKAGE_PIN G13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L6N_T0U_N11_AD6N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L6N_T0U_N11_AD6N_70
#set_property PACKAGE_PIN H14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L6P_T0U_N10_AD6P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L6P_T0U_N10_AD6P_70
#set_property PACKAGE_PIN H12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L5N_T0U_N9_AD14N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L5N_T0U_N9_AD14N_70
#set_property PACKAGE_PIN H13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L5P_T0U_N8_AD14P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L5P_T0U_N8_AD14P_70
#set_property PACKAGE_PIN G15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L4N_T0U_N7_DBC_AD7N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L4N_T0U_N7_DBC_AD7N_70
#set_property PACKAGE_PIN H15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L4P_T0U_N6_DBC_AD7P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L4P_T0U_N6_DBC_AD7P_70
#set_property PACKAGE_PIN J11      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L3N_T0L_N5_AD15N_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L3N_T0L_N5_AD15N_70
#set_property PACKAGE_PIN J12      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L3P_T0L_N4_AD15P_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L3P_T0L_N4_AD15P_70
#set_property PACKAGE_PIN J14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L2N_T0L_N3_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L2N_T0L_N3_70
#set_property PACKAGE_PIN J15      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L2P_T0L_N2_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L2P_T0L_N2_70
#set_property PACKAGE_PIN K13      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L1N_T0L_N1_DBC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L1N_T0L_N1_DBC_70
#set_property PACKAGE_PIN K14      [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L1P_T0L_N0_DBC_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  70 VCCO - VCCO_70_G14 - IO_L1P_T0L_N0_DBC_70
#set_property PACKAGE_PIN BF1      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L24N_T3U_N11_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L24N_T3U_N11_69
#set_property PACKAGE_PIN BE1      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L24P_T3U_N10_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L24P_T3U_N10_69
#set_property PACKAGE_PIN BE3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L23N_T3U_N9_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L23N_T3U_N9_69
#set_property PACKAGE_PIN BE4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L23P_T3U_N8_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L23P_T3U_N8_69
#set_property PACKAGE_PIN BE5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L22N_T3U_N7_DBC_AD0N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L22N_T3U_N7_DBC_AD0N_69
#set_property PACKAGE_PIN BE6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L22P_T3U_N6_DBC_AD0P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L22P_T3U_N6_DBC_AD0P_69
#set_property PACKAGE_PIN BF2      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L21N_T3L_N5_AD8N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L21N_T3L_N5_AD8N_69
#set_property PACKAGE_PIN BF3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L21P_T3L_N4_AD8P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L21P_T3L_N4_AD8P_69
#set_property PACKAGE_PIN BG2      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L20N_T3L_N3_AD1N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L20N_T3L_N3_AD1N_69
#set_property PACKAGE_PIN BG3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L20P_T3L_N2_AD1P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L20P_T3L_N2_AD1P_69
#set_property PACKAGE_PIN BG4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L19N_T3L_N1_DBC_AD9N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L19N_T3L_N1_DBC_AD9N_69
#set_property PACKAGE_PIN BG5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L19P_T3L_N0_DBC_AD9P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L19P_T3L_N0_DBC_AD9P_69
#set_property PACKAGE_PIN BF5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T3U_N12_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T3U_N12_69
#set_property PACKAGE_PIN BF6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T2U_N12_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T2U_N12_69
#set_property PACKAGE_PIN BF7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L18N_T2U_N11_AD2N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L18N_T2U_N11_AD2N_69
#set_property PACKAGE_PIN BF8      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L18P_T2U_N10_AD2P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L18P_T2U_N10_AD2P_69
#set_property PACKAGE_PIN BG7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L17N_T2U_N9_AD10N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L17N_T2U_N9_AD10N_69
#set_property PACKAGE_PIN BG8      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L17P_T2U_N8_AD10P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L17P_T2U_N8_AD10P_69
#set_property PACKAGE_PIN BJ7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L16N_T2U_N7_QBC_AD3N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L16N_T2U_N7_QBC_AD3N_69
#set_property PACKAGE_PIN BH7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L16P_T2U_N6_QBC_AD3P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L16P_T2U_N6_QBC_AD3P_69
#set_property PACKAGE_PIN BK8      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L15N_T2L_N5_AD11N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L15N_T2L_N5_AD11N_69
#set_property PACKAGE_PIN BJ8      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L15P_T2L_N4_AD11P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L15P_T2L_N4_AD11P_69
#set_property PACKAGE_PIN BH4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L14N_T2L_N3_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L14N_T2L_N3_GC_69
#set_property PACKAGE_PIN BH5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L14P_T2L_N2_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L14P_T2L_N2_GC_69
#set_property PACKAGE_PIN BJ6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L13N_T2L_N1_GC_QBC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L13N_T2L_N1_GC_QBC_69
#set_property PACKAGE_PIN BH6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L13P_T2L_N0_GC_QBC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L13P_T2L_N0_GC_QBC_69
#set_property PACKAGE_PIN BK4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L12N_T1U_N11_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L12N_T1U_N11_GC_69
#set_property PACKAGE_PIN BK5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L12P_T1U_N10_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L12P_T1U_N10_GC_69
#set_property PACKAGE_PIN BK3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L11N_T1U_N9_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L11N_T1U_N9_GC_69
#set_property PACKAGE_PIN BJ4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L11P_T1U_N8_GC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L11P_T1U_N8_GC_69
#set_property PACKAGE_PIN BJ2      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L10N_T1U_N7_QBC_AD4N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L10N_T1U_N7_QBC_AD4N_69
#set_property PACKAGE_PIN BJ3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L10P_T1U_N6_QBC_AD4P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L10P_T1U_N6_QBC_AD4P_69
#set_property PACKAGE_PIN BH1      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L9N_T1L_N5_AD12N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L9N_T1L_N5_AD12N_69
#set_property PACKAGE_PIN BH2      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L9P_T1L_N4_AD12P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L9P_T1L_N4_AD12P_69
#set_property PACKAGE_PIN BK1      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L8N_T1L_N3_AD5N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L8N_T1L_N3_AD5N_69
#set_property PACKAGE_PIN BJ1      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L8P_T1L_N2_AD5P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L8P_T1L_N2_AD5P_69
#set_property PACKAGE_PIN BL2      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L7N_T1L_N1_QBC_AD13N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L7N_T1L_N1_QBC_AD13N_69
#set_property PACKAGE_PIN BL3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L7P_T1L_N0_QBC_AD13P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L7P_T1L_N0_QBC_AD13P_69
#set_property PACKAGE_PIN BK6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T1U_N12_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T1U_N12_69
#set_property PACKAGE_PIN BL5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T0U_N12_VRP_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_T0U_N12_VRP_69
#set_property PACKAGE_PIN BM3      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L6N_T0U_N11_AD6N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L6N_T0U_N11_AD6N_69
#set_property PACKAGE_PIN BM4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L6P_T0U_N10_AD6P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L6P_T0U_N10_AD6P_69
#set_property PACKAGE_PIN BM5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L5N_T0U_N9_AD14N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L5N_T0U_N9_AD14N_69
#set_property PACKAGE_PIN BL6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L5P_T0U_N8_AD14P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L5P_T0U_N8_AD14P_69
#set_property PACKAGE_PIN BM7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L4N_T0U_N7_DBC_AD7N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L4N_T0U_N7_DBC_AD7N_69
#set_property PACKAGE_PIN BL7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L4P_T0U_N6_DBC_AD7P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L4P_T0U_N6_DBC_AD7P_69
#set_property PACKAGE_PIN BN4      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L3N_T0L_N5_AD15N_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L3N_T0L_N5_AD15N_69
#set_property PACKAGE_PIN BN5      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L3P_T0L_N4_AD15P_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L3P_T0L_N4_AD15P_69
#set_property PACKAGE_PIN BN6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L2N_T0L_N3_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L2N_T0L_N3_69
#set_property PACKAGE_PIN BN7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L2P_T0L_N2_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L2P_T0L_N2_69
#set_property PACKAGE_PIN BP6      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L1N_T0L_N1_DBC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L1N_T0L_N1_DBC_69
#set_property PACKAGE_PIN BP7      [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L1P_T0L_N0_DBC_69
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  69 VCCO - VCCO_69_BG6 - IO_L1P_T0L_N0_DBC_69
#set_property PACKAGE_PIN BE9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L24N_T3U_N11_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L24N_T3U_N11_68
#set_property PACKAGE_PIN BE10     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L24P_T3U_N10_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L24P_T3U_N10_68
#set_property PACKAGE_PIN BF10     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L23N_T3U_N9_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L23N_T3U_N9_68
#set_property PACKAGE_PIN BE11     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L23P_T3U_N8_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L23P_T3U_N8_68
#set_property PACKAGE_PIN BF11     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L22N_T3U_N7_DBC_AD0N_68
#set_property PACKAGE_PIN BF12     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L22P_T3U_N6_DBC_AD0P_68
#set_property PACKAGE_PIN BG9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L21N_T3L_N5_AD8N_68
#set_property PACKAGE_PIN BG10     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L21P_T3L_N4_AD8P_68
#set_property PACKAGE_PIN BG12     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L20N_T3L_N3_AD1N_68
#set_property PACKAGE_PIN BG13     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L20P_T3L_N2_AD1P_68
#set_property PACKAGE_PIN BH9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L19N_T3L_N1_DBC_AD9N_68
#set_property PACKAGE_PIN BH10     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L19P_T3L_N0_DBC_AD9P_68
#set_property PACKAGE_PIN BH11     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_T3U_N12_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_T3U_N12_68
#set_property PACKAGE_PIN BH15     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L18P_T2U_N10_AD2P_68
#set_property PACKAGE_PIN BJ12     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L17N_T2U_N9_AD10N_68
#set_property PACKAGE_PIN BJ13     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_68
#set_property PACKAGE_PIN BK13     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L16N_T2U_N7_QBC_AD3N_68
#set_property PACKAGE_PIN BJ14     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L16P_T2U_N6_QBC_AD3P_68
#set_property PACKAGE_PIN BK9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L12N_T1U_N11_GC_68
#set_property PACKAGE_PIN BJ9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L12P_T1U_N10_GC_68
#set_property PACKAGE_PIN BL8      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L10P_T1U_N6_QBC_AD4P_68
#set_property PACKAGE_PIN BN9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L9N_T1L_N5_AD12N_68
#set_property PACKAGE_PIN BP9      [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L7P_T1L_N0_QBC_AD13P_68
#set_property PACKAGE_PIN BL11     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_T1U_N12_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_T1U_N12_68
#set_property PACKAGE_PIN BM15     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L6N_T0U_N11_AD6N_68
#set_property PACKAGE_PIN BL15     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L6P_T0U_N10_AD6P_68
#set_property PACKAGE_PIN BM13     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L5N_T0U_N9_AD14N_68
#set_property PACKAGE_PIN BN15     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L4P_T0U_N6_DBC_AD7P_68
#set_property PACKAGE_PIN BN12     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L3N_T0L_N5_AD15N_68
#set_property PACKAGE_PIN BP13     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L2N_T0L_N3_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L2N_T0L_N3_68
#set_property PACKAGE_PIN BP14     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L2P_T0L_N2_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L2P_T0L_N2_68
#set_property PACKAGE_PIN BP11     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L1N_T0L_N1_DBC_68
#set_property PACKAGE_PIN BP12     [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_68
#set_property IOSTANDARD  LVCMOSxx [get_ports "No Connect"] ;# Bank  68 VCCO - VCC1V8   - IO_L1P_T0L_N0_DBC_68
#set_property PACKAGE_PIN AV43     [get_ports "No Connect"] ;# Bank 124 - MGTREFCLK0N_124
#set_property PACKAGE_PIN AV42     [get_ports "No Connect"] ;# Bank 124 - MGTREFCLK0P_124
#set_property PACKAGE_PIN AT43     [get_ports "No Connect"] ;# Bank 124 - MGTREFCLK1N_124
#set_property PACKAGE_PIN AT42     [get_ports "No Connect"] ;# Bank 124 - MGTREFCLK1P_124
#set_property PACKAGE_PIN AN41     [get_ports "No Connect"] ;# Bank 126 - MGTREFCLK0N_126
#set_property PACKAGE_PIN AN40     [get_ports "No Connect"] ;# Bank 126 - MGTREFCLK0P_126
#set_property PACKAGE_PIN AM43     [get_ports "No Connect"] ;# Bank 126 - MGTREFCLK1N_126
#set_property PACKAGE_PIN AM42     [get_ports "No Connect"] ;# Bank 126 - MGTREFCLK1P_126
#set_property PACKAGE_PIN AJ41     [get_ports "No Connect"] ;# Bank 128 - MGTREFCLK0N_128
#set_property PACKAGE_PIN AJ40     [get_ports "No Connect"] ;# Bank 128 - MGTREFCLK0P_128
#set_property PACKAGE_PIN AH43     [get_ports "No Connect"] ;# Bank 128 - MGTREFCLK1N_128
#set_property PACKAGE_PIN AH42     [get_ports "No Connect"] ;# Bank 128 - MGTREFCLK1P_128
#set_property PACKAGE_PIN AK47     [get_ports "No Connect"] ;# Bank 128 - MGTYTXN0_128
#set_property PACKAGE_PIN AJ49     [get_ports "No Connect"] ;# Bank 128 - MGTYTXN1_128
#set_property PACKAGE_PIN AJ45     [get_ports "No Connect"] ;# Bank 128 - MGTYTXN2_128
#set_property PACKAGE_PIN AH47     [get_ports "No Connect"] ;# Bank 128 - MGTYTXN3_128
#set_property PACKAGE_PIN AK46     [get_ports "No Connect"] ;# Bank 128 - MGTYTXP0_128
#set_property PACKAGE_PIN AJ48     [get_ports "No Connect"] ;# Bank 128 - MGTYTXP1_128
#set_property PACKAGE_PIN AJ44     [get_ports "No Connect"] ;# Bank 128 - MGTYTXP2_128
#set_property PACKAGE_PIN AH46     [get_ports "No Connect"] ;# Bank 128 - MGTYTXP3_128
#set_property PACKAGE_PIN AG41     [get_ports "No Connect"] ;# Bank 129 - MGTREFCLK0N_129
#set_property PACKAGE_PIN AG40     [get_ports "No Connect"] ;# Bank 129 - MGTREFCLK0P_129
#set_property PACKAGE_PIN AF43     [get_ports "No Connect"] ;# Bank 129 - MGTREFCLK1N_129
#set_property PACKAGE_PIN AF42     [get_ports "No Connect"] ;# Bank 129 - MGTREFCLK1P_129
#set_property PACKAGE_PIN AG49     [get_ports "No Connect"] ;# Bank 129 - MGTYTXN0_129
#set_property PACKAGE_PIN AG45     [get_ports "No Connect"] ;# Bank 129 - MGTYTXN1_129
#set_property PACKAGE_PIN AF47     [get_ports "No Connect"] ;# Bank 129 - MGTYTXN2_129
#set_property PACKAGE_PIN AE45     [get_ports "No Connect"] ;# Bank 129 - MGTYTXN3_129
#set_property PACKAGE_PIN AG48     [get_ports "No Connect"] ;# Bank 129 - MGTYTXP0_129
#set_property PACKAGE_PIN AG44     [get_ports "No Connect"] ;# Bank 129 - MGTYTXP1_129
#set_property PACKAGE_PIN AF46     [get_ports "No Connect"] ;# Bank 129 - MGTYTXP2_129
#set_property PACKAGE_PIN AE44     [get_ports "No Connect"] ;# Bank 129 - MGTYTXP3_129
#set_property PACKAGE_PIN AC41     [get_ports "No Connect"] ;# Bank 130 - MGTREFCLK1N_130
#set_property PACKAGE_PIN AC40     [get_ports "No Connect"] ;# Bank 130 - MGTREFCLK1P_130
#set_property PACKAGE_PIN AA41     [get_ports "No Connect"] ;# Bank 131 - MGTREFCLK1N_131
#set_property PACKAGE_PIN AA40     [get_ports "No Connect"] ;# Bank 131 - MGTREFCLK1P_131
#set_property PACKAGE_PIN AV12     [get_ports "No Connect"] ;# Bank 224 - MGTREFCLK0N_224
#set_property PACKAGE_PIN AV13     [get_ports "No Connect"] ;# Bank 224 - MGTREFCLK0P_224
#set_property PACKAGE_PIN AT12     [get_ports "No Connect"] ;# Bank 224 - MGTREFCLK1N_224
#set_property PACKAGE_PIN AT13     [get_ports "No Connect"] ;# Bank 224 - MGTREFCLK1P_224
#set_property PACKAGE_PIN AN14     [get_ports "No Connect"] ;# Bank 226 - MGTREFCLK0N_226
#set_property PACKAGE_PIN AN15     [get_ports "No Connect"] ;# Bank 226 - MGTREFCLK0P_226
#set_property PACKAGE_PIN AM12     [get_ports "No Connect"] ;# Bank 226 - MGTREFCLK1N_226
#set_property PACKAGE_PIN AM13     [get_ports "No Connect"] ;# Bank 226 - MGTREFCLK1P_226
#set_property PACKAGE_PIN AJ14     [get_ports "No Connect"] ;# Bank 228 - MGTREFCLK0N_228
#set_property PACKAGE_PIN AJ15     [get_ports "No Connect"] ;# Bank 228 - MGTREFCLK0P_228
#set_property PACKAGE_PIN AH12     [get_ports "No Connect"] ;# Bank 228 - MGTREFCLK1N_228
#set_property PACKAGE_PIN AH13     [get_ports "No Connect"] ;# Bank 228 - MGTREFCLK1P_228
#set_property PACKAGE_PIN AK8      [get_ports "No Connect"] ;# Bank 228 - MGTYTXN0_228
#set_property PACKAGE_PIN AJ6      [get_ports "No Connect"] ;# Bank 228 - MGTYTXN1_228
#set_property PACKAGE_PIN AJ10     [get_ports "No Connect"] ;# Bank 228 - MGTYTXN2_228
#set_property PACKAGE_PIN AH8      [get_ports "No Connect"] ;# Bank 228 - MGTYTXN3_228
#set_property PACKAGE_PIN AK9      [get_ports "No Connect"] ;# Bank 228 - MGTYTXP0_228
#set_property PACKAGE_PIN AJ7      [get_ports "No Connect"] ;# Bank 228 - MGTYTXP1_228
#set_property PACKAGE_PIN AJ11     [get_ports "No Connect"] ;# Bank 228 - MGTYTXP2_228
#set_property PACKAGE_PIN AH9      [get_ports "No Connect"] ;# Bank 228 - MGTYTXP3_228
#set_property PACKAGE_PIN AG14     [get_ports "No Connect"] ;# Bank 229 - MGTREFCLK0N_229
#set_property PACKAGE_PIN AG15     [get_ports "No Connect"] ;# Bank 229 - MGTREFCLK0P_229
#set_property PACKAGE_PIN AF12     [get_ports "No Connect"] ;# Bank 229 - MGTREFCLK1N_229
#set_property PACKAGE_PIN AF13     [get_ports "No Connect"] ;# Bank 229 - MGTREFCLK1P_229
#set_property PACKAGE_PIN AG6      [get_ports "No Connect"] ;# Bank 229 - MGTYTXN0_229
#set_property PACKAGE_PIN AG10     [get_ports "No Connect"] ;# Bank 229 - MGTYTXN1_229
#set_property PACKAGE_PIN AF8      [get_ports "No Connect"] ;# Bank 229 - MGTYTXN2_229
#set_property PACKAGE_PIN AE10     [get_ports "No Connect"] ;# Bank 229 - MGTYTXN3_229
#set_property PACKAGE_PIN AG7      [get_ports "No Connect"] ;# Bank 229 - MGTYTXP0_229
#set_property PACKAGE_PIN AG11     [get_ports "No Connect"] ;# Bank 229 - MGTYTXP1_229
#set_property PACKAGE_PIN AF9      [get_ports "No Connect"] ;# Bank 229 - MGTYTXP2_229
#set_property PACKAGE_PIN AE11     [get_ports "No Connect"] ;# Bank 229 - MGTYTXP3_229
#set_property PACKAGE_PIN AD12     [get_ports "No Connect"] ;# Bank 230 - MGTREFCLK0N_230
#set_property PACKAGE_PIN AD13     [get_ports "No Connect"] ;# Bank 230 - MGTREFCLK0P_230
#set_property PACKAGE_PIN AC14     [get_ports "No Connect"] ;# Bank 230 - MGTREFCLK1N_230
#set_property PACKAGE_PIN AC15     [get_ports "No Connect"] ;# Bank 230 - MGTREFCLK1P_230
#set_property PACKAGE_PIN AD8      [get_ports "No Connect"] ;# Bank 230 - MGTYTXN0_230
#set_property PACKAGE_PIN AC10     [get_ports "No Connect"] ;# Bank 230 - MGTYTXN1_230
#set_property PACKAGE_PIN AB8      [get_ports "No Connect"] ;# Bank 230 - MGTYTXN2_230
#set_property PACKAGE_PIN AA6      [get_ports "No Connect"] ;# Bank 230 - MGTYTXN3_230
#set_property PACKAGE_PIN AD9      [get_ports "No Connect"] ;# Bank 230 - MGTYTXP0_230
#set_property PACKAGE_PIN AC11     [get_ports "No Connect"] ;# Bank 230 - MGTYTXP1_230
#set_property PACKAGE_PIN AB9      [get_ports "No Connect"] ;# Bank 230 - MGTYTXP2_230
#set_property PACKAGE_PIN AA7      [get_ports "No Connect"] ;# Bank 230 - MGTYTXP3_230
#set_property PACKAGE_PIN AB12     [get_ports "No Connect"] ;# Bank 231 - MGTREFCLK0N_231
#set_property PACKAGE_PIN AB13     [get_ports "No Connect"] ;# Bank 231 - MGTREFCLK0P_231
#set_property PACKAGE_PIN AA14     [get_ports "No Connect"] ;# Bank 231 - MGTREFCLK1N_231
#set_property PACKAGE_PIN AA15     [get_ports "No Connect"] ;# Bank 231 - MGTREFCLK1P_231
#set_property PACKAGE_PIN AA10     [get_ports "No Connect"] ;# Bank 231 - MGTYTXN0_231
#set_property PACKAGE_PIN Y8       [get_ports "No Connect"] ;# Bank 231 - MGTYTXN1_231
#set_property PACKAGE_PIN W6       [get_ports "No Connect"] ;# Bank 231 - MGTYTXN2_231
#set_property PACKAGE_PIN W10      [get_ports "No Connect"] ;# Bank 231 - MGTYTXN3_231
#set_property PACKAGE_PIN AA11     [get_ports "No Connect"] ;# Bank 231 - MGTYTXP0_231
#set_property PACKAGE_PIN Y9       [get_ports "No Connect"] ;# Bank 231 - MGTYTXP1_231
#set_property PACKAGE_PIN W7       [get_ports "No Connect"] ;# Bank 231 - MGTYTXP2_231
#set_property PACKAGE_PIN W11      [get_ports "No Connect"] ;# Bank 231 - MGTYTXP3_231
########################################################################################################################################################

