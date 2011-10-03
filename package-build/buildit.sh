#!/bin/bash

tld="/usr/local/src/git/E10-buildroot"
ukernel="$tld/br1105-main/output/images/uImage"
urootfs="$tld/br1105-main/output/images/rootfs.jffs2"
nkernel="$tld/br-e10-next/output/images/uImage"
nrootfs="$tld/br-e10-next/output/images/rootfs.jffs2"
uinitk="$tld/br-e10-recv/output/images/uImage"
uscript="$tld/br-e10-recv/jcmod/root/upgrade.sh"
ufilesd="$tld/package-build/files"
uarchived="$tld/package-build/archive"

echo "Cleaning old files..."
rm $ufilesd/*

echo "Copying files..."
cp $uinitk $ufilesd/uImage-e10i
cp $ukernel $ufilesd/
cp $urootfs $ufilesd/
cp $uscript $ufilesd/

echo "Compiling u-boot environment script"
mkimage -T script -C none -n 'E10 environment update' -A arm -d set-uboot-env files/setenv.img

FILENAMES=e10-1105-`date +%Y%m%d%H%M%S`
FILENAMEN=e10-next-`date +%Y%m%d%H%M%S`
echo "Creating $FILENAMES.zip ..."
cd $ufilesd
zip -rD $uarchived/$FILENAMES ./*

echo "======================================================================"
echo "======================================================================"
echo
echo "Copying E10-Next files..."
cp $nkernel $ufilesd/
cp $nrootfs $ufilesd/
echo "Creating $FILENAMEN.zip ..."
zip -rD $uarchived/$FILENAMEN ./*
echo "======================================================================"
echo "======================================================================"

#echo sending file to bluehost
#scp $uarchived/$FILENAME.zip iworryfo@jcwoltz.com:public_html/e10/
echo "Done!"

