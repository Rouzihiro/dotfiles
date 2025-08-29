#!/bin/sh

export PATH="$HOME/.local/bin:$HOME/.local/share/bob/nvim-bin:/usr/local/bin:$PATH:$HOME/.dotnet/tools"
for dir in "$HOME/.local/bin/"*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done

[ -z "$DISPLAY" ] && export DISPLAY=:0

# Install xorg-xhost
xhost +SI:localuser:$USER

export XAUTHORITY=$HOME/.Xauthority
export XDG_SESSION_TYPE=x11
export XDG_SESSION_DESKTOP=dwm
export DESKTOP_SESSION=dwm
export XDG_CURRENT_DESKTOP=dwm
export XDG_DATA_DIRS=/usr/share:/usr/local/share
export XDG_CONFIG_DIRS=/etc/xdg

# Keyboard layout settings
setxkbmap -layout us,de -variant , -option grp:alt_shift_toggle

# Screen blanking and power management
xset s off
xset s noblank
xset -dpms

# Set cursor theme
xsetroot -cursor_name left_ptr

# Start compositor for transparency and effects
picom -b >"$HOME/.picom.log" 2>&1 &

# Start notification daemon
dunst >"$HOME/.dunst.log" 2>&1 &

# Start power manager
xfce4-power-manager >"$HOME/.xfce4-power-manager.log" 2>&1 &

# Start authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >"$HOME/.polkit.log" 2>&1 &

# Start your custom scripts
# $HOME/.local/bin/dwm/autolock.sh &
# $HOME/.local/bin/dwm/superbar-lite-surface.sh &
$HOME/.local/bin/dwm/superbar-lite.sh &
$HOME/.local/bin/dwm/set-wallpaper.sh &

# Set up D-Bus environment
dbus-update-activation-environment --systemd --all


# Example: enable natural scroll for all touchpads
for id in $(xinput list --id-only | xargs -n1 xinput list-props | grep -B1 "Touchpad" | grep 'id=' | awk '{print $2}' | tr -d ','); do
    xinput set-prop $id "libinput Natural Scrolling Enabled" 1
done

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
# Finally, start dwm (this should be the last line with exec)
exec dwm >"$HOME/.dwm.log" 2>&1
