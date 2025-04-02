#!/bin/sh

# ======================
# Essential Environment
# ======================
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1

# ======================
# Core Services
# ======================
systemctl --user restart pipewire      # Audio
foot --server &                       # Terminal server
swww init &                           # Wallpaper daemon
sleep 0.5 && swww img ~/Pictures/wallpapers/Dune3.png --transition-type any &

# ======================
# Recommended Utilities
# ======================
# Clipboard management
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Screen idle/locking
swayidle -w \
  timeout 300 'swaylock -f -c 000000' \
  timeout 600 'systemctl suspend' \
  before-sleep 'swaylock -f -c 000000' &

# ======================
# User Applications
# ======================
focus-mode &                           # Your focus helper

# ======================
# Optional Components
# ======================
# swaync &                             # Notification center
# udiskie -t &                         # Disk automounter
# flameshot &                          # Screenshots
# conky -c ~/.config/conky/conky-qtile.conf &

# ======================
# Wayland Fixes
# ======================
# Fix for Java apps
# export _JAVA_AWT_WM_NONREPARENTING=1

# Fix for XWayland games
# export XDG_SESSION_TYPE=wayland
# export XDG_CURRENT_DESKTOP=qtile
