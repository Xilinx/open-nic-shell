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
set -o nounset                                  # Treat unset variables as an error

if [ $# -ne 2 ]; then
	echo "Usage: p2p_cfg.sh DEVICE_BDF QDMA_ID"
	echo "       DEVICE_BDF: the BDF of device. e.g.: d8"
	echo "       0|1: the first or second QDMA"
	exit 1
fi

PCIMEM_PATH=/home/user/zhiyis/sn1022/pcimem
bdf="$1"
qdma_id="$2"

echo "Ingress port 0"
if [[ "${qdma_id}" -eq 0 ]]; then
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100040 w*1 0
else
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100040 w*1 0x80000000
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100044 w*1 0x0
fi
sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100000 w*1 0x2

echo "Egress port 0"
if [[ "${qdma_id}" -eq 0 ]]; then
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x1000c0 w*1 0x0
else
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x1000c0 w*1 0x1

fi
sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100080 w*1 0x2

echo "Ingress port 1"
if [[ "${qdma_id}" -eq 0 ]]; then
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100140 w*1 0
else
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100140 w*1 0x80000000
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100144 w*1 0x0
fi
sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100100 w*1 0x2

echo "Egress port 0"
if [[ "${qdma_id}" -eq 0 ]]; then
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x1001c0 w*1 0x0
else
	sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x1001c0 w*1 0x1

fi
sudo ${PCIMEM_PATH}/pcimem /sys/bus/pci/devices/0000\:${bdf}\:00.0/resource2 0x100180 w*1 0x2
