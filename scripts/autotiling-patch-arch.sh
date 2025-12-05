#!/bin/bash

CONFIG_FILE="$HOME/.config/sway/config.d/autostart"

[ -f "$CONFIG_FILE" ] || { echo "File not found!"; exit 1; }

sed -i 's/autotiling-rs/autotiling/g' "$CONFIG_FILE" && \
echo "✓ Updated $CONFIG_FILE (autotiling-rs → autotiling)"
