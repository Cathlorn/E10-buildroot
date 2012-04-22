#!/bin/sh
#
# Quick script I (J.C. Woltz) use on a freshly updated e10 to
# pull snap connect, extract, download my starter (testing) UserMain.py
# create the sqlite db and reboot.
#
# You can use this if you would like, although you should use your
# own usermain.
#

cd /root
/root/scripts/get-sc.sh
scp -P 22174 stfu@jcu.homelinux.org:UserMain.py /root/UserMain.py
chown root:root /root/UserMain.py
chmod 755 /root/UserMain.py
wget http://www.jcwoltz.com/e10/createSNAPSQLlite.txt
/usr/bin/sqlite3 dc.sqlite < createSNAPSQLlite.txt
#mkdir sc
/bin/sync
/sbin/reboot

