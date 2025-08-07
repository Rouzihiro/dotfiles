#!/bin/bash

# Hardcode the interface as "wlan0"
INTERFACE="wlan0"

# Check if the interface exists
if ! ip link show "$INTERFACE" &>/dev/null; then
  echo "Interface $INTERFACE not found"
  exit 1
fi

# Get the current RX and TX bytes
RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Wait for 1 second
sleep 1

# Get the new RX and TX bytes
RX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Calculate speeds in MB/s using bc
DOWNLOAD_SPEED=$(echo "scale=2; ($RX_BYTES_NEW - $RX_BYTES) / 1024 / 1024" | bc)
UPLOAD_SPEED=$(echo "scale=2; ($TX_BYTES_NEW - $TX_BYTES) / 1024 / 1024" | bc)

# Output formatted result
echo "↓$DOWNLOAD_SPEED MB ↑$UPLOAD_SPEED MB"

