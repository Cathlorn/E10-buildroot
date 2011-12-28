#!/bin/sh

/usr/sbin/flash_erase /dev/mtd0 0xa0000 20
/usr/sbin/nandwrite -p -s 0xa0000 /dev/mtd0 /mnt/uImage
/usr/sbin/flash_erase -q -j /dev/mtd1 0 0
/usr/sbin/nandwrite -a /dev/mtd1 /mnt/rootfs.jffs2

