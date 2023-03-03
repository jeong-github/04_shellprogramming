#!/bin/bash

IP1=192.168.10.10
PORT1=1514

while true
do

facility_num="$(expr $RANDOM % 3)"
case $facility_num in
	0) facility="user" ;; 
	1) facility="local0" ;;
	2) facility="kern" ;;
	*) exit 1 ;;
esac

level_num="$(expr $RANDOM % 3)"
case $level_num in 
	0) level="notice" ;;
	1) level="warn" ;;
	2) level="crit" ;;
	*) exit 2 ;;
esac

msg_num="$(expr $RANDOM % 3)"
case $msg_num in 
	0) msg="hello graylog server($RANDOM) from linux200" ;;
	1) msg="test graylog server($RANDOM) from linux200" ;;
	2) msg="**^^** graylog server($RAMDOM) from linux200" ;;
	*) exit 3 ;;
esac

logger -n $IP1 -P $PORT1 -d -p "$facility.$level" "$msg"
sleep 10

done
