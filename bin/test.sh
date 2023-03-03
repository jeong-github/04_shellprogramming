#!/bin/bash

for num1 in $(seq 10)
do
    PERCENT=$(expr $num1 \* 10)
    echo -n "${PERCENT}%|"

    for num2 in $(seq $num1)
    do
        echo -ne "="
    done

    [ $num1 -le 9 ] && echo -ne ">" || echo -ne "| complete\n" 

    echo
    sleep 1
    
done

