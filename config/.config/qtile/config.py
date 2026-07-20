import os

from libqtile import hook, qtile
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import (
    # Animation,
    Screen,
    # WaylandAnimations,
)
from libqtile.layout import Columns, Max

from keys import get_keys
from groups import get_groups
# from autostart import autostart

import theme
from bar_lite import build_bar


#
# Backend
#

IS_WAYLAND = qtile.core.name == "wayland"

if IS_WAYLAND:
    os.environ.update(
        {
            "XDG_SESSION_DESKTOP": "qtile:wlroots",
            "XDG_CURRENT_DESKTOP": "qtile:wlroots",
        }
    )


#
# Core objects
#

keys = get_keys()
groups = get_groups()


#
# Layouts
#

layouts = [
    Columns(
        border_focus=theme.border_focus,
        border_normal=theme.border_normal,
        border_width=theme.border_width,
        margin=4,
    ),
    Max(),
]


#
# Screens
#

screens = [
    Screen(
        top=build_bar(),
    ),
    Screen(
        top=build_bar(),
    ),
]


#
# Input
#

mouse = []

wl_input_rules = {
    "type:pointer": InputConfig(
        accel_profile="flat",
    ),
    "type:touchpad": InputConfig(
        tap=True,
        natural_scroll=True,
        dwt=True,
    ),
    "type:keyboard": InputConfig(
        kb_layout="us,de",
        kb_options="grp:alt_shift_toggle,caps:escape",
        kb_repeat_delay=250,
        kb_repeat_rate=35,
    ),
}


#
# Wayland animations
#

# wl_animation = WaylandAnimations(
#     slide=Animation(
#         duration=200,
#         ease="out_quint",
#     ),
#     spawn=Animation(
#         duration=200,
#         ease="out_quint",
#     ),
#     kill=Animation(
#         duration=200,
#         ease="out_quint",
#     ),
#     dropdown=Animation(
#         duration=200,
#         ease="out_quint",
#     ),
#     default=Animation(
#         duration=200,
#         ease="out_quint",
#     ),
# )
#

#
# General Qtile settings
#

dgroups_key_binder = None
dgroups_app_rules = []

follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True

cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
auto_minimize = True

reconfigure_screens = True


#
# Cursor
#

wl_xcursor_theme = "Nordzy-cursors"
wl_xcursor_size = 24


#
# Startup
#


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")

    commands = [
        "mako",
        "sh -c 'pgrep swww-daemon || swww-daemon'",
        "wl-paste -t text --watch clipman store --no-persist",
        (
            "swayidle -w "
            f'before-sleep "swaylock -fF -i {home}/Pictures/lockscreen/VIM.png" '
            'timeout 300 "brightnessctl -s set 0" '
            'resume "brightnessctl -r"'
        ),
        f"{home}/.config/qtile/scripts/void-audio-start.sh",
    ]

    for cmd in commands:
        qtile.spawn(cmd)


#
# Monitor hotplugging
#


@hook.subscribe.screen_change
def _on_screen_change(event):
    qtile.reconfigure_screens()

    for group in qtile.groups:
        if group.screen is None:
            group.toscreen(0)


#
# Compatibility
#

wmname = "QTILE"
