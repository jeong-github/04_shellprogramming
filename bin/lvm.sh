#!/bin/bash

#
# 변수 선언
#
TMP1=/tmp/tmp1
TMP2=/tmp/tmp2
TMP3=/tmp/tmp3
TMP4=/tmp/tmp4

#
# PV 생성
#
while true
do
echo ; echo "####################### (1) PV 생성 ###########################" ; echo
# (1) PV 생성 가능한 목록
fdisk -l | grep LVM | awk '{print $1}' > $TMP1
pvs | tail -n +2 | awk '{print $1}' > $TMP2

echo "############# 사용 가능한 PV 목록 ###############"
echo "아래 목록에서 PV로 생성하고 싶은 볼륨을 선택합니다."
echo "$(cat $TMP1 $TMP2 | sort | uniq -u)"
echo "################################################"

# (2) PV 생성 작업
echo -n "볼륨 선택? (ex: /dev/sdb1 /dev/sdc1 ...) : "
read VOLUME

cat << EOF

    다음 명령어를 정말 실행하시겠습니까?
    # pvcreate $VOLUME
    * yes: 실행, no: 처음부터 다시, skip: 작업 뛰어넘기

EOF
echo -n "당신의 선택은? (yes|no|skip) : "
read CHOICE
case $CHOICE in
    yes) : ;;
    no) continue ;;
    skip) break ;;
    *) continue ;;
esac

pvcreate "$VOLUME" >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    echo "[  OK  ] Physical volume $VOLUME successfully created."
    echo "_______________________________________________________"    
    pvs
else
    echo "[ FAIL ] Physical volume not created."
    exit 1 
fi
break
done

#
# VG 생성
#
while true
do
echo ; echo "####################### (2) VG 생성 ###########################" ; echo
# (1) VG 포함할 수 있는 PV 목록
vgs | tail -n +2 | awk '{print $1}' > $TMP3
pvs > $TMP4
for i in $(cat $TMP3)
do
    sed -i "/$i/d" $TMP4
done

echo "################# VG에 포함 가능한 PV 목록 #################"
echo "$(cat $TMP4)"
echo "############################################################"

# (2) VG 생성 과정
# vgcreate vg1 /dev/sdb1 /dev/sdc1
echo -n "VG 이름은? (ex: vg1) : "
read VGNAME

echo -n "VG에 넣을 PV 목록은? (ex: /dev/sdb1 /dev/sdc1 ...) : "
read PVLIST

cat << EOF

    다음 명령어를 정말 실행하시겠습니까?
    # vgcreate $VGNAME $PVLIST
    * yes: 실행, no: 처음부터 다시, skip: 작업 뛰어넘기, exit: 프로그램 종료

EOF
echo -n "당신의 선택은? (yes|no|skip|exit) : "
read CHOICE
case $CHOICE in
    yes) :       ;;
    no) continue ;;
    skip) break  ;;
    exit) exit 8 ;;
    *) continue  ;;
esac

vgcreate "$VGNAME" "$PVLIST" >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    echo "[  OK  ] Volume group $VGNAME successfully created"
    echo "__________________________________________________"
    vgs
else
    echo "[ FAIL ] Volume group not created."
    exit 2
fi
break
done

#
# LV 생성
#
while true
do
echo ; echo "####################### (3) LV 생성 ###########################" ; echo
# (1) VG에 남은 공간 확인
echo "################# 사용 가능한 VG 목록 #################"
echo "$(vgs | awk '$7 != '0' {print $0}')"
echo "########################################################"

# (2) LV 생성 과정
# lvcreate vg1 -n lv1 -L 500m
echo -n "LV를 생성할 VG 이름은? (ex: vg1) : "
read VGLV

echo -n "생성할 LV 이름은? (ex: lv1) : "
read LVNAME

echo -n "LV 용량은? (ex: 500m) : "
read LVSIZE

cat << EOF

    다음 명령어를 정말 실행하시겠습니까?
    # lvcreate $VGLV -n $LVNAME -L $LVSIZE
    * yes: 실행, no: 처음부터 다시, skip: 작업 뛰어넘기, exit: 프로그램 종료

EOF
echo -n "당신의 선택은? (yes|no|skip|exit) : "
read CHOICE
case $CHOICE in
    yes) : ;;
    no) continue ;;
    skip) break  ;;
    exit) exit 9 ;;
    *) continue  ;;
esac

lvcreate "$VGLV" -n "$LVNAME" -L "$LVSIZE" >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    echo "[  OK  ] Logical Volume $LVNAME successfully created."
    echo "_________________________________________________________________________________"
    lvs
else
    echo "[ FAIL ] Logical Volume not created."
    exit 3
fi
break
done