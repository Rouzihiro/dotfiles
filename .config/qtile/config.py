from libqtile import bar, qtile
from libqtile.config import Match, Screen
from groups import create_groups 
from widgets import create_widget_list
from hooks import *
from input import get_mouse_config, get_wl_input_rules
from keybinds import create_keys
from layouts import *
from theme import colors
import os
import socket

# Constants
HOST = socket.gethostname()
MOD = "mod4"
IS_WAYLAND = qtile.core.name == "wayland"

# Application definitions
APPS = {
    "terminal": "footclient" if IS_WAYLAND else "kitty",
    "browser": "firefox", 
    "launcher": "rofi -show drun",
    "file_manager": "thunar",
    "notification_center": "swaync-client -t -sw",
}
APPS["editor"] = f"{APPS['terminal']} -e nvim"

# Client management
FULLSCREEN_RULES = [Match(wm_class="flameshot")]

# Backend setup
if IS_WAYLAND:
    os.environ.update({
        "XDG_SESSION_DESKTOP": "qtile:wlroots",
        "XDG_CURRENT_DESKTOP": "qtile:wlroots"
    })

# Essentials
keys = create_keys()
groups = create_groups()
mouse = get_mouse_config()
wl_input_rules = get_wl_input_rules()


# Widget configuration
widget_defaults = {
    "font": "JetBrainsMono Nerd Font",
    "fontsize": 14,
    "padding": 3,
}
extension_defaults = widget_defaults.copy()

# Screens
screens = [
    Screen(
        top=bar.Bar(
            create_widget_list(), 
            24, 
            background=colors["base01"],
        ),
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_xcursor_theme = "Nordzy-cursors"
wl_xcursor_size = 24
wmname = "QTILE"
