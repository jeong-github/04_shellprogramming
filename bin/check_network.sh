#!/bin/bash

. /root/bin/functions.sh

# (1)local network connection
# (2) external network connection
# (3) dns client configuration

IP1=192.168.10.2
IP2=8.8.8.8
IP3=www.google.com

# (1) Local Network Connection
print_info "(1) ping $IP1"
ping -c 1 $IP1 -W 2 >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    print_good "Local Network Connection"
else
    print_error "Local Network Connection"
    echo "      (a) 물리적인 연결 확인"
    echo "           #ethtool <NIC>    "
    echo "      (b) IP/NETMASK 확인"
    echo "           #ip addr    "
    echo "      (c) VMware VMnet8 설정 "
    echo "            #VMware > Edit > Virtual Network Editor > VMnet8 > 192.168.10.0/255.255.255.0"
    echo "      (d) VMware 서비스 확인"
    echo "           #services.msc > VMware 확인"
fi

# (2) External Network Connection
print_info "(2) ping $IP2"
ping -c 1 $IP2 -W 2 >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    print_good "External Network Connection"
else
    print_error "External Network Connection"
    echo "      (a) ip route (netstat -nr)"

fi

# (3) Dns Client Configuration
print_info "(3) ping $IP3"
ping -c 1 $IP3 -W 2 >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    print_good "Dns Client Configuration"
else
    print_error "Dns Client Configuration"
    echo "      (a) cat /etc/resolv.conf"

fi

