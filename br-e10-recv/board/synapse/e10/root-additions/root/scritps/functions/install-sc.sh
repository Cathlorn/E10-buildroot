#!/bin/sh

install_sc () {
if [ -f $umpath/$snap ]
then
  echo heartbeat > /sys/class/leds/redled/trigger
  echo "Unpacking $snap onto new FileSystem"
  mount -t jffs2 /dev/mtdblock1 /oldroot
    if [ $? -eq 0 ]
    then
      echo "Mounted rootfs"
      mkdir -p /oldroot/root/tmp
      cd /oldroot/root/tmp
      tar -xzvf $umpath/$snap
      mv /oldroot/root/tmp/Snap-3.0.3-py2.7 /oldroot/root/Snap
      /bin/sync
      umount /oldroot
    else
      echo "Unable to mount rootfs. Aborting SnapConnect install."
      echo "You will need to install Snap Connect yourself"
    fi
  echo none > /sys/class/leds/redled/trigger
else
  echo "$snap not found on USB Drive!"
fi
}

