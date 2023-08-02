#!/bin/sh

set -e

PAGE_SIZE=32
CASE_SENSITIVE=1
UNICODE_FLAG=0
LENGTH_IN_CHAR=0

ADMIN_PWD=${ADMIN_PWD}
CONN_PWD=\"${ADMIN_PWD}\"
export LANG=en_US.UTF-8

wait_dm_running() {
  for i in `seq 1  10`
  do
    if [ ! -f "/opt/dmdbms/conf/dm.ini" ]; then
       pid=`ps -eo pid,args | grep -F "./dmserver /opt/dmdbms/data/DAMENG/dm.ini" | grep -v "grep" | tail -1 | awk '{print $1}'`
    else
       pid=`ps -eo pid,args | grep -F "./dmserver /opt/dmdbms/conf/dm.ini" | grep -v "grep" | tail -1 | awk '{print $1}'`
    fi
    if [ "$pid" != "" ]; then
      echo "Dmserver is running."
      break
    else
      echo "Dmserver is not running yet..."
      sleep 10
    fi
  done
}

wait_dm_ready() {
  for i in `seq 1  10`
  do
    echo `./disql /nolog <<EOF
CONN SYSDBA/${CONN_PWD}@localhost
exit
EOF` | grep  "connection failure" > /dev/null 2>&1
    if [ $? -eq 0 ];then
      echo "DM Database is not OK, please wait..."
      sleep 10
    else
      echo "DM Database is OK"
      break
    fi
  done
}

start_service() {
  if [ ! -d "/opt/dmdbms/data/DAMENG" ]; then
    cd /opt/dmdbms/bin
    ./dminit PATH=/opt/dmdbms/data PAGE_SIZE=${PAGE_SIZE} CASE_SENSITIVE=${CASE_SENSITIVE} UNICODE_FLAG=${UNICODE_FLAG} LENGTH_IN_CHAR=${LENGTH_IN_CHAR} SYSDBA_PWD=${ADMIN_PWD}
    echo "Init DM success!"
  fi

  cd /opt/dmdbms/bin

  echo "Start DmAPService..."
  ./DmAPService start

  echo "Start DMSERVER success!"

  if [ ! -f "/opt/dmdbms/conf/dm.ini" ]; then
    echo "/opt/dmdbms/conf/dm.ini does not exist, use default dm.ini"
    #./dmserver /opt/dmdbms/data/DAMENG/dm.ini -noconsole > /opt/dmdbms/log/DmServiceDMSERVER.log 2>&1 &
    ./dmserver /opt/dmdbms/data/DAMENG/dm.ini
  else
    #./dmserver /opt/dmdbms/conf/dm.ini -noconsole > /opt/dmdbms/log/DmServiceDMSERVER.log 2>&1 &
    ./dmserver /opt/dmdbms/conf/dm.ini
  fi
}

DM_HOME=/opt/dmdbms
PATH=$DM_HOME/bin:$PATH

if [ "${1}" = "serve" ]; then
  start_service
else
  exec ${@}
fi