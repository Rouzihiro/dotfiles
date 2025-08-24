#!/bin/bash

connected_device=$(bluetoothctl devices Connected)

if [ -z "$connected_device" ]; then
    echo "no"  
else
    echo "Con"  
fi

