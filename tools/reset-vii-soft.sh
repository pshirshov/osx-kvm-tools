#!/bin/bash -xe

set -x
set -e

radeon=0000:23:00

setpci -s "${radeon}.0" 7c.l=39d5e86b

exit 0
sleep 3

echo "1" | tee -a "/sys/bus/pci/devices/${radeon}.0/remove"
echo "1" | tee -a "/sys/bus/pci/devices/${radeon}.1/remove"
sleep 3
echo "1" | tee -a /sys/bus/pci/rescan

lspci -nnk | grep Radeon
dmesg | tail


