import os
import subprocess
from libqtile import hook, qtile
from libqtile.config import Drag, Match, Screen
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.lazy import lazy

# Import modules
from settings import *
from bar import get_bar
from mode import Mode
from input import get_input_rules
from keybinds import load_keybinds
from groups import get_groups
from keybinds import dmod 

wl_input_rules = get_input_rules()

#groups = get_groups()
#keys = load_keybinds(groups)

from libqtile.core.manager import Qtile
qtile = Qtile  # Mock for check

# Dynamic terminal selection
terminal = "footclient" if qtile.core.name == "wayland" else "alacritty"

mode = Mode()
bar = get_bar(host)

# Mouse configuration
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating()),
    Drag([mod], "Button3", lazy.window.set_size_floating()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Screens
screens = [Screen(top=bar, wallpaper="~/Pictures/wallpapers/Dune3.png")]

# Hooks
@hook.subscribe.startup_once
def autostart():
    for cmd in AUTOSTART:
        subprocess.Popen(cmd.split(), stdout=subprocess.DEVNULL)

@hook.subscribe.client_managed
def force_fullscreen(client):
    if any(client.match(rule) for rule in FULLSCREEN_RULES):
        client.fullscreen = True

wmname = "QTILE"
