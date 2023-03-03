#!/bin/bash

echo -n "파일 이름 입력 : "
read file1

# # echo $file1

: << EOF
if [ -x $file1 ] ; then
    eval $file1
fi
EOF