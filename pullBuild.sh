#!/bin/sh
#
# update Repo, build recovery image, build main images, create zip file
#

git pull
cd br-e10-recv && time make && cd ../br-e10-next/ && time make && cd ../package-build/ && ./buildit.sh

