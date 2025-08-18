#!/bin/bash
# connect_controller.sh — Scan and connect a Bluetooth gamepad (PS4 / Xbox)

# Check if bluetoothctl is installed
if ! command -v bluetoothctl &> /dev/null; then
    echo "Error: bluetoothctl not found. Install bluez package."
    exit 1
fi

echo "Starting scan for controllers (10s)..."
bluetoothctl <<EOF
power on
agent on
default-agent
scan on
EOF

# Wait 10 seconds to detect devices
sleep 10

echo "Scan finished. Listing devices..."
bluetoothctl devices

# Ask user to input the MAC of the controller
read -p "Enter MAC address of your controller: " MAC

echo "Pairing, trusting and connecting..."
bluetoothctl <<EOF
pair $MAC
trust $MAC
connect $MAC
EOF

echo "Done! Your controller should now be connected."

