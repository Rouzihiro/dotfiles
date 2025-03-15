{pkgs}:
pkgs.writeShellScriptBin "bandwidth" ''
  #!/bin/sh

  INTERFACE="wlp108s0"

  # Check if the interface exists
  if [ ! -d /sys/class/net/$INTERFACE ]; then
    echo "↓0MB ↑0MB"
    exit 0
  fi

  # Get the current RX and TX bytes
  RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  # Wait for 1 second
  sleep 1

  # Get the new RX and TX bytes
  RX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  # Calculate speeds in MB/s
  DOWNLOAD_SPEED=$(echo "scale=2; ($RX_BYTES_NEW - $RX_BYTES) / 1024 / 1024" | ${pkgs.bc}/bin/bc)
  UPLOAD_SPEED=$(echo "scale=2; ($TX_BYTES_NEW - $TX_BYTES) / 1024 / 1024" | ${pkgs.bc}/bin/bc)

  # Output formatted result
  echo "↓$DOWNLOAD_SPEED MB ↑$UPLOAD_SPEED MB"
''
