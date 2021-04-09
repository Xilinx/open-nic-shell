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
#! /bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: program_device.sh DEVICE_BDF"
    exit 1
fi

device_bdf="0000:$1"
bridge_bdf=""

if [ -e "/sys/bus/pci/devices/$device_bdf" ]; then
    bridge_bdf=$(basename $(dirname $(readlink "/sys/bus/pci/devices/$device_bdf")))

    # COMMAND register: clear SERR# enable
    sudo setpci -s $bridge_bdf COMMAND=0000:0100
    # DevCtl register of CAP_EXP: clear ERR_FATAL (Fatal Error Reporting Enable)
    sudo setpci -s $bridge_bdf CAP_EXP+8.w=0000:0004
fi

echo "FPGA is ready to be programmed."
echo "Open Vivado hardware manager and do one of the following."
echo "1. Program devcie using generated bitstream."
echo "2. Add a configuration memory and program it.  After programming, boot"
echo "   from the configuration memory."
echo ""
echo "Press [c] when either 1 or 2 is completed..."
read -s -n 1 key
while [ "$key" != "c" ]; do
    echo "Press [c] when either 1 or 2 is completed..."
    read -s -n 1 key
done

echo "Doing PCI-e link re-scan..."
if [ -e "/sys/bus/pci/devices/$device_bdf" ]; then
    echo 1 | sudo tee "/sys/bus/pci/devices/${bridge_bdf}/${device_bdf}/remove" > /dev/null
    echo 1 | sudo tee "/sys/bus/pci/devices/${bridge_bdf}/rescan" > /dev/null
else
    echo 1 | sudo tee "/sys/bus/pci/rescan" > /dev/null
fi

# COMMAND register: enable memory space access
sudo setpci -s $device_bdf COMMAND=0x02

echo "setup_device.sh completed"
