#!/bin/sh

ukernel="uImage"
urootfs="rootfs.ubi"
uuboot="u-boot-e10.bin"
urkernel="uImage-e10i"
umpath="/mnt"
uvpath="/mntv"

sanity_checks () {

[ -b /dev/sda1 ] || echo "Missing sda1" && exit 1
[ -f "$umpath/$ukernel" ] || echo "Missing upgrade kernel" && exit 2
[ -f "$umpath/$urootfs" ] || echo "Missing upgrade rootfs" && exit 3
[ -f "$umpath/$urkernel" ] || echo "Missing Recovery Kernel" && exit 4

}

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
fi
}

create_varlog () {
mkdir $uvpath
mkdir /oldroot
mount -t jffs2 /dev/mtdblock1 /oldroot

cat /proc/mtd | grep mtd4
if [ $? -eq 1]
then
  echo "MTD4 does not exist"
else
  mount -t jffs2 /dev/mtdblock4 $uvpath
  if [ $? -eq 0 ]
  then
    echo "Good, mtd4 is already formatted"
    tar -cvf $uvpath/rootbkup.tar /oldroot/root/*
  else
    /usr/sbin/flash_eraseall -q -j /dev/mtd4
    mount -t jffs2 /dev/mtdblock4 $uvpath
    tar -cvf $uvpath/rootbkup.tar /oldroot/root/*
  fi
fi
}

do_upgrade() {
  /usr/sbin/ubiformat /dev/mtd1 -y
  /usr/sbin/ubiattach -m 1
  /usr/sbin/ubimkvol /dev/ubi0 -s 100MiB -N rootfs

}

echo
echo "E10 Image upgrader 20120108"
echo
sleep 2
echo "Loading usb-storage"
modprobe usb-storage
sleep 5
# Make sure all of the files needed exist
sanity_checks
# Check u-boot, if old upgrade
#check_uboot
# Format mtd4 for /var/log persistant storage
#create_varlog
# Backup the /root directory of the e10
#backup_root
# Wipe/format/install new kernel and image
do_upgrade
# restore /root from backup
#restore_root
# Do some extra checks to make sure system will boot

echo
echo "Done!"
echo

#/usr/sbin/ubiformat /dev/mtd1 -y
#/usr/sbin/ubiattach -m 1
#/usr/sbin/ubimkvol /dev/ubi0 -s 100MiB -N rootfs

#/usr/sbin/ubiformat /dev/mtd1 -f /mnt/rootfs.ubi
#/usr/sbin/ubiattach -m 1

