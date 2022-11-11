#!/bin/bash
set -Eeuo pipefail

if [[ -z ${DUT:-} ]]; then
    echo "Usage: DUT=<top level module to test> [GUI=1 DEBUG=1] run.sh"
    echo "Please specify DUT."
    exit 1
fi

MODELSIM_LOC=${MODELSIM_LOC:-"$HOME/opt/modelsim/modelsim-se_2020.1/modeltech/linux_x86_64"}
if [[ ! -d $MODELSIM_LOC ]]; then
    echo "Please export MODELSIM_LOC to point to the directory containing vsim executable."
    exit 1
fi

# Reference: https://docs.cocotb.org/en/stable/custom_flows.html
export LIBPYTHON_LOC=$(cocotb-config --libpython)
if [[ -z $LIBPYTHON_LOC ]]; then
    echo "Please install cocotb."
    exit 1
fi

export MODULE=test_${DUT}
export TOP_LEVEL=${DUT}

if [[ ${DEBUG:-} == "1" ]]; then
    export COCOTB_SCHEDULER_DEBUG=1
    export COCOTB_PDB_ON_EXCEPTION=1
fi

if [[ -f ./${DUT}.sv ]]; then
    echo "Compiling $DUT"
    vlog -64 -incr -sv -work xil_defaultlib ./${DUT}.sv
else
    echo "./${DUT}.sv not found. Not compiling $DUT"
fi

if [[ ${GUI:-} == "1" ]]; then
    SIM_ARGS="-gui"
else
    GUI=0
    SIM_ARGS="-c"
fi

GUI=$GUI DUT=$DUT $MODELSIM_LOC/vsim -64 ${SIM_ARGS} -do "do {run.do}" -l simulate.log