#!/bin/sh

export PATH="$HOME/.local/bin:$HOME/.local/share/bob/nvim-bin:/usr/local/bin:$PATH:$HOME/.dotnet/tools"
for dir in "$HOME/.local/bin/"*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done

# Set DPI for high-resolution displays
xrdb -merge <<< "Xft.dpi: 192"
export XFT_DPI=192

# Set up D-Bus environment early
dbus-update-activation-environment --systemd --all

# Keyboard layout settings
setxkbmap -layout us,de -variant , -option grp:alt_shift_toggle

# Screen blanking and power management
xset s 0 0
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
# $HOME/.local/bin/dwm/autolock.sh &
$HOME/.local/bin/dwm/superbar-lite.sh &
$HOME/.local/bin/dwm/set-wallpaper.sh &

# 300 seconds = 5 minutes
xset s 300 300
xset dpms 0 0 0        # DPMS disabled (no suspend/hibernate)
xss-lock --transfer-sleep-lock -- slock &

# xautolock -time 5 -detectsleep -locker "i3lock -i ~/Pictures/lockscreen/VIM.png" &

# Finally, start dwm
exec dwm >"$HOME/.dwm.log" 2>&1
