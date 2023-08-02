#!/bin/sh

set -xe


# downloads and unpack DMInstall to /tmp/DMInstall
# wget https://download.dameng.com/eco/adapter/DM8/202304/dm8_20230418_x86_rh6_64.zip
# tail -n +415 /mnt/DMInstall.bin| gzip -cdq | tar -xvf -


#cp -rf /tmp/DMInstall/* /opt/dmdbms

#mkdir -p /opt/dmdbms
#cp -rf /tmp/DMInstall/source/* /opt/dmdbms

TPLFILES="
  /opt/dmdbms/bin/DmAuditMonitorService
  /opt/dmdbms/bin/DmInstanceMonitorService
  /opt/dmdbms/bin/DmJobMonitorService
  /opt/dmdbms/bin/DmAPService
  /opt/dmdbms/tool/log4j.xml
"

for tpl in ${TPLFILES};do
    sed -i 's#_REPLACE_SELF_DM_HOME#/opt/dmdbms#' ${tpl}
done
