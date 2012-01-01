#!/bin/sh

cd /root
wget http://forums.synapse-wireless.com/upload/Snap-3.0.3-py2.7.tgz
tar -xzvf Snap-3.0.3-py2.7.tgz
mv Snap-3.0.3-py2.7 Snap
wget http://www.jcwoltz.com/e10/UserMain.py
chown root:root /root/UserMain.py
chmod 755 /root/UserMain.py
wget http://www.jcwoltz.com/e10/createSNAPSQLlite.txt
/usr/bin/sqlite3 dc.sqlite < createSNAPSQLlite.txt
mkdir sc
/bin/sync
/sbin/reboot

