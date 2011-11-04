#!/bin/bash

echo `/bin/date` $1 $2 >> ~/jtmp
cp -av  board/synapse/e10/root-additions/* $1 >> ~/jtmp
echo `/bin/date` $1 $2 >> ~/jtmp
date -u +%Y%m%d%H%M%S > $1/etc/jc-version
chmod 755 $1/etc/init.d/*
echo UTC > $1/etc/TZ

