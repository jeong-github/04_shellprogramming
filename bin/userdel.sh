#!/bin/bash
#   # userdel user01

FILE1=/root/bin/user.list
cat $FILE1 | while read UNAME UPASS
do
  
    userdel -r $UNAME
    echo "[ OK ] $UNAME"
done