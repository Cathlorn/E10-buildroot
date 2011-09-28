#!/bin/sh
# 
# Script to bring up wlan
# 20110919 J.C. Woltz <jwoltz@gmail.com>
# 20110920111300 updated with loop to wait for wireless to connect before
#                start dhcp client
# 20110927170800 adding check to see if wlan exists.
# 20110927171548 adding extra statement starting wpa_supplicant
#

/sbin/ifconfig wlan0 | /bin/grep wlan0
if [ $? -eq 0 ]
then

COUNT=0
echo "Starting wpa_supplicant..."
/usr/sbin/wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B
echo "wpa_supplicant exit code: $?"
until [ $COUNT -gt 30 ]; do
  sleep 1
  let COUNT=COUNT+1
  WPASTAT=$(/usr/sbin/wpa_cli -i wlan0 status | grep wpa_state)
  if [ "$WPASTAT" = "wpa_state=COMPLETED" ]
  then
    let COUNT=COUNT+100
    echo $COUNT WPA_STATUS Connected
    break
  else
    if [ "$WPASTAT" = "wpa_state=SCANNING" ]
    then
      echo Scanning $COUNT
    else
      echo $WPASTAT ... $COUNT
    fi
    #/usr/sbin/wpa_cli -i wlan0 status
    #echo $? wpa_cli exit code
  fi
done

HOSTNAME=`cat /etc/hostname`
echo /sbin/udhcpc -i wlan0 --hostname $HOSTNAME -p /var/run/udhcpc-wlan0.pid --background --syslog --arping
/sbin/udhcpc -i wlan0 --hostname $HOSTNAME -p /var/run/udhcpc-wlan0.pid --background --syslog --arping

else
  echo "wlan0 not found"
fi

