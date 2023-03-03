#!/bin/bash

WORKDIR=/test
mkdir -p $WORKDIR
rm -rf $WORKDIR/*

for i in $(seq 4)
do
    echo $i
    mkdir -p $WORKDIR/$i
    for j in $(seq 4)
    do
        mkdir -p $WORKDIR/$i/$j
    done
done