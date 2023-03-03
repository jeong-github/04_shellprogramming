###########################
1장 네트워크관리
############################
주소종류
MAC(48bits, 6bytes)
네트워크 세그먼트의 데이터 링크 계층 통신을 위한 네트워크 인터페이스에 할당된 고유 식별자, 이더넷상에서 통신할 때 사용하는 주소
IP Address
컴퓨터 네트워크에서 장치들이 서로를 인식하고 통신을 하기 위해서 사용하는 특수한 번호이다.
IPv4(32 bits, 4bytes)
	192.168.10.20
IPv4 주소
A class : 0~127 	(사설ip) 10.x.x.x
B class : 128~191 	(사설ip) 172.16.x.x~172.31.x.x
C class : 192~223	(사설ip) 192.168.x.x
	Multicast주소
D class : 224~ 239
IPv6(128 bits, 16bytes)
	fe80::c6e:48aa:4aaa:4b5f
Port Address
서비스를 구분하는 번호

네트워크 관련 설정 파일들
	/etc/hosts
	/etc/host.con
	/etc/resolv.conf
	/etc/sysconfig/network-scripts/ifcfg-*
	
네트워크 관련 명령어들
ethtoll ens33
(CLI) ip addr
(TUI) ip route
(GUI) cat /etc/resolv.conf
네트워크 설정 관련 툴
	nmcli
	nmtui
	nm-connection-editor

네트워크 시나리오 작업
	ip 변경 작업
	NIC 추가 작업
	호스트 이름 변경
	팀 구성, 본딩 구성
(ㄱ)team 0	
nmcli connection add \
type team \
ifname team0 \
con-name team0 \
team.runner activebackup

(ㄴ)team 0 (team0-port1, team0-port2)
nmcli connection add \
type ethernet \
slave-type team \
ifname ens160 \
con-name team0-port1 \
master team0

nmcli connection add \
type ethernet \
slave-type team \
ifname ens35 \
con-name team0-port2 \
master team0

(ㄷ)team0(IP)  
nmcli connection modify team0 \
ipv4.method manual \
ipv4.addresses 192.168.10.100/24 \
ipv4.gateway 192.168.10.2 \
ipv4.dns 168.126.63.1 \
ipv4.dns-serch example.com

(ㄹ)team0(활성화)
nmcli connection up team0

COMMON_OPTIONS:
                  type <type>
                  ifname <interface name> | "*"
                  [con-name <connection name>]
                  [autoconnect yes|no]
                  [save yes|no]
                  [master <master (ifname, or connection UUID or name)>]
                  [slave-type <master connection type>]

    team:         [config <file>|<raw JSON data>]
    team-slave:   master <master (ifname, or connection UUID or name)>
                  [config <file>|<raw JSON data>]

  IP_OPTIONS:
                  [ip4 <IPv4 address>] [gw4 <IPv4 gateway>]
                  [ip6 <IPv6 address>] [gw6 <IPv6 gateway>]

nmcli connection add \
type team \
ifname team0 \
con-name team0 \
config ‘{“runner”: {“name”: “activebackup”}}’


복원 network 설정을 작업하기 전 상태로 돌리기(ens33, ens36) 
ens33 IP(192.168.10.20/24), GW(192.168.10.2), DNS(168.126.63.1)
ens36 not profile/



eth0 설정을 따로하는 것이 아닌 설정을 ᄄᆞ로 만들어 필요시에 설정을 eth0에 적용시켜줌
###########################
2장 네트워크관리
############################
Selinux모드
	enforcing
	permissive
	disabled
Selinux Contxt
	semanage fcontext –l
	semanage fcontext –a –t httpd_Sys_content
	restorecon –RV /virtual
Selinux Boolean
	semanage boolean –l

	setsebool –P httpd_enable_httpd on
Selinux Port

Selinux Troubleshooting
(ㄱ) 문제원인 파악
cat /var/log/messages | grep –i preventing
sealert –l UUID
or
cat /var/log/audit/audit.log | grep –i ‘avc:  denied’
sealert –a /var/log/audit/audit.log

