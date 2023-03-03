배시 쉘 프로그래밍

1. 선수지식

1) 명령어
grep CMD
	# grep OPTTIONS PATTERNS file1
	OPTIONS: -i, -v, -l, -n, -r, -w
	PATTERNS: *	.	^root	root$	[abc]	[a-c]	[^a]
sed CMD
	# 
awk DMC

2) 쉘의 특성
* Redirection(<, 0<, >, 1>, >>, 1>>, 1>, 2>>)
* Pipe( | )
* Variable
* Matacharacter('', "". ``, ;)
* History
* Alias
* Function
	(선언) fun()	[cmd; cmd;]
	(실행) fun
	(확인) typeset -f
	(해제) unset -f fun
* Environment File(s) (/etc/profile, ~/.bash_profile, ~/.bashrc)

* cat CMD + <<
* grouping
* &&, ||
* dirname/basename CMD
* eval CMD

2.Shell Script/Shell Programing

(1) 프로그램 작성과 실행	
	# bash -x script.sh
	# . ~/.bashrc
	# vi script.sh ; chmod +x script.sh ; ./script.sh
	# vi script.sh ; chmod +x script.sh ; ./script.sh
	[참고] 매직넘버(#!/bin/bash)
(2) 주석처리
	# 한줄 주석	-#
	# 여러줄 주석	- : << EOF ~ EOF

(3) 입력 출력
	출력: echo CMD, printf CMD
	입력: read CMD
(4) 산술연산
 expr 1 + 4    /* 더하기 */
 expr 4 - 1    /* 빼기   */
 expr 4 ∖* 3  /* 곱하기 */
 expr 10 / 2   /* 나누기 */
 expr 10 % 3   /* 나머지 */

(5) 조건문: if문, case 문
	*if 문
	if 조건; then
		statement 1
	elif 조건; then
		statement 2
	els
		statement 3
	fi
	*case 문
		case VAR in
		조건1) statement1 ;;
		조건2) statement2 ;;
		*)	statement3;;
	seac

ex) 이 3가지를 한꺼번에 하고싶네
# svc.sh sshd	sshd
	# systemctl enable sshd
	# systemctl restart sshd
	# systemctl status sshd
 
(6) 반복문: for 문 , while 문
	for문: for 문 + seq cmd
	for var in var_list
do
	statement
done
	while문: while 문 + continue/break/shift
	while 조건
	do
		statement
	done

(7) 함수
	선언) fun() {CMD; CMD;}
	      function fun {CMD; CMD;}
	실행) fun
	확인) typeset -f
	해제) unset -f fun

	함수입력: 인자($1, $2, $,3, ....)
	함수출력: ecgo $RET














(8) IO 리다이렉션과 자식 프로세스
file1을 LINE이라는 값에 넣어서 가공하고 file2에 넣고싶다.

이건 하나씩받는 느낌
for LINE in $(cat file1)
do
	echo $LINE
done > file2
이건 한줄을 전체를 받는 느낌
cat file1 | while read LINE
do
	echo $LINE
done > file2

(9) 시그널 제어
* 시그널 무시
* 시그널 받으면 개발자가 원하는 동작 

(10) 디버깅
* bsh -x script.sh
* bash -xv script.sh

(11) 옵션처리
getopts CMD + while CMD +　case CMD
(예) # ./ssh.sh -p 80 192.168.10.20
while getotps p: options
do
	case $options in
	p )	P_ACTION ;;
	\?)	Usage	   ;;
	*)	Usage	   ;;
	esac
done

shift $(expr $OPTIND -1)
if [ $# -ne 1 ] ; then
	Usage
fi
echo "$# : $@ "
2>/dev/null 혹시나 에러 메세지가 뜨면 지우라는 소리(우리의 에러메세지만 출력하려고)


(12) 쉘 내장 명령어













(*) vscode 자동으로 꺼지도록 설정
crontab + vskill.sh

kill $(ps -ef | grep -w code \
| grep -v 'grep --color' \
| awk '{print $2}' \
| sort -n \
| head -1)

(*)pv gv lv 한꺼번에 처리
partition
LV(PV -> VG -> LV)  ** 실습에선 이것만
./lvm.sh
--------------------------
pv작업
--------------------------
보기(pv가 가능한 목록들)
	pvcreate /dev/sda1 /dev/sdb1 /dev/sdc1
----------------
선택(ex: /dev/sdb1 /dev/sdc1 ...)?
fdisk -l | grep LVM | awk '{print $1}' > pv1.txt
pvs | tail -n +2 | awk '{print $1}' > pv1.txt > pv2.txt

ENV1.sh : 환경설정
	.bashrc
ENV2.sh : 필요한 패키지 설치
	(gcc, vscode)
rpm --import https://packages.microsoft.com/keys/microsoft.asc

sh -c 'echo -e 
[code]
nname=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

rpm --import https://packages.microsoft.com/keys/microsoft.asc

cat << EOF > /etc/yum.repos.d/vscode.repo
nname=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
yum install code


https://www.google.co.kr/chrome/thank-you.html?brand=YTUH&statcb=0&installdataindex=empty&defaultbrowser=0#

***실습에서는 이거 사용***
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -O /root/bin/aa.rpm

localinstall /root/bin/google-chrome-stable_current_x86_64.rpm
localinstall /root/bin/aa.rpm





ENV3.sh : 서버 세팅
telnet(root 사용자 접속가능)
	yum -y install telnet telnet-serviece
	systemctl enable telnet.socket
ftp 서버(root사용자 접속가능)
	yum -y install vsftp ftp
	sed -i '/^root/#root/' /etc/vsftpd/ftpusers
	sed -i '/^root/#root/' /etc/vsftpd/user_list
	systemctl enable --now vsftpd.service
ssh 서버 (root 사용자 접속가능)
	yum -y install openssh-server openssh-clients sshd
	sed -i 's/PermitLootLogin no/PermitRootLogin yes' /etc/ssh/sshd_config
	sed -i 's/#PermitLootLogin/PermitRootLogin' /etc/ssh/sshd_config

	sed -i 's/#PasswordAuthentication /PasswordAuthentication yes'
	 /etc/ssh/sshd_config
nginx web서버 (index.html)
	yum -y install nginx
	echo "Nginx WebServer" > /usr/share/nginx/html/index.html
	systemctl enable --now nginx.service


--------------------------
vg작업
--------------------------
보기 (vg가 가능한 목록들)
----------------
선택(ex ....)
--------------------------
lv작업
--------------------------
보기 (lv가 가능한 목록들)
---------------
선택 (ex: ....)












filesystem
mount




vscode 사용법
vscode --nosandbox



~/.bashrc_profile
에 설정 집어넣어놓기

터미널에 표시하고 싶지않을 때
/dev/null 2>&1

IDE(vscode)
LINUX) vscode
WINDOWS) vscode

