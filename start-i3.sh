#!/bin/bash

# Run from TTY with:
# startx ~/start-i3.sh -- :1

# Optional: .xinitrc (if you prefer)
# Instead of calling startx ~/start-i3.sh, you could replace ~/.xinitrc with:
# exec ~/start-i3.sh

#
# Required Packages
# Make sure the following are installed:
# sudo pacman -S i3-wm xorg xorg-xinit anydesk dunst rofi alacritty polkit-gnome network-manager-applet volumeicon xdg-desktop-portal-gtk gvfs


# Set up XDG variables for compatibility
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3

# Set cursor theme (optional)
# xsetroot -cursor_name left_ptr

# Start D-Bus session and launch i3
exec dbus-launch --sh-syntax --exit-with-session i3

