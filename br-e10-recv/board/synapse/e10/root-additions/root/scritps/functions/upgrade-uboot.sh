#!/bin/sh

upgrade_uboot () {

if [ -f "$umpath/$uuboot" ]
then
  echo "Erasing U-Boot. DO NOT POWER OFF!!!"
  /usr/sbin/flash_erase /dev/mtd0 0x20000 1
  /usr/sbin/flash_erase /dev/mtd0 0x20000 2
  echo "Flashing U-Boot..."
  /usr/sbin/nandwrite -p -s 0x20000 /dev/mtd0 $umpath/$uuboot
  echo "U-Boot upgrade exit code $?"
  sleep 5
else
  echo "U-Boot upgrade file missing $umpath/$uuboot"
  exit 6
fi

}

