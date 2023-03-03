#!/bin/bash

echo -n "파일 이름은? : "
read file1

# echo $file1
if [ -f $file1 ]; then
    echo "이 파일은 일반파일입니다."
elif [ -d $file1 ] ; then
    echo "이 파일은 디렉토리입니다."
else
    echo "알수없는 파일입니다."
fi