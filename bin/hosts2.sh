#!/bin/bash
#   # cat /etc/hosts
#   192.168.10.10 server10.example.com server10
#   192.168.10.11 server11.example.com server11
#   ....
#   192.168.10.30 server30.example.com server30

#HOSTS=hosts
HOSTS=/root/bin/hosts && > $HOSTS
NET=192.168.10

END = 30

C_IP=$(ifconfig ens160 | grep 'inet addr:' | awk '{print $2}' | awk -F. '{print $4}')

for i in $(seq $START $END)
do
        [ $C_IP = $i ] && continue
        echo "$NET.$i   linux$i.example.com     linux$i" >> $HOSTS
done