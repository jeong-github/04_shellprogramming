#!/bin/bash

WORKDIR=/test
mkdir -p $WORKDIR
rm -rf $WORKDIR/*

for i in $(seq 5)
do
   # echo $"*"
   for j in $(seq $i)
   do
        echo -n "*"
        mkdir /test/
   done
   echo

done