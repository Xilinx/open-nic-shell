# OpenNIC Shell

OpenNIC shell delivers an FPGA-based NIC shell with 100Gbps Ethernet ports.  The
latest version is built with Vivado 2020.2.  Currently, the supported boards
include

- Xilinx Alveo U250,
- Xilinx Alveo U280, and
- Bittware 250-SoC.

The NIC shell consits of skeleton compoents which implement host and ethernet
interfaces and two user logic boxes that wraps up user RTL plugins.  Its
architecture is shown in the figure below.

    -----  -----------------------------------------------
    |   |  |            System Config                    | 
    |   |  -----------------------------------------------
    |   |     |         |         |         |         |  AXI-lite 125MHz
    |   |     V         V         V         V         V
    |   |  -------   -------   -------   -------   -------
    |   |  |     |   |     |   |     |   |     |   |     |
    | P |  |  Q  |==>| Box |==>|  A  |==>| Box |==>|  C  |
    | C |  |  D  |   |  @  |   |  D  |   |  @  |   |  M  |
    | I |  |  M  |   | 250 |   |  A  |   | 322 |   |  A  |
    | E |  |  A  |<==| MHz |<==|  P  |<==| MHz |<==|  C  |
    |   |  |     | | |     | | |     | | |     | | |     |
    -----  ------- | ------- | ------- | ------- | -------
                   |         |         |         |
                   -----------         -----------
                 AXI-stream 250MHz   AXI-stream 322MHz

The shell skeleton has the following compoents.

- QDMA subsystem.  It includes the Xilinx QDMA IP and RTL logic that bridges the
  QDMA IP interface and the 250MHz user logic box.  The interfaces between QDMA
  subsystem and the 250MHz box use a variant of the AXI4-stream protocol.  Let
  us refer the variant as the 250MHz AXI-stream.
- CMAC subsystem.  It includes the Xilinx CMAC IP and some wrapper logic.
  OpenNIC shell supports either 1 or 2 CMAC ports.  In the case of 2 CMAC ports,
  there are two instances of CMAC subsystems with dedicated data and control
  interfaces.  The CMAC subsystem runs at 322MHz and connects to the 322MHz user
  logic box using a variant of the AXI4-stream protocol.  Similarly, let us refer
  the variant as the 322MHz AXI-stream.
- Packet adapter.  It is used to convert between the 250MHz AXI-stream and
  322MHz AXI-stream.  On both TX and RX paths, the packet adapter serves as a
  packet-mode FIFO, which buffers the whole packet before sending out.  On the
  RX path, it also restores the back-pressure capability which is missing from
  the CMAC subsystem interface.
- System config.  It implements a reset mechanism and allocates the register
  addresses for each components.  The register interface uses AXI4-lite protocol
  and runs at 125MHz, which is phase-aligned with the 25MHz clock.

There are 2 user logic boxes, one running at 250MHz and the other at 322MHz.
Each has a AXI-lite interface for register, 2 pairs of slave and master
AXI-stream interfaces for TX and RX respectively.  User RTL plugins are
responsible for implementing the handling of these interfaces.

## Repo Structure

The `open-nic-shell` repository is organized as follows.

    |-- open-nic-shell --
        |-- constr --
            |-- au250 --
            |-- au280 --
            |-- ... --
        |-- plugin --
            |-- p2p --
        |-- script --
            |-- board_settings --
            |-- build.tcl
            |-- ...
        |-- src --
            |-- box_250mhz --
            |-- box_322mhz --
            |-- cmac_subsystem --
            |-- packet_adapter --
            |-- qdma_subsystem --
            |-- system_config --
            |-- utility --
            |-- zynq_usplus_ps --
            |-- open_nic_shell.sv
            |-- ...
        |-- LICENSE.txt
        |-- README.md
        |-- ...

Most of the directories are self-explanatory.  The code under `src` contains the
skeleton compoents and the "empty" boxes.  Sample plugins are available under
the `plugin` directory.

## How to Build

OpenNIC shell is built by running the Tcl script `build.tcl` under `script` in
Vivado.  Depending on the target device, the build script generates proper files
for flash programming.

