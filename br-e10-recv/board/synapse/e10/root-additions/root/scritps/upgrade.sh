#!/bin/sh

######################################################################
## Partially generated script ########################################
## 2011-10-25 15:39:43 UTC ###########################################
######################################################################

uversion="2011-10-25 15:39:43"
ukernel="uImage"	#Main Kernel
urootfs="rootfs.jffs2"	#New jffs2 Root Filesystem
uuboot="u-boot-e10.bin"	#New U-boot binary
urkernel="uImage-e10i"	#Recovery/Upgrade/Install kernel
umpath="/mnt"		#Path to mount upgrade files
uvpath="/mntv"		#Path to mount var/log for temporary storage
			#during upgrade and /var/log during runtime

sanity_checks () {
[ -b /dev/sda1] || echo "Missing sda1" && exit 1
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
  exit 6
fi
}

create_varlog_backup () {

cat /proc/mtd | grep mtd4
if [ $? -eq 1]
then
  echo "MTD4 does not exist"
  exit 5
else
  mkdir -p $uvpath
  mkdir /oldroot
  mount -t jffs2 /dev/mtdblock1 /oldroot
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
  umount /oldroot
  umount $uvpath
fi
}


echo
echo "E10 Image upgrader $uversion"
echo
echo 0 > /sys/class/leds/greenled/brightness
echo 0 > /sys/class/leds/redled/brightness
sleep 2
echo "Loading usb-storage"
modprobe usb-storage
sleep 5
if [ -b /dev/sda ]
then
  if [ -b /dev/sda1 ]
  then
    echo "mount usb storage to $umpath"
    mount /dev/sda1 $umpath
    if [ -f "$umpath/$ukernel" ]
    then
      create_varlog_backup
      #/usr/sbin/flash_erase
      #Erase Flash for Kernel upgrade
      echo "About to erase Flash for kernel Storage"
      sleep 2
      echo 1 > /sys/class/leds/redled/brightness
      #for i in `seq 0 27`
      #do
        #/usr/sbin/flash_erase /dev/mtd0 0xa0000 $i
        /usr/sbin/flash_erase /dev/mtd0 0xa0000 0
      #done
      echo "Done erasing kernel flash"
      sleep 3
      echo "Writing Kernel to flash"
      sleep 2
      #Write new Kernel Image
      /usr/sbin/nandwrite -p -s 0xa0000 /dev/mtd0 /mnt/uImage
      echo 
      echo "Writing Backup Kernel to flash"
      sleep 3
      /usr/sbin/nandwrite -p -s 0x400000 /dev/mtd0 /mnt/uImage-e10i
      echo "Formatting /dev/mtd1 for rootfs"
      /usr/sbin/flash_eraseall -q -j /dev/mtd1
      #echo "Formatting /dev/mtd4 for logfs"
      #/usr/sbin/flash_eraseall -q -j /dev/mtd4
      echo "About to write $umpath/$urootfs to mtd1"
      sleep 2
      /usr/sbin/nandwrite -a /dev/mtd1 /mnt/rootfs.jffs2
      echo 0 > /sys/class/leds/redled/brightness
      echo "Done Writing rootfs. If everything is ok, type reboot"
      echo heartbeat > /sys/class/leds/greenled/trigger
    else
      echo 
      echo "Can not find $umpath/$ukernel"
      exit 3
    fi
  else
    echo
    echo "/dev/sda1 does not exist"
    exit 2
  fi
else
  echo
  echo "/dev/sda does not exist"
  exit 1
fi

