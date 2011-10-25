#!/bin/sh

F=upgrade.sh
DT=`date -u +"%Y-%m-%d %H:%M:%S"`

echo "#!/bin/sh" > $F
echo >> $F
echo "######################################################################" >> $F
echo "## Partially generated script ########################################" >> $F
echo "## $DT UTC ###########################################" >> $F
echo "######################################################################" >> $F
echo >> $F

echo uversion=\"$DT\" >> $F
cat upgrade.txt >> $F
chmod 755 $F
ls -l $F

