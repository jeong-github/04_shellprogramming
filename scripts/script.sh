#!/bin/bash

egrep -i '(warn|fail|error|crit|alert|emerg)' /var/log/messages > /tmp/.tmp1

while true
do
    sleep 30
    egrep -i '(warn|fail|error|crit|alert|emerg)' /var/log/messages > /tmp/.tmp2
    diff /tmp/.tmp1 /tmp/.tmp2 > /tmp/.tmp3 && continue
    mailx -s "[WARN] Log Mail Check" root < /tmp/.tmp3
    egrep -i '(warn|error|crit|alert|emerg)' /var/log/messages > /tmp/.tmp1
done