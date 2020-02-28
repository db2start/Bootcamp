#!/bin/bash
while read dstip
do
    if ping -c 2 $dstip > /dev/null; then
        echo "$dstip is OK"
    else
        echo "$dstip ping fail ... ..."
    fi
done < $1
