#!/bin/sh

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

