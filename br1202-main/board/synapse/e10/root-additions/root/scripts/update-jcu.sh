#!/bin/sh

scp -P 22174 stfu@jcu.homelinux.org:UserMain.py /root/UserMain.py
chown root:root /root/UserMain.py
chmod 755 /root/UserMain.py
