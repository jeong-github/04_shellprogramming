#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pattern> <filename>"
    exit 1

fi
pattern=$1
file1=$2

grep $pattern $file1

if [ $? -eq 0 ]; then
    echo "[ok] 찾았다."
else
    echo "[FAIL] 못 찾았다."
fi