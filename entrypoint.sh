#!/bin/sh

set -e

CONN_PWD=\"${ADMIN_PWD}\"

wait_dm_running() {
  for i in `seq 1  10`
  do
    if [ ! -f "/opt/dmdbms/conf/dm.ini" ]; then
       pid=`ps -eo pid,args | grep -F "dmserver /opt/dmdbms/data/${DB_NAME}/dm.ini" | grep -v "grep" | tail -1 | awk '{print $1}'`
    else
       pid=`ps -eo pid,args | grep -F "dmserver /opt/dmdbms/conf/dm.ini" | grep -v "grep" | tail -1 | awk '{print $1}'`
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
    echo `disql /nolog <<EOF
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
  if [ ! -d "/opt/dmdbms/data/${DB_NAME}" ]; then
    OPTS="PAGE_SIZE=${PAGE_SIZE} CASE_SENSITIVE=${CASE_SENSITIVE} UNICODE_FLAG=${UNICODE_FLAG} LENGTH_IN_CHAR=${LENGTH_IN_CHAR} DB_NAME=${DB_NAME} INSTANCE_NAME=${INSTANCE_NAME} CHARSET=${CHARSET}"
    if [ $ADMIN_PWD != "SYSDBA" ] && [ -n $ADMIN_PWD ];then
      OPTS="$OPTS SYSDBA_PWD=${ADMIN_PWD}"
    fi
    echo "init DM with opts: $OPTS"
    dminit PATH=/opt/dmdbms/data $OPTS
    echo "Init DM success!"
    echo "default account: SYSDBA/${ADMIN_PWD}"
  fi

  echo "Start DmAPService..."
  DmAPService start

  echo "Start DMSERVER success!"

  if [ ! -f "/opt/dmdbms/conf/dm.ini" ]; then
    echo "/opt/dmdbms/conf/dm.ini does not exist, use default dm.ini"
    dmserver /opt/dmdbms/data/${DB_NAME}/dm.ini
  else
    dmserver /opt/dmdbms/conf/dm.ini
  fi
}

if [ "${1}" = "serve" ]; then
  start_service
else
  exec ${@}
fi