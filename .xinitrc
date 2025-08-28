#!/bin/sh

# Set DPI for high-resolution displays
xrdb -merge <<< "Xft.dpi: 192"
export XFT_DPI=192

# Keyboard layout settings
setxkbmap -layout us,de -variant , -option grp:alt_shift_toggle

# Screen blanking and power management
xset s off
xset s noblank
xset -dpms

# Set cursor theme
xsetroot -cursor_name left_ptr

# Start compositor for transparency and effects
picom -b &

# Start notification daemon
dunst &

# Start screenshot utility
flameshot &

# Start power manager
xfce4-power-manager &

# Start authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Start your custom scripts
#$HOME/.local/bin/dwm/autolock.sh &
$HOME/.local/bin/dwm/superbar-lite.sh &
$HOME/.local/bin/dwm/set-wallpaper.sh &

# Set up D-Bus environment
dbus-update-activation-environment --systemd --all

# Finally, start dwm (this should be the last line with exec)
exec dwm >"$HOME/.dwm.log" 2>&1
