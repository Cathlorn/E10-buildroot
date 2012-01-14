#!/bin/sh

load_defines () {

export ukernel="uImage"                #Main Kernel
export jrootfs="rootfs.jffs2"          #New jffs2 Root Filesystem
export urootfs="rootfs.ubi"            #New ubi Root Filesystem
export uuboot="u-boot-e10.bin"         #New U-boot binary
export urkernel="uImage-e10i"          #Recovery/Upgrade/Install kernel
export umpath="/mnt"                   #Path to mount upgrade files
export uvpath="/mntv"                  #Path to mount var/log for temporary storage
                                #during upgrade and /var/log during runtime

export snap="snap-3.0.3.tar.gz"        #This is the snap connect for the E10

}
