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



#ENV DEBIAN_FRONTEND=noninteractive
#
#RUN sed -E -i 's/(archive|security).ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list
#RUN --mount=type=cache,target=/var/cache/apt \
#  apt-get update && \
#  apt-get install -y build-essential cmake libboost-filesystem-dev libboost-system-dev zlib1g-dev
#
#RUN wget https://download.dameng.com/eco/adapter/DM8/202304/dm8_20230418_x86_rh6_64.zip
#
#RUN useradd dmdba
#RUN "$JAVA_EXE_PATH" -Xms256m -Xmx2048m -cp "$INSTALL_HOME/source/tool/plugins/*":"$INSTALL_HOME/source/tool/dropins/com.dameng/plugins/*":"$INSTALL_HOME/source/tool/dropins/com.dameng/plugins/com.dameng.third/*":"$INSTALL_HOME/install/lib/*":"$INSTALL_HOME/install/*" -Djava.library.path="$INSTALL_JAVA_LIBRARY_PATH" -Dsource.dir="$INSTALL_HOME/source" -Dinstall.dir="$INSTALL_HOME/install" -Ddameng.log.file="$INSTALL_HOME/install/log4j.xml" -Ddameng.java.home="$CUSTOM_DM_JAVA_HOME" -Dinstall.file="$2" com.dameng.install.auto.AutoInstall
#RUN DM_INSTALL_TMPDIR=/tmp DM_JAVA_HOME=/tmp/DMInstall/source/jdk sh /tmp/DMInstall/install/install.sh
#RUN /tmp/DMInstall/source/jdk/bin/java -Xms256m -Xmx2048m -Dreplace.dmsvcconf=true -Dnl=en_US -Djava.library.path= -Dsource.dir=/tmp/DMInstall/source -Dinstall.dir=/tmp/DMInstall/install -cp /tmp/DMInstall/source/tool/plugins/*:/tmp/DMInstall/source/tool/dropins/com.dameng/plugins/*:/tmp/DMInstall/source/tool/dropins/com.dameng/plugins/com.dameng.third/*:/tmp/DMInstall/install/lib/*:/tmp/DMInstall/install/* -Ddameng.log.file=/tmp/DMInstall/install/log4j.xml -Ddameng.java.home= com.dameng.install.cli.MainApplication default|server|client|drivers|manual|service|postinstall
#RUN INSTALL_HOME=/tmp/DMInstall DM_JAVA_HOME=/tmp/DMInstall/source/jdk /tmp/DMInstall/source/jdk/bin/java -Xms256m -Xmx2048m -cp "$INSTALL_HOME/source/tool/plugins/*":"$INSTALL_HOME/source/tool/dropins/com.dameng/plugins/*":"$INSTALL_HOME/source/tool/dropins/com.dameng/plugins/com.dameng.third/*":"$INSTALL_HOME/install/lib/*":"$INSTALL_HOME/install/*" -Djava.library.path="$INSTALL_JAVA_LIBRARY_PATH" -Dsource.dir="$INSTALL_HOME/source" -Dinstall.dir="$INSTALL_HOME/install" -Ddameng.log.file="$INSTALL_HOME/install/log4j.xml" -Ddameng.java.home="$DM_JAVA_HOME" -Dinstall.file="/tmp/autoinstall" com.dameng.install.auto.AutoInstall
#
#RUN ./dminit PATH=/opt/dmdbms/data PAGE_SIZE=32 EXTENT_SIZE=32 CASE_SENSITIVE=1 UNICODE_FLAG=0 LENGTH_IN_CHAR=0 SYSDBA_PWD=123456789

