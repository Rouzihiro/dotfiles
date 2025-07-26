#!/bin/bash
set -e

echo "🔧 Installing PipeWire and ALSA components..."
sudo pacman -S --needed --noconfirm \
  pipewire pipewire-pulse wireplumber \
  sof-firmware alsa-ucm-conf alsa-utils pavucontrol

echo "🔌 Enabling PipeWire services for user..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber

echo "🧠 Enabling linger to keep audio services alive across reboots..."
loginctl enable-linger $USER

echo "🔍 Verifying audio sinks..."
pactl list short sinks || echo "⚠️  No sinks yet – a reboot may still be required."

echo "✅ Done. Please reboot your system to finalize audio driver loading."

