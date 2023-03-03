#Variable Definitions
export PKG_DOWN_DIR=/root/bin
export VSFTPD_FTPUSERS=/etc/vsftpd/ftpusers
export VSFTPD_USERLIST=/etc/vsftpd/user_list
export SSHD_CONF=/etc/ssh/sshd_config

function print_good () {
    echo -e "\x1B[01;32m[+]\x1B[0m $1"
}

function print_error () {
    echo -e "\x1B[01;31m[-]\x1B[0m $1"
}

function print_info () {
    echo -e "\x1B[01;34m[*]\x1B[0m $1"
}

#Function Definitions
PkgInst() {
        #input: pkgs
PKGS=$*
#echo $PKGS
yum -qy install $PKGS >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    echo "[ ok ] $PKGS 설치가 완료되었습니다."
else
    echo "[ fail ] $PKGS 설치가 실패했습니다."
    exit 1
fi

}

SvcEnable() {
    SVC="$1"
    systemctl enable --now $SVC >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        echo "[ ok ] $SVC 유닛 기동 되었습니다."
    else
        echo "[ fail ] $SVC 유닛 기동되지 않았습니다."
        exit 1
    fi
}

VScodeInst() {

rpm --import https://packages.microsoft.com/keys/microsoft.asc

cat << EOF > /etc/yum.repos.d/vscode.repo
nname=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

    PkgInst "code"
}

VScodeComment(){
    cat <<EOF

    *실행은 다음과 같이 해야합니다.
    (root 사용자) # vscode --no-sandbox --user-data-dir=$HOME/workspace
    (일반 사용자) # code
    *관리자인 경우 alias 설정해서 사용하시면 편합니다.
    *관리자로 vscode를 실행하는 것을 권장하지 않습니다.

EOF
}

ChromeInst() {
    URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    CHROME_PKG=$(basename $URL)

    wget $URL -O $PKG_DOWN_DIR/$CHROME_PKG >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        echo "[ ok ] chrome 다운로드가 완료"
    else
        echo "[ fail ] chrome 다운로드가 실패"
        exit 1
    fi
    
    yum -qy localinstall $PKG_DOWN_DIR/$CHROME_PKG >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
        echo "[ ok ] chrome 패키지가 완료"
    else
        echo "[ fail ] chrome 패키지가 실패"
    fi
}

VsFtpconf() {
    sed -i 's/^root/#root/' $VSFTPD_FTPUSERS
    sed -i 's/^root/#root/' $VSFTPD_USERLIST
    echo "[ ok ] FTP 설정이 완료되었습니다."
}

SshConf() {
    sed -i 's/PermitLootLogin no/PermitRootLogin yes/' $SSHD_CONF
    sed -i 's/#PermitLootLogin/PermitRootLogin/' $SSHD_CONF

    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' $SSHD_CONF
    sed -i 's/#PasswordAuthentication/PasswordAuthentication/' $SSHD_CONF
    echo "[ ok ] SSH 설정이 완료되었습니다."
}

CheckWebSvc() {
#input      :str(nginx|httpd)
#output     :str(nginx|httpd)
#function
    WEBSVC=$1
    case $WEBSVC in
        nginx) CHECKWEBSVC=httpd ;;
        httpd) CHECKWEBSVC=nginx ;;
    esac
    systemctl disable --now $CHECKWEBSVC >/dev/null 2>&1

}

NginxConf() {
    echo "NGinx WebServer" > /usr/share/nginx/html/index.html
    echo "[ ok ] nginx 설정이 완료되었습니다."

}