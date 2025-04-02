import os
import socket
from libqtile.config import Match


# General Settings
host = socket.gethostname()
mod = "mod4"
terminal = "footclient" 
browser = "qutebrowser"
launcher = "rofi -show drun"
fileManager = "thunar"
editor = "nvim"
ntCenter = "swaync-client -t -sw"

# Fullscreen Rules
FULLSCREEN_RULES = [
    Match(wm_class="flameshot"),
]

# Startup Commands
AUTOSTART = [
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "systemctl --user restart pipewire",
    "foot --server",
    #"swaync",
    #"udiskie",
    #"flameshot",
    #"conky -c ~/.config/conky/conky-qtile.conf",
    #"discord",
    #"focus-mode",
]
