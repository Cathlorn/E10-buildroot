#!/bin/bash

uinitk="../br-e10-recv/output/images/uImage"
ukernel="../br1105-main/output/images/uImage"
urootfs="../br1105-main/output/images/rootfs.jffs2"
uscript="../br-e10-recv/jcmod/root/upgrade.sh"
ufilesd="./files"
uarchived="./archive"

echo "Copying files..."
cp $uinitk $ufilesd/uImage-e10i
cp $ukernel $ufilesd/
cp $urootfs $ufilesd/
cp $uscript $ufilesd/

echo "Compiling u-boot environment script"
mkimage -T script -C none -n 'E10 environment update' -A arm -d set-uboot-env files/setenv.img

FILENAME=e10-`date +%Y%m%d%H%M%S`
echo "Creating zip file..."
cd $ufilesd
zip -rD $uarchived/$FILENAME ./*
echo sending file to bluehost
scp $uarchived/$FILENAME.zip iworryfo@jcwoltz.com:public_html/e10/
echo "Done!"

