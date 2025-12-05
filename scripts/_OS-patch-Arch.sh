#!/bin/bash

CONFIG_FILE="$HOME/.config/sway/config.d/autostart"
CONFIG_FILE2="$HOME/.config/zsh/.zshrc"

[ -f "$CONFIG_FILE" ] || { echo "File not found: $CONFIG_FILE"; exit 1; }

if sed -i 's/autotiling-rs/autotiling/g' "$CONFIG_FILE"; then
    echo "✓ Updated $CONFIG_FILE (autotiling-rs → autotiling)"
fi

[ -f "$CONFIG_FILE2" ] || { echo "File not found: $CONFIG_FILE2"; exit 1; }

if sed -i 's/.aliases-arch/aliases-fedora/g' "$CONFIG_FILE2"; then
    echo "✓ Updated $CONFIG_FILE2 (zsh adapted)"
fi