It is recommended to build the design with Internet connection, as it relies on
updated Xilinx board files, accessible through [Xilinx Board
Store](https://github.com/Xilinx/XilinxBoardStore).  The build script
automatically updates Vivado against this repository.  See the below section for
build without Internet/Github access.

### Build Script Options

To start building the shell, run the following command under `script` with a
proper `MODE` choice (i.e., `tcl`, `batch` or `gui`).

    vivado -mode MODE -source build.tcl -tclargs [-OPTION VALUE] ...

A list of options are available to configure the the build process and customize
the design parameters.

    # Build options

    -board_repo  PATH
                 path to local Xilinx board store repository for offline build.
                 This option is used when Vivado is unable to connect to github
                 and update the board repository.

    -board       BOARD_NAME
                 supported boards include:
                 - au250,
                 - au280, and
                 - soc250.

    -tag         DESIGN_TAG
                 string to identify the build.  The tag, along with the board
                 name, becomes part of the build directory name.

    -overwrite   0 (default), 1
                 indicate if the script should overwrite existing build results.

    -jobs        [1, 32] (default to 8)
                 number of jobs for synthesis and implementation.

    -synth_ip    0, 1 (default)
                 indicate if IPs are out-of-box synthesized after creation.

    -impl        0 (default), 1
                 indicate if the script runs towards bitstream generation.  If
                 set to 0, the script only creates the project and do not launch
                 any run.

    -post_impl   0 (default), 1
                 indicate if the script performs post implementation actions:
                 for Zynq family (e.g., soc250), 1 means generating the XSA file
                 after bitstream; for FPGAs (e.g., au250), 1 means generating
                 the MCS file.

    -sdnet       PATH
                 path to the SDNet executable.  If specified, a Tcl variable
                 sdnet will be available to user plugin build scripts.

    -user_plugin PATH
                 path to the user plugin repository where a Tcl script build.tcl
                 is expected.

    # Design parameters

    -build_timestamp VALUE
                     VALUE should be an 8-digit hexdecimal value without prefix.
                     It serves as the timestamp to identify the build and is
                     written into the shell register 0x0.  If not specified, the
                     date and time of the build is recorded using the format
                     MMDDhhmm, where MM is for month, DD for day, hh for hour
                     and mm for minute.

    -min_pkt_len     [64, 256] (default to 64)
                     minimum packet length.

    -max_pkt_len     [256, 9600] (default to 1514)
                     maximum packet length.

    -use_phys_func   0, 1 (default)
                     indicates if the QDMA H2C and C2H AXI-stream interfaces are
                     included in the 250MHz user logic box.  A common scenario
                     for not using them is networking accelerators without DMA.
                     Regardless the value of this option, the QDMA IP is always
                     present in the shell since it also provide the AXI-lite
                     interfaces for register access.

    -num_phys_func   [1, 4] (default to 1)
                     number of QDMA physical functions.

    -num_queue       [1, 2048] (default to 2048)
                     number of QDMA queues

    -mum_cmac_port   1 (default), 2
                     number of CMAC ports.

### Build Process

The build process involves four steps.

1. IP creation and optionally, out-of-box synthesis.
2. Design project setup.
3. Synthesis, implementation and bitstream generation.
4. Post-processing.

By default, the script completes the first two steps, producing a Vivado project
under the build directory.  This can be customized using the `-synth_ip`,
`-impl` and `-post_impl` options.

- If `-synth_ip` is set to 0, the IP out-of-box synthesis is deferred.
- If `-impl` is set to 1, the third step is performed.
- If `-post_impl` is set 1, the post-processing step is performed after
  bitstream generation.

The build directory is located under `build` and named as `[BOARD]_[TAG]`.
Under the build directory, there is a text file, `DESIGN_PARAMETERS`, which
contains the parameters passed to the RTL top-level.  All the IP files are
stored under `vivado_ip`.  The shell project is under `open_nic_shell`.

The following Verilog macros are defined and made avaiable to the RTL source
code.

- The `__synthesis__` macro.
- Board name.  Valid names include `__au250__`, `__au280__` and `__soc250__`.
- The `__zynq_family__` macro if the device is in the Zynq family.

### Build without Github Access from Vivado

If Vivado does not have access to Github, we need to have a local copy of the
[Xilinx Board Store](https://github.com/Xilinx/XilinxBoardStore) repository, and
pass the path to the build script via the `-board_repo` option.

### Board Support Package for SoC-250

The standard Petalinux flow for flash programming Bittware SoC-250 requires a
customized board support package (BSP).  It is created from a ZynqMP template,
adding changes which have been documented in the BSP creation guide from
Bittware, which is available at [Bittware Developer
Site](https://developer.bittware.com/) once registered.  The guide is targetd on
Petalinux/Vivado 2018.3.  Thus we need to adapt the changes to Petalinux/Vivado
2020.2 accordingly.  Due to policy reasons, the BSP file is only provided upon
request.

## User Plugin Integration

OpenNIC shell provides 2 user logic boxes for instantiating custom RTL logic,
one running at 250MHz and the other at 322MHz.  To build with custom plugins,
pass the path of the plugin repository to the `-user_plugin` argument of the
build script.  Default plugins are available for both boxes under
`plugin/p2p/box_250mhz` and `plugin/p2p/box_322mhz` respectively, which does
simple port-to-port connection.  If users are interested in only one box, they
should instantiate the default plugin in the other one.

Each box requires a top-level wrapper for all the user plugins instantiated in
that box.  In other words, only one module should be instantiated in each box.
There are a few rules on how to structure the `-user_plugin`.  At a minimum
level, it should look like the following.

    |-- USER_PLUGIN_DIR --
        |-- box_250mhz --
            |-- user_plugin_250mhz_inst.vh
            |-- box_250mhz_address_map_inst.vh
            |-- box_250mhz_address_map.v
            |-- box_250mhz_axi_crossbar.tcl
        |-- box_322mhz --
            |-- user_plugin_322mhz_inst.vh
            |-- box_322mhz_address_map_inst.vh
            |-- box_322mhz_address_map.v
            |-- box_322mhz_axi_crossbar.tcl
        |-- ... --
        |-- build_box_250mhz.tcl
        |-- build_box_322mhz.tcl
        |-- ...

The files under `box_250mhz` and `box_322mhz` are glue code that connects the
user plugins to OpenNIC shell.

- `user_plugin_XXXmhz_inst.vh` is a Verilog header file that instantiates the
  top-level wrapper.  It is included into `src/box_XXXmhz/box_XXXmhz.sv`.
- `box_XXXmhz_address_map_inst.vh` is a Verilog header file that instantiates
  the `box_XXXmhz_address_map` module.  It is included into
  `src/box_XXXmhz/box_XXXmhz.sv`.
- `box_XXXmhz_address_map.v` implements the register address mapping in
  `box_XXXmhz`.
- `box_XXXmhz_axi_crossbar.tcl` creates the AXI crossbar IP instantiated in
  `box_XXXmhz_address_map.v`.

Currently, these files need to be created and modified manually.  In the next
release, they will be auto-generated through a configuration file.

For each box, the build script performs the following steps.

1. Source `box_XXXmhz_axi_crossbar.tcl`.
2. Read `box_XXXmhz_address_map.v`.
3. Add `USER_PLUGIN_DIR/box_XXXmhz` to the `include_dirs` property.
4. Source `build_box_XXXmhz.tcl`.

To use the default plugin (i.e., `plugin/ptp`) in one of the boxes, remove the
corresponding `box_XXXmhz` directory and `build_box_XXXmhz.tcl`.

## Shell Interface

Shell and user logic boxes communicates through 3 types of interfaces.

- AXI-lite interface running at 125MHz for register access.
- AXI-stream interface running at either 250MHz or 322MHz for data path.
- Synchronous reset interface running at 125MHz.

The 125MHz and 250MHz clock domains are phase aligned.  Signals can be sampled
across each domain without clock domain crossing.  On the other hand, do note
that different clock frequencies can lead to double sampling or missing samples.

The AXI-lite interface follows the standard AXI4-lite protocol without `wstrb`,
`awprot` and `arprot`.  At the system level, the address ranges for the 2 boxes
are

- 0x10000 - 0x3FFFF for the 322MHz box, and
- 0x40000 - 0xFFFFF for the 250MHz box.

The 250MHz and 322MHz AXI-stream interfaces have slightly different sematics.
The 250MHz interface has the following signals.

- `tvalid`, 1 bit: same as standard AXI4-stream protocol.
- `tdata`, 512 bits: data maps from lower to upper bytes.
- `tkeep`, 64 bits: null bytes are only allowed when both TVALID and TLAST are
  asserted and cannot be followed by other data bytes for the same packet. For
  example, a 96B packet has a TKEEP value of 0xFFFFFFFFFFFFFFFF in the first
  beat, and 0x00000000FFFFFFFF in the second beat.
- `tlast`, 1 bit: same as standard AXI4-stream protocol.
- `tuser_size`, 16 bits: field to specify packet size. It contains the number of
  bytes in the packet and must remain valid and unchanged if TVALID is asserted.
- `tuser_src`, 16 bits: source of the packet.
- `tuser_dst`, 16 bits: destination of the packet.
- `tuser_user`, N bits: sideband user data.
- `tready`, 1 bit: same as standard AXI4-stream protocol.

For the `tkeep` signal, the interface assumes its presence depending on the
direction of a packet.

- For packets exiting the shell, it is guaranteed that `tkeep` is consistent
  with `tuser_size`.  This means that `tkeep` consists of all 1s when `tvalid`
  is asserted and `tlast` is de-asserted and shows a bitmask for the valid bytes
  in the beat when both `tvalid` and `tlast` are asserted.
- For packets entering the shell, `tkeep` can be optionally set to all 1s
  regardless of the value of `tuser_size`.  This allows user plugins to drop
  `tkeep` in their implementation.  If `tkeep` is not set to all 1s, it must be
  consistent with `tuser_size`.
  
For `tuser_src` and `tuser_dst`, they have the following format.  For packets
exiting the shell, `tuser_src` is marked accordingly and `tuser_dst` is all 0s.

    ----------------------------------------------------
    | 15                         6 |    4 |          0 |
    |------------------------------|------|------------|
    | P  P  P  P  P  P  P  P  P  P | R  R | F  F  F  F |
    |------------------------------|------|------------|
    |            MAC ports         | Rsvd |  PCIe PFs  |
    ----------------------------------------------------

The 322MHz interface is more restrictive due to requirements from CMAC IP.  It
has the following signals.

- `tvalid`, 1 bit: no de-assertion in the middle of a packet.  In other words,
  once `tvalid` is asserted to indicate the start of packet, it must remain
  asserted until `tlast`.
- `tdata`, 512 bits: same as in the 250MHz interface.
- `tkeep`, 64 bits: same as in the 250MHz interface.
- `tlast`, 1 bit: same as in the 250MHz interface.
- `tuser_err`, 1 bit: indicates if the packet contains an error.
- `tready`, 1 bit: same as in the 250MHz interface.  But packets entering the
  shell, i.e., from the RX side of CMAC IPs, the `tready` signal is not present
  and the master side assumes that `tready` is always asserted.

## Known issues

Here are the known issues and the potential workarounds.

### Kernel panic/reboot while programming the FPGA

When loading bitstream onto the Alveo U250 board using Vivado's hardware
manager, kernel panic occurred and the system rebooted automatically before the
process was complete.  On subsequent tries it worked in 50% of the cases.

There are a few solutions for different use cases.

- A potential fix is to disable PCIe fatal error reporting and clearing out SERR
  in the command register.  [This
  post](http://alexforencich.com/wiki/en/pcie/disable-fatal) describes the fix.
- Another workaround is to use a different server/workstation to program the
  board, i.e., launching Vivado on a different server/workstation and connecting
  the JTAG/USB cable there.

### Server fails to boot after programming the FPGA

A warm reboot is needed after loading the bitstream onto the FPGA.  But this
reboot fails with the error message: "A PCIe link training failure is observed
in Slot1 and the link is disabled".

For Dell servers, there is a temporary hack [discussed
here](https://forums.xilinx.com/t5/PCIe-and-CPM/PCIE-link-training-error-on-DELL-R730/m-p/806428).
The trick is to issue a second "warm reboot" command using iDRAC while the
system is rebooting and before PCIe endpoint detection.  The hypothesis is that
this gives enough time to load the configuration on the FPGA.  This seems to be
working so far.

### CMAC license issue when building the design

This error was seen when some people tried to build the hardware.

ERROR: [Common 17-69] Command failed: This design contains one or more cells for
which bitstream generation is not permitted:
`cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/i_cmac_usplus_0_top
(<encrypted cellview>)`.  If a new IP Core license was added, in order for the
new license to be picked up, the current netlist needs to be updated by
resetting and re-generating the IP output products before bitstream generation.

Since the 100G MAC is hardened in Ultrascale+, `cmac_usplus` has a free license.
Go to [www.xilinx.com/getlicense](www.xilinx.com/getlicense).  After login,
click "Search Now" in the "Evaluation and No Charge Cores" box on the right side
of the page.  You will see a popup with a "Search" box at top left.  Enter
"100G" in the search box.  You will see "UltraScale+ Integrated 100G Ethernet No
Charge License".  Select this and click "Add".  A screenshot could be found
![here](vivado_cmac.png).

---

# Copyright Notice and Disclaimer

This file contains confidential and proprietary information of Xilinx, Inc. and
is protected under U.S. and international copyright and other intellectual
property laws.

DISCLAIMER

This disclaimer is not a license and does not grant any rights to the materials
distributed herewith.  Except as otherwise provided in a valid license issued to
you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NONINFRINGEMENT, OR
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether
in contract or tort, including negligence, or under any other theory of
liability) for any loss or damage of any kind or nature related to, arising
under or in connection with these materials, including for any direct, or any
indirect, special, incidental, or consequential loss or damage (including loss
of data, profits, goodwill, or any type of loss or damage suffered as a result
of any action brought by a third party) even if such damage or loss was
reasonably foreseeable or Xilinx had been advised of the possibility of the
same.

CRITICAL APPLICATIONS

Xilinx products are not designed or intended to be fail-safe, or for use in any
application requiring failsafe performance, such as life-support or safety
devices or systems, Class III medical devices, nuclear facilities, applications
related to the deployment of airbags, or any other applications that could lead
to death, personal injury, or severe property or environmental damage
(individually and collectively, "Critical Applications"). Customer assumes the
sole risk and liability of any use of Xilinx products in Critical Applications,
subject only to applicable laws and regulations governing limitations on product
liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT
ALL TIMES.
