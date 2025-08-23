#!/usr/bin/env bash

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

/nix/store/$(ls -la /nix/store | grep polkit-gnome | grep '^d' | awk '{print $9}')/libexec/polkit-gnome-authentication-agent-1 & 
swayidle -w timeout 600 'swaylock -f' &
dunst &
system76-power daemon &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
cp ~/.dotfiles/home/configs/qtile/scripts/variety-wayland.sh ~/.config/variety/scripts/set_wallpaper &
variety
