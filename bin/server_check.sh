#!/bin/bash
TMP1=/tmp/tmp1

export LANG=en_US.UTF-8
DATE=$(date)
echo -n "Enter your name : "
#read NAME
NAME="Jeong Chan Hyuck"
OS=$(cat /etc/centos-release)
KERNEL=$(uname -sr)
CPUS=$(lscpu | grep '^CPU(s)' | awk '{print $2}')
MEM=$(free -h | grep 'Mem' | awk '{print $2}')
DISKS=$(lsblk -S | awk '$3 == "disk" {print $0}' | wc -l)

cat <<EOF

Server Vul. Checker version 1.0

DATE: $DATE
NAME: $NAME

(1) Server Information
============================================
OS          :$OS
Kernel      :$KERNEL
CPU         : $CPUS 
MEM         : $MEM
DISK        :$DISKS
EOF

nmcli connection  | fgrep -vw ' -- ' | tail -n +2 | awk '{print $4}' > $TMP1
DNS=$(for i in $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
do
    echo -n "$i "
done)


SEQ=$(nmcli connection  | grep -vw ' -- ' | tail -n +2 | wc -l)

for i in $(seq $SEQ)
do
    NIC=$(sed -n "${i}p" $TMP1)
    cat << EOF
NETWORK ${i} ($NIC):
* IP: $(ifconfig $NIC | grep 'inet ' | awk '{print $2}')
* Network: $(ifconfig $NIC | grep 'inet ' | awk '{print $4}')
EOF
done
echo "  *Defaulrouter : $(ip route | grep default | awk '{print $3}')"
echo "  *DNS : $DNS"

# IP=$(cat /etc/sysconfig/network-scripts/ifcfg-ens160 | grep '^IPA')
# GATE=$(cat /etc/sysconfig/network-scripts/ifcfg-ens160 | grep '^GATE')
# DNS=$(cat /etc/sysconfig/network-scripts/ifcfg-ens160 | grep '^DNS')

