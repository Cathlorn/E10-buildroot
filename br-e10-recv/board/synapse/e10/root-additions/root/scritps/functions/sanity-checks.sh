#!/bin/sh

sanity_checks () {

[ -b /dev/sda1 ] || echo "Missing sda1" && exit 1
[ -f "$umpath/$ukernel" ] || echo "Missing upgrade kernel" && exit 2
[ -f "$umpath/$urootfs" ] || echo "Missing upgrade rootfs" && exit 3
[ -f "$umpath/$urkernel" ] || echo "Missing Recovery Kernel" && exit 4

}

