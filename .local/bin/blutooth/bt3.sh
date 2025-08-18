#!/bin/bash

echo "Put both PS4 controllers in pairing mode (hold PS + Share buttons until light flashes rapidly)"
echo "Waiting 5 seconds for you to activate pairing mode..."
sleep 5

# First ensure Bluetooth is powered on
bluetoothctl power on
sleep 1

# Start scanning in background
bluetoothctl scan on &
SCAN_PID=$!
sleep 10  # Scan for 10 seconds

# Try to pair each controller
for MAC in D0:27:88:6D:8B:81 AC:FD:93:0A:E5:AC; do
    echo "Attempting to pair $MAC"
    bluetoothctl pair $MAC
    sleep 2
    bluetoothctl trust $MAC
    sleep 2
    bluetoothctl connect $MAC
    sleep 2
done

# Clean up
kill $SCAN_PID
bluetoothctl scan off
