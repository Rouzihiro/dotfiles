#!/bin/bash
# Void Linux post-install
set -e

echo "installing pipewire, wireplumber, pipewire-pulse"
sudo xbps-install -Sy pipewire wireplumber

mkdir -p ~/.config/pipewire/pipewire.conf.d
ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf ~/.config/pipewire/pipewire.conf.d/
ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf ~/.config/pipewire/pipewire.conf.d/

echo "done — add [\"pipewire\"] to your qtile autostart"
