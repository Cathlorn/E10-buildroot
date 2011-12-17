#!/bin/sh

cd /root
wget http://jcu.homelinux.org/jc/Snap-3.0.3-py2.7.tgz
tar -xzvf Snap-3.0.3-py2.7.tgz
mv Snap-3.0.3-py2.7 Snap
scp -P 22174 stfu@jcu.homelinux.org:UserMain.py /root/UserMain.py
chown root:root /root/UserMain.py
chmod 755 /root/UserMain.py
