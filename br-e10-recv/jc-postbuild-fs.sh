#!/bin/bash

echo `/bin/date` $1 $2 >> ~/jtmp
cp -av jcmod/* $1 >> ~/jtmp
echo `/bin/date` $1 $2 >> ~/jtmp

