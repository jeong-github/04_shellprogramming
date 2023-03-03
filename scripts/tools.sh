#!/bin/bash

clear
cat <<EOF
====================================================
(1). who      (2). date     (3). pwd              
====================================================
EOF

echo -n "선택해라? (1|2|3): "
read choice

# echo $choice
case $choice in
    1)  who ;;
    2)  date ;;
    3)  pwd ;;
    *)  echo "[FAIL] 번호를 잘못 선택함."
    exit 1;;
esac
