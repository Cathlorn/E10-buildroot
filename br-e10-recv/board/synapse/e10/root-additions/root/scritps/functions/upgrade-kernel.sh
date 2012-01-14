#!/bin/sh

upgrade_kernel () {
      echo "About to erase Flash for kernel Storage"
      sleep 2
      echo 1 > /sys/class/leds/redled/brightness
      # Main Kernel is stored at 0xA000
      # Secondary Kernel is Stored at 0x400000
      # For Safety Reasons, we now wip one kernel section at a time
      # The count of 20 needs to be calculated
      /usr/sbin/flash_erase -q /dev/mtd0 0xa0000 20
      echo "Done erasing kernel flash"
      sleep 3
      echo "Writing Kernel to flash"
      sleep 2
      #Write new Kernel Image
      /usr/sbin/nandwrite -p -s 0xa0000 /dev/mtd0 /mnt/uImage
      echo
      echo "Writing Backup Kernel to flash"
      /usr/sbin/flash_erase -q /dev/mtd0 0x400000 0
      sleep 3
      /usr/sbin/nandwrite -p -s 0x400000 /dev/mtd0 /mnt/uImage-e10i

}