(ㄴ) 문제해결 방법
Selinux context 문제 해결
Selinux boolean 문제 해결
Selinux port 문제해결
###########################
3장 서버방화벽
##########################
firewalld(nftables)
방화벽 설정 툴
	(CLI) firewall-cmd CMD
	(GUI)firewall-config (firewall-config 패키지)

firewall-cmd CMD
	fireall-cmd —permanent --add-service-http –add-service-https
	irewall-cmd —permanent —add-port-1521/tcp
	firewall-cmd --reload







방화벽은 소스코드를 검사하고 해당소스주소가 특정 zone에 할당되어있는 경우 배제한다.
1. 소스주소를 우선으로 봄
2. 인터페이스에대한 방화벽 규칙
3. 

*ckckpit  웹서버에서 서버를 관리하기위해 사용하는거
###########################
4장 dns
##########################
-----------------------------------------------
DNS 서버 구성 절차
(ㄱ) 패키지 설치
	yum install bind bind-utils
(ㄴ) 서비스 구성
	vi /etc/named.com
	vi /etc/named.rfc1912.zones
	vi /var/named/example.zone
	vi /var/named/example.rev
(ㄷ) 서비스 가동
	systemctl enable --now named.serviece
(ㄹ) 방화벽 등록
	firewall-cmd  --permanent --add-serviece-dns
	firewall-cmd --reload
(ㅁ)	SELinux
	좀 복잡해서 패스한다고 하심 
----------------------------------------------------------
[실습] 초기 도메인 관리 - /etc/hosts
[실습] BIND DNS 서버 기본 설정 확인
[실습] DNS 서버 구축 – Root(.) Domain/.com Domain DNS 서버 구축
[실습] nslookup CMD
[실습] DNS 서버 구축 –Root(.) Domain/.com Domain DNS 서버 구축
[실습] nslookup CMD
[실습] DNS 서버 구축 – example.com Domain DNS 서버 구축
[실습] DNS 서버 구축 – test.com Domain DNS 서버 구축
[실습] 도메인 등록
[실습]DNS 부하 분산
[실습]D도메인 위임
[실습]Mster/Slave DNS 서버 구축
[실습]rndc실습
	* allow-update, nsupdate CMD
[보안] DNS 설정 보안점검
[보안] DNS 보안 관련 문서
[보안] DNS 보안 관련 이슈
	*chroot 환경
	*dns 프로그램 업데이트/패치
	*dns 지시자
	*allow-notify, allow-query, allow-transfer, match-clients
	*최근 보안 이슈
	https://www.boho.or.kr/data/secNoticeList.do

	*DNSSec
----------------------------------------------------------

/etc/hosts
/etc/resolv.conf
cat /var/named/example.zon

/etc/hosts
/etc/resolv.conf
server1(named)


■ 수업시에 사용하는 도메인 이름 체계와 구축 DNS 서버 종류
● Root(.)/.com DNS Server	- 192.168.10.10 
● example.com DNS Server 	- 192.168.10.20
● test.com DNS Server     	- 192.168.10.30


yum config-manager —disable google-chrome


ens160

