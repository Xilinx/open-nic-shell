# Usage: Export GUI and DUT before calling this.

onerror {
quit -f -code 1
}

set pli [exec cocotb-config --lib-name-path vpi questa]
if {${env(GUI)}} {
    set onfinish "stop"
} else {
    set onfinish "exit"
}

# README: After exporting simulation for the top level module, Vivado will
# create a "<top module>_simulate.do" file that specifies all the libraries that
# need to be linked. These are copied from there.

# Simulation libraries generated using Vivado 2021.2
vsim -voptargs=+acc -onfinish $onfinish \
    -L xil_defaultlib -L axis_infrastructure_v1_1_0 -L axis_register_slice_v1_1_25 \
    -L axis_switch_v1_1_25 -L axi_infrastructure_v1_1_0 -L fifo_generator_v13_2_6 \
    -L axi_clock_converter_v2_1_24 -L generic_baseblocks_v2_1_0 -L axi_register_slice_v2_1_25 \
    -L axi_data_fifo_v2_1_24 -L axi_crossbar_v2_1_26 -L unisims_ver -L unimacro_ver -L secureip \
    -L xpm -lib xil_defaultlib \
    -pli $pli \
    xil_defaultlib.${env(DUT)} xil_defaultlib.glbl

# # Simulation libraries generated using Vivado 2021.2, including VitisNetP4 toolchain
# vsim -voptargs=+acc -onfinish $onfinish \
#     -L xil_defaultlib -L axis_infrastructure_v1_1_0 -L axis_register_slice_v1_1_25 \
#     -L axis_switch_v1_1_25 -L cam_v2_2_2 -L vitis_net_p4_v1_0_2 -L axi_infrastructure_v1_1_0 \
#     -L fifo_generator_v13_2_6 -L axi_clock_converter_v2_1_24 -L generic_baseblocks_v2_1_0 \
#     -L axi_register_slice_v2_1_25 -L axi_data_fifo_v2_1_24 -L axi_crossbar_v2_1_26 -L unisims_ver \
#     -L unimacro_ver -L secureip -L xpm \
#     -lib xil_defaultlib \
#     -pli $pli \
#     xil_defaultlib.${env(DUT)} xil_defaultlib.glbl

log -recursive /*

if {${env(GUI)}} {
    add log -r *
} else {
    onbreak resume
    run -all
    quit
}