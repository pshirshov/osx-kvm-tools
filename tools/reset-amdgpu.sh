#!/bin/bash -e
#
#replace xx\:xx.x with the number of your gpu and sound counterpart
#
#
GPUID="0000:23:00"

echo "disconnecting amd graphics"
echo "1" | tee -a /sys/bus/pci/devices/${GPUID}.0/remove
echo "disconnecting amd sound counterpart"
echo "1" | tee -a /sys/bus/pci/devices/${GPUID}.1/remove
echo "entered suspended state press power button to continue"
echo -n mem > /sys/power/state
echo "reconnecting amd gpu and sound counterpart"
echo "1" | tee -a /sys/bus/pci/rescan
echo "AMD graphics card sucessfully reset"

