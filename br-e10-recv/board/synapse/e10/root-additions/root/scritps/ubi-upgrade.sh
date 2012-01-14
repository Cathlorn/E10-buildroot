
# source the files for the functions
for file in functions/*.sh ; do
  . $file
done

##############################################################################
# Exit Codes:
#  0
#  1	Missing sda1
#  2	Missing upgrade Kernel
#  3	Missing upgrade rootfs
#  4	Missing recovery kernel
#  5	
#  6	
#  7	
#  8	
#  9	
# 10	
##############################################################################


echo
echo "E10 Image upgrader $uversion"
echo
echo 0 > /sys/class/leds/greenled/brightness
echo 0 > /sys/class/leds/redled/brightness
sleep 2
echo "Loading usb-storage"
modprobe usb-storage
sleep 5

load_defines
sanity_checks
upgrade_kernel
upgrade_rootfs_ubifs


