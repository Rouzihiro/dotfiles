#!/usr/bin/env bash

state=`cat /sys/class/power_supply/AC/online`

if [ $state == "1" ]
then
    echo $(system76-power charge-thresholds)
    echo ""
    echo "Select a Charge Threshold"
    select threshold in "Full Charge" "Balanced" "Max Lifespan" "Quit"
    do
        case $threshold in
            "Full Charge")
                system76-power charge-thresholds --profile full_charge
                break;;
            "Balanced")
                system76-power charge-thresholds --profile balanced
                break;;
            "Max Lifespan")
                system76-power charge-thresholds --profile max_lifespan
                break;;
            "Quit")
                echo "Closing"
                break;;
            *)
                echo "Oops!";;
        esac
    done
else
    echo $(system76-power profile | grep "Power Profile")
    echo ""
    echo "Select a Power Profile:"
    select profile in Battery Balanced Performance Quit
    do
        case $profile in
            "Battery")
                system76-power profile battery
                break;;
            "Balanced")
                system76-power profile balanced
                break;;
            "Performance")
                system76-power profile performance
                break;;
            "Quit")
                echo "Closing"
                break;;
            *)
                echo "Oops!";;
        esac
    done
fi
