#!/bin/sh

upgrade_rootfs_jffs () {
      /usr/sbin/flash_erase -q -j /dev/mtd1 0 0
      #echo "Formatting /dev/mtd4 for logfs"
      #/usr/sbin/flash_eraseall -q -j /dev/mtd4
      echo "About to write $umpath/$urootfs to mtd1"
      sleep 2
      /usr/sbin/nandwrite -a /dev/mtd1 /mnt/rootfs.jffs2
      echo 0 > /sys/class/leds/redled/brightness
      echo "Done Writing rootfs."
}

upgrade_rootfs_ubifs () {
  /usr/sbin/ubiformat /dev/mtd1 -f /mnt/rootfs.ubi
  /usr/sbin/ubiattach -m 1
  echo 0 > /sys/class/leds/redled/brightness
  echo "Done Writing rootfs."
}
