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
wget http://forums.synapse-wireless.com/upload/Snap-3.0.3-py2.7.tgz
tar -xzvf Snap-3.0.3-py2.7.tgz
mv Snap-3.0.3-py2.7 Snap
wget http://www.jcwoltz.com/e10/UserMain.py
chown root:root /root/UserMain.py
chmod 755 /root/UserMain.py
wget http://www.jcwoltz.com/e10/createSNAPSQLlite.txt
/usr/bin/sqlite3 dc.sqlite < createSNAPSQLlite.txt
#mkdir sc
/bin/sync
/sbin/reboot

