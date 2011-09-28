#!/bin/bash

echo `/bin/date` $1 $2 >> ~/jtmp
cp -av jcmod/* $1 >> ~/jtmp
echo `/bin/date` $1 $2 >> ~/jtmp
date -u +%Y%m%d%H%M%S > $1/etc/jc-version
chmod 755 $1/etc/init.d/*
echo UTC > $1/etc/TZ
rm $1/var/log
mkdir $1/var/log
rm $1/var/spool
mkdir -p $1/var/spool/cron/crontabs
echo "/dev/mtdblock4  /var/log        jffs2   rw,relatime       0 0" >> $1/etc/fstab

