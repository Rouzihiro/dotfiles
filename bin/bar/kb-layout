#!/bin/bash

# Your keyboard identifier here
ID="1452:641:Apple_SPI_Keyboard"

layout=$(swaymsg -t get_inputs | jq -r \
  --arg id "$ID" \
  '.[] | select(.identifier == $id) | .xkb_active_layout_name')

case "$layout" in
  "English (US)") echo "US" ;;
  "German")       echo "DE" ;;
  *)              echo "$layout" ;;
esac
