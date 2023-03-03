#!/bin/bash

echo -n "Enter A : "
read NUM1
echo -n "Enter B : "
read NUM2

cat << EOF
==============================================
 (1). +    (2). -    (3). *    (4). /
==============================================
EOF

echo -n "Enter Your Choice ? (1|2|3|4) : "
read OP

case $OP in
    1) expr "$NUM1 + $NUM2 = $(expr $NUM1 + $NUM2)" ;;
    2) expr "$NUM1 - $NUM2 = $(expr $NUM1 - $NUM2)" ;;
    3) expr "$NUM1 x $NUM2 = $(expr $NUM1 \* $NUM2)" ;;
    4) expr "$NUM1 / $NUM2 = $(expr $NUM1 / $NUM2)" ;;
    *) Usage echo "[ FAIL ]" ; exit 1 ;;
esac