###########################
5장 WEB Server
##########################
■ 프로그램	: httpd, mod_ssl
■ 데몬 & 포트	: httpd(80/tcp, 443/tcp)
■ 설정 파일	: /etc/httpd/conf/httpd.conf
■ 하위 설정 파일	: /etc/httpd/conf.d/*.conf
■ 서비스	: httpd.service

---------------------------------------------------
(ㄱ) 패키지 설치
	yum install httpd mos_ssl
(ㄴ) 서비스 구성
	vi /etc/httpd/conf/httpd.conf
	vi /etc/httpd/conf.d/*.conf
	echo ‘MyServer’ > /var/www/html/index.html
(ㄷ) 서비스 가동
	systemctl enable —now httpd.service
(ㄹ) 방화벽 등록
	firewall-cmd —permanent —add-service=(http)
	firewall-cmd —reload

---------------------------------------------------
[실습] 초기 웹서버 설정 점검	
[실습] 관리자 웹 서버 구축(www.example.com)
[실습] 클라이언트 프로그램 사용
[실습] 사용자 웹 서버 구축(www.example.com/~user01)
	# vi /etc/httpd/conf.d/userdir.conf(UserDir public_html)
	$ chmod 711 /home/user01
	$ mkdir –p /home/user01/public_html
	$ echo ‘User01WebPage’ > /home/user01/public_html/index.html 
[실습] 사용자 웹 서버 구축2
	vi /etc/httpd/conf/httpd.conf 에 들어가서 alias 지정
	Alias /user01 /home/user01/public_html
[실습] CGI설정 – bash 쉘
	/etc/httpd/conf.d/vhost.conf(ScriptAlias /cgi-bin/ /www1/chi-bin/)
[실습] CGI설정 – per1 사용    (참고 epel-elease	패키지 설치 필요)
	yum install mod perl
	/etc/httpd/conf.d/perl.conf
[실습] PHP 사용
	yum install php
	/etc/httpd/conf.d/php.conf
[실습] (보안) .htaccess 파일
	/etc/httpd/conf.d/vhost.conf(AllowOverride AuthConfig) -->라는걸 넣음
	/www1/cgi-bin/.htaccess
	htpasswd –c /etc/httpd/passwd webmaster
[실습] 가상호스트
	이름 기반 가상 호스트
	ip 기반 가상 호스트
	port 기반 가상 호스트
[실습] 웹 서버 정보/상태/통계 모니터링
	정보
	상태
	통계
[실습] 웹 스트레스 툴
	webstress
[실습] 버전 정보/OS 정보 숨기기
	
[실습] ATJM(Apache + Tomcat + JSP + MariaDB)
	Apache|nginx|IIS – Tomcat|oss
[보안] 웹방화벽



www1                      IN A            192.168.10.30 
www2                      IN A            192.168.10.30        
www3                      IN A            192.168.10.30   








 #
 # Sfecific configuration
 #
 # export PS1='[\u@\h \w]\$ '
 export PS1='\[\e[31;1m\][\u@\h\[\e[33;1m\] \w]\$ \[\e[m\]'
 alias grep='grep --color=auto -i'
 alias pps='ps -ef | head -1 ; ps -ef | grep $1'
 alias vi='/usr/bin/vim'
 alias vi='vim'
 alias df='df -h -T'
 alias c='clear'
 alias chrome='/usr/bin/google-chrome --no-sandbox'
 alias fwcmd='firewall-cmd'
 alias fwlist='firewall-cmd --list-all'
 alias fwload='firewall-cmd --reload'

*************************************기억하면 좋다넹**********************
[참고] 클라이언트 쪽에서 확인 방법
	# ping 192.168.10.30 -c 1			-> server2 alive 확인
	# nmap -p 80,443 192.168.10.30		-> server2 firewall 설정
	# firefox http://192.168.10.30	-> httpd.service 기동/설정
	# firefox http://www.example.com	-> dns 설정
###########################
6장 WEB Server
##########################
■ 프로그램	: vsftpd, ftp
■ 데몬 & 포트	: vsftpd()21/tcp, 20/tcp or 1024~/tcp)
■ 설정 파일	: /etc/vsftpd/vsftpc.conf
■ 하위 설정 파일	: /etc/vsftpd/*
■ 서비스	: fsftpd.service
---------------------------------------------------------
FTP 서버 구성 절차
(ㄱ)패키지 설치
	yum install vsftpd ftp
(ㄴ) 서비스 구성
	vi /etc/vsftpd/vsftpd.conf
	vi /etc/vsftpd/(ftpusers,user_list)
(ㄷ) 서비스 기동
	systemctl enable —now vsftpd.service
(ㄹ) 방화벽 등록
	firewall-cmd —permanent —add-service=ftp
	firewall-cmd —reload
---------------------------------------------------------------
[실습]	초기 FTP 서버 설정 점검
[실습]	vsftpd FTP 서버 구축
[실습]	FTP 서버 사용자 접근 제어
	* /etc/fsftpd/{ftpusers, user_list}
	userlist_enable=YES
	userlist_deny=NO
	# echo
[실습]	클라이언트 프로그램
	(GUI) filezilla, (CLI) ftp CMD
[실습]	세션 타임 아웃 설정
	vi /etc/vsftpd/vsftpd.conf
	idle_session_timelout=900
	data_connection_timeout=900
[실습]	일반사용자 chroot 구성
	chroot_local user=YES
	allow writeable_chroot=YES
	chroot_list_enable=YES
	chroot_list_file=/etc/vsftpd/chroot_list
	# echo root > /etc/vsftpd/chroot_list
[실습]	익명 FTP enable
	vi /etc/vsftpd/vsftpd.conf
	anonymous_enable=YES 으로 설정
[실습]	익명 FTP 업로드 가능 설정
	/var/ftp/pub/incoming(603)
	useradd -d /var/ftp/pub/incoming -r -s /sbin/nologin ftpupload
	
	vi /etc/vsftpd/vsftpd.conf
	anon_upload_enable=YES
	chown_uploads=YES
	chown_username=ftpupload
[실습]	FTP 보안
	(접근 제어)
	호스트 접근 제어 -> firewalld
	사용자 접근 제어 -> /etc/vsftpd/(user_list.ftpusers)
		userlist_deny=NO, /etc/vsftpd/user_list		권장
	(자원 제어)
	max_clients, max_per_ip
	idle_session_timeout, data_connection_timeout
	(패키지 업데이트/패치)
	yum update vsftpd
	(chroot구성)
	(ftp -> sftp/ftps)
	(FTP포트)
ACTIVE MODE				PASSIVE MODE
연결 설정등은 21 번포트 이용		연결 설정등은 21 번포트 이용
(hash, bin 등)				(hash, bin 등)

데이터 전송은 20번 포트 이용		데이터 전송은 랜덤한 높은 포트 이용
(ls 와같은 명령)				(ls 와같은 명령)
	(FTP포트)
	/var/log/secure
	/var/log/xferlog
###########################
7장 MAIL Server
##########################
-------------------------------------------------
용어:
	MTA, MUA
	SMTP/ESMTP, POP3, IMAP4
----------------------------------------------------
MAIL		Server
■ 프로그램	: sendmail, sendmail-cf
■ 데몬 & 포트	: sendmail(25/tcp, 465/tcp)
■ 설정 파일	: /etc/mail/sendmail.cf
■ 하위 설정 파일	: /etc/mail/*, /tec/aliases
■ 서비스	: sendmail.service

POP3/ IMAP4	Server
■ 프로그램	: devocot
■ 데몬 & 포트	: dovecot(110/tcp, 143/tcp, 995/tcp, 993/tcp)
■ 설정 파일	: /etc/dovecot/dovect.conf
■ 하위 설정 파일 : 
■ 서비스	: dovecot.service
---------------------------------------------------------
MAIL 서버 구성 절차
(ㄱ)패키지 설치
	yum install sendmail	mailx
(ㄴ) 서비스 구성
	vi /etc/mail/sendmail.cf
	vi /etc/mail/*
(ㄷ) 서비스 기동
	systemctl enable --now sendmail.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service={smtp,smtps}
	firewall-cmd —reload

POP/IMAP 서버 구성 절차
(ㄱ)패키지 설치
	yum install dovecot
(ㄴ) 서비스 구성
	vi /etc/dovecot/dovecot.conf
	vi /etc/dovecot/conf.d/*.conf
(ㄷ) 서비스 기동
	systemctl enable --now dovecot.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service={pop3,pop3s,imap,imaps}
	firewall-cmd —reload
-----------------------------------------------------------
[실습] 초기 MAIL(sendmail) 서버 설정 점검
[실습] 초기 POP3/IMAP(dovecot) 서버 설정 점검
[실습] MIL/POP3/IAMP 서버 구축	- example.com
[실습] MIL/POP3/IAMP 서버 구축	- test.com
[실습] 메일 보내고 받기
[실습] 메일 포워딩
	/etc/aliases
[실습] 메일 리스트
	/etc/aliases
[실습] 메일 클라이언트
	(GUI) evolution
	(CLI) mail/mailx CMD
[실습] 웹메일 - 다람쥐 메일
hsts

cilents					server
http://www.example.com 	-->	
				<--
https://www.example.com 

[실습]*********시간날때 읽어보기*********
spamssessin	
ClamAV
###########################
8장 NFS Server
##########################
-------------------------------------------------
NFS 버전: NFSv3, NFSv4(4.0, 4.1, 4.2)
NFS 버전: nfsd, mountd
NFS 파일: (서버) /etc/exports, (클라이언트) /etc/fstab
NFS 명령: (서버) exportfs CMD, (클라이언트) showmount CMD, mount CMD
-------------------------------------------------
NFS V4 Server
■ 프로그램	: nfs-utils
■ 데몬 & 포트	: nfsd(2049/tcp)
■ 설정 파일	: /etc/exports
■ 서브 설정 파일	: /etc/exports.d/*.exports
■ 서비스	: nfs-server,service
----------------------------------------------------------------
NFS 서버 구성 절차
(ㄱ)패키지 설치
	yum install nfs-utils
(ㄴ) 서비스 구성
	vi /etc/exports
	vi /etc/exports.d/*.exportfs
(ㄷ) 서비스 기동
	systemctl enable --now nfs-server.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
	firewall-cmd —reload
----------------------------------------------------------------
[실습] 초기 NFS 서버 설정 점검
[실습] NFS 서버/클라이언트
[실습] root_squash/no_root_squash 공유 옵션
[실습] MAN Page Server
[실습] Home Directory Server
[실습] 원격 CD 마운트
[실습] 원격 백업 서버 구축
[실습] LB WEB1/WEB2-NAS 실습

###########################
9장 SMB/CIFS Server
##########################
-------------------------------------------------
CIFS = SMB + NETBIOS
SMB 관련 명령: (S)	(C) smbclient CMD, (mount|umount).cifs CMD
-------------------------------------------------
■ 프로그램: samba, samba-clinet, cifs-utils
■ 데몬 & 포트 : smbd(139/tcp, 445/tcp), nmbd(137/udp, 138/udp)
■ 주 설정 파일: /etc/samba/smb.conf
■ 서비스: smb.service, nmb.service
------------------------------------------------
SAMBA 서버 구성 절차
(ㄱ)패키지 설치
	yum install samba samba-client cifs-utils
(ㄴ) 서비스 구성
	vi /etc/samba/smb.conf
	
(ㄷ) 서비스 기동
	systemctl enable --now smb.service nmb.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service=samba
	firewall-cmd —reload
--------------------------------------------------------
[실습] 초기 SMB/CIFS 서버 설정 점검
[실습] 리눅스 공유 서버에 윈도우 클라이언트 접근
[실습] 윈도우 공유 서버에 리눅스 클라이언트 접근
[실습] 리눅스 공유 서버에 리눅스 클라이언트 접근



-------보고서 작성------

[주제]SSH 연구 보고서

* 암호화 통신(https, ssh)




SSH explain
SSH .pdf

###########################
10장 Log Server
##########################
자원/로그 모니터링
	*OS 기록:
		/var/log/messages
		/var/log/secure
		/var/log/boot.log
		/var/log/{wtmp,btmp}
	*서비스 기록:
		(DNS)/var/log/messages
		(WEB)/var/log/httpd/*
		(FTP)/var/log/xferlog
*rsyslog 체계(/etc/rsyslog.conf)
------------------------------------------------------
■ 프로그램: rsyslog
■ 데몬 & 포트 : rsyslogd
■ 주 설정 파일: /etc/rsyslog.conf
■ 하위설정파일: /etc/rsyslog.d
■ 서비스: rsyslog.service
-----------------------------------------------------------
LOG Server  구성 절차
(ㄱ)패키지 설치
	yum install rsyslog
(ㄴ) 서비스 구성
	vi /etc/samba/smb.conf
	
(ㄷ) 서비스 기동
	systemctl enable --now smb.service nmb.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-port={514/tcp,514/udp}
	firewall-cmd --permanent --add-service=syslog=tls
	firewall-cmd —reload
--------------------------------------------------------------------
[실습] 초기 로그 서버 설정 점검
[실습] 기본 로그 파일(인증 로그 기록, /var/log/secure)
[실습] 기본 로그 파일(메일 로그 기록, /var/log/maillog)
[실습] 기본 로그 파일(스케줄러 기록, /var/log/cron)
[실습] 새로운 로그 파일(/var/log/file.log)
	*쉘 스크림트를 사용한 로그 생성
	*rsyslog 체계 사용한 로그 생성(logger CMD)
[실습] 

[실습] 로그 파일 분석
	메세지 난이도
	메세지 시간(cat file.log | egrep '~~~~~')
	메세지 생성 주체
	메세지 생성 서버
	단어 검사
[실습] system journal
	/etc/systemd/journald.conf
	->/run/log/journal
	->/var/log/journal
journal CMD
	# journalctl -p warning
	# journalctl --since ... -util ...
	# journalctl -u named -f
###########################
11장 DHCP Server
##########################
■ 프로그램: dhcp-server, dhcp-client
■ 데몬 & 포트 : dhcp(67/udp)
■ 주 설정 파일: /etc/dhcp/dhcp.conf
■ 서비스: dhcp.service
-----------------------------------------------------------
DHCP Server  구성 절차
(ㄱ)패키지 설치
	yum install dhcp-server dhcp-client
(ㄴ) 서비스 구성
	vi /etc/dhcp/dhcpd.conf
(ㄷ) 서비스 기동
	systemctl enable --now dhcpd.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-port={dhcp,dhcp-client,dhcpv6}
	firewall-cmd --reload
-----------------------------------------------------------
[실습] 초기 서버설정 점검
[실습] DHCP 서버구성
[실습] 초기 서버설정 점검
###########################
12장 SSH Server
##########################
■ 프로그램: open-ssh, openssh-server
■ 데몬 & 포트 : sshd(22/tcp)
■ 주 설정 파일: /etc/ssh/sshd_config
■ 서비스: sshd.service
-----------------------------------------------------------
DHCP Server  구성 절차
(ㄱ)패키지 설치
	yum install openssh openssh-server
(ㄴ) 서비스 구성
	vi /etc/ssh/sshdO_config
(ㄷ) 서비스 기동
	systemctl enable --now sshd.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-port=ssh
	firewall-cmd --reload
-----------------------------------------------------------
[실습] 초기 서버 설정 점검
[실습] telnet vs ssh
[실습] 인증키 실습 (prikey, pubkey) 실습
[실습] 공개키 인증 방식
[실습]	cmd.sh/copy.sh -> Ansible
[실습] 사용자 접근 제어
	*접근 제어
	-호스트 접근제어 (firewalld)
	-사용자 접근제어 (/etc/ssh/sshd_config(AllowUsers|AllowGroups))
[실습] root 사용자에 대한 Password Authentication
	*/etc/ssh/sshd_config
	-PermitRootLogin yes
	-PasswordAuthentication yes
