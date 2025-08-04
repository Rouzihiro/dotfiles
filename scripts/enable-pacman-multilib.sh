#!/bin/bash
set -e

PACMAN_CONF="/etc/pacman.conf"

echo "Checking multilib repo in $PACMAN_CONF..."

if grep -q "^\[multilib\]" "$PACMAN_CONF" && ! grep -q "^\s*#\[multilib\]" "$PACMAN_CONF"; then
  echo "Multilib repo is already enabled."
else
  echo "Enabling multilib repo..."
  sudo sed -i '/^\s*#\[multilib\]/s/^#//' "$PACMAN_CONF"
  sudo sed -i '/^\s*#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' "$PACMAN_CONF"
  echo "Multilib repo enabled."
fi

echo "Syncing package databases..."
sudo pacman -Sy

echo "Done!
