{pkgs}:
pkgs.writeShellScriptBin "bandwidth-yad" ''
  INTERFACE="wlp108s0"

  # Check if the interface exists
  if [ ! -d /sys/class/net/$INTERFACE ]; then
    yad --width=800 --height=650 \
        --center \
        --fixed \
        --title="Bandwidth Info" \
        --no-buttons \
        --list \
        --column=Metric: \
        --column=Speed: \
        --timeout=9000 \
        --timeout-indicator=right \
        "Download" "↓0K" \
        "Upload" "↑0K"
    exit 0
  fi

  # Get the current RX and TX bytes
  RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  # Wait for 1 second to calculate the difference
  sleep 1

  # Get the new RX and TX bytes
  RX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  # Calculate the download and upload speeds in KB/s
  DOWNLOAD_SPEED=$((($RX_BYTES_NEW - $RX_BYTES) / 1024))
  UPLOAD_SPEED=$((($TX_BYTES_NEW - $TX_BYTES) / 1024))

  # Output the result in a format that yad can use
  yad --width=800 --height=650 \
      --center \
      --fixed \
      --title="Bandwidth Info" \
      --no-buttons \
      --list \
      --column=Metric: \
      --column=Speed: \
      --timeout=90 \
      --timeout-indicator=right \
      "Download" "↓''${DOWNLOAD_SPEED}K" \
      "Upload" "↑''${UPLOAD_SPEED}K"
''
