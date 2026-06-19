#!/bin/bash

CONFIG_FILE="$HOME/.config/sway/config.d/autostart"

[ -f "$CONFIG_FILE" ] || { echo "File not found: $CONFIG_FILE"; exit 1; }

if sed -i 's/autotiling/autotiling-rs/g' "$CONFIG_FILE"; then
    echo "✓ Updated $CONFIG_FILE (autotiling → autotiling-rs)"
fi
