#!/bin/bash

echo -n "Enter A : "
read NUM1
echo -n "Enter Operator : "
read OP
echo -n "Enter C : "
read NUM2

case $OP in
    +) expr "$NUM1 + $NUM2 = $(expr $NUM1 + $NUM2)" ;;
    -) expr "$NUM1 - $NUM2 = $(expr $NUM1 - $NUM2)" ;;
    *) expr "$NUM1 * $NUM2 = $(expr $NUM1 \* $NUM2)" ;;
    /) expr "$NUM1 / $NUM2 = $(expr $NUM1 / $NUM2)" ;;
    *) Usage echo "[ FAIL ]" ; exit 1 ;;
esac