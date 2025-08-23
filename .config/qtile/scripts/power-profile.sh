#!/usr/bin/env bash

state=`cat /sys/class/power_supply/AC/online`

if [ $state == "1" ]
then
    threshold=`system76-power charge-thresholds | awk '/Profile/{print $NF}'`
    echo $threshold
else
    profile=`system76-power profile | awk '/Profile/{print $NF}'`
    echo \($profile\)
fi