[실습] SSH listen port 변경
[실습] SSH X11 Fowarding
	# ssh -X CMD
[실습] SSH X11 Fowarding
[실습] SSH Port Fowarding
	ssh local port fowarding
	ssh Remote port fowarding
[실습] 리욱스에 원격데스트톱으로 연결하기
	WIN --> (XRDP) --> (VNC Server) Linux
-------------------------------------------------------------
###########################
13장 NTP Server
##########################
■ 프로그램: chrony
■ 데몬 & 포트 : chronyd(123/udp)
■ 주 설정 파일: /etc/chronyd
■ 서비스: chronyd.service
-----------------------------------------------------------
NTP Server 
(ㄱ)패키지 설치
	yum install chrony
(ㄴ) 서비스 구성
	vi /etc/chrony.conf
(ㄷ) 서비스 기동
	systemctl enable --now chronyd.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service=
	firewall-cmd --reload
-----------------------------------------------------------
[실습] 초기 서버 설정 점검
[실습] NTP 서버 구성 - main
[실습] NTP 클라이언트 구성 - server1
[실습] NTP 클라이언트 구성 - server2
###########################
14장 DB Server
##########################
DB Server
■ 프로그램: mariadb, mariadb-server
■ 데몬 & 포트 : mysqld(3306/tcp)
■ 주 설정 파일: /etc/my.cnf
■ 하위 설정 파일: /etc/my.cnf.d/*.cnf
■ 서비스: mariadb
-----------------------------------------------------------
DB Server 
(ㄱ)패키지 설치
	yum install mariadb mariadb-server
(ㄴ) 서비스 구성
	vi /etc/my.cnf
(ㄷ) 서비스 기동
	systemctl enable --now mariadb.service
(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service=mysql
	firewall-cmd --reload
(ㅁ) 초기 설정
	mysql_swcure_installation
	mysql -u root -p
-----------------------------------------------------------
[실습] 초기 서버 설정 점검
[실습] DB관리
[실습] Table관리
[실습] DB Table 관리
[실습] 사용자 관리

----------------------------------------------------------
###########################
15장 ISCSI Tatget/Initiator
##########################
------------------------------------
용어
	target,initiator
	iqn,portal
	tcp,acl
	discovery,login
--------------------------------
iSCSI Target
■ 프로그램		: targetcli
■ 데몬 & 포트 		: iscsid(3260/tcp)
■ 주 설정 파일		: /etc/target/saveconfig.json
■ 하위 설정 파일	: /etc/iscsi/initiatorname.iscsi
■ 서비스		: target.service

iSCSI Initiatior
■ 프로그램		: iscsi-initiator-utils
■ 데몬 & 포트 		: iscsid
■ 주 설정 파일		: /etc/iscsi/iscsid.conf
■ 하위 설정 파일	: /etc/iscsi/initiatorname.iscsi
■ 서비스		: iscsid.service
-----------------------------------------------------------
iSCSI Target Configuration

(ㄱ)패키지 설치
	yum install targetcli
(ㄴ) 서비스 기동
	systemctl enable --now targetcli.service
(ㄷ) 서비스 구성
	자원생성
	targetcli
	>exit

(ㄹ) 방화벽 등록
	firewall-cmd --permanent --add-service=iscsi-target
	firewall-cmd --reload

iSCSI Inittiator Configuration
(ㄱ)패키지 설치
	yum install iscsi-initiator-utils
(ㄴ) 서비스 기동
	vi /etc/iscsi/initiatorname.iscsi		(이름을 알아야 접속하니깐 설정)
	systemctl enable --now iscsid.service

(ㄷ) 검색
	iscsiadm -m discovery -t st -p 192.168.10.20

(ㄹ) 로그인
	iscsiadm -m node -T -IQN -p PORTAL -l	(IQN ->이름 검색하면 나오는이름) 
(ㅁ) 작업
	lsblk
	적당한 작업
	
----------------------------------------------------------
명령어

vi
1G 첫 번째 줄
2G 두 번째 줄


cat /etc/resolv.conf		DNS서버 파일

nslookup -q=NS example.com

httpd –t			오타있나 테스트

journalctl –u CMD –f		CMD에대한 명령어 상태 모니터링
ex) 
journalctl -f 로 살펴보기
오류인 로그를 찾음 


firewall-cmd -—list-all		방화벽 연결된리스트 출력

숫자, 숫자s/^/#/			숫자~숫자까지 찾아서 첫번쨰부분을 #으로 치환

sed -i 's/~/~/' 		치환


