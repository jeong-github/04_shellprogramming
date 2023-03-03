#!/bin/bash

echo -n "너의 선택은? (yes/no) : "
read choice

case $choice in
    yes|Y|YES|y|Yes) echo "[ ok ] oh yes" ;;
    no|N|NO|n|No) echo "[fail] on no" ;;
    *) echo "yes 또는 no를 입력하시오."
        exit 1;;

esac
