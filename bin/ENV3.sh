#!/bin/bash

. /root/bin/functions.sh

#   1) telnet server
#   2) ftp server
#   3) ssh server
#   4) web server


#   1) telnet server
    echo "########## TELNET Server ##########"
    PkgInst "telnet telnet-server"
    SvcEnable   "telnet.socket"

#   2) ftp server
    echo "########## FTP Server ##########"
        PkgInst "vsftpd ftp"
        VsFtpconf
        SvcEnable "vsftpd.service"
#   3) ssh server
    echo "########## SSH Server ##########"
    PkgInst "openssh-server openssh-clients openssh"
    SshConf
    SvcEnable "sshd.service"
#   4) web server
    echo "########## WEB Server ##########"
    WEBSERVER=$(CheckWebSvc "nginx")
    PkgInst "nginx"
    NginxConf
    SvcEnable "nginx.service"

