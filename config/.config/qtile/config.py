"""
config.py — main entry point. Qtile only ever loads this file directly;
everything else is imported here, same idea as sway's `include` lines.
"""

from libqtile import hook
from libqtile.backend.wayland import InputConfig
from libqtile.config import Screen
from libqtile.layout import Columns, Max

from keys import keys          # noqa: F401  (Qtile reads module-level `keys`)
from groups import groups      # noqa: F401  (Qtile reads module-level `groups`)
from rules import floating_layout  # noqa: F401
from autostart import autostart
from theme import border_focus, border_normal, border_width
from bar import build_bar

# @hook.subscribe.screen_change
# def fix_groups(qtile):
#     for group in qtile.groups:
#         if group.screen and group.screen.index >= len(qtile.screens):
#             group.toscreen(0)

mod = "mod4"

layouts = [
    Columns(
        border_focus=border_focus,
        border_normal=border_normal,
        border_width=border_width,
        margin=4,
    ),
    Max(),
]

screens = [
    Screen(top=build_bar()),
    Screen(top=build_bar()),
]

mouse = []  # add drag/resize mouse bindings here if you want them

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

# Wayland-only: per-device input config (keyboard layout, touchpad behavior,
# etc). This had no X11 equivalent — under X11 you'd have configured this
# via xorg.conf.d or `xinput` instead. "type:*" matches by device type;
# use a specific identifier (see `qtile cmd-obj -o core -f get_inputs`
# once running) if you need per-device rather than per-type rules.
wl_input_rules = {
    "type:keyboard": InputConfig(kb_layout="us"),
    "type:touchpad": InputConfig(tap=True, natural_scroll=True),
}


@hook.subscribe.startup_once
def _autostart():
    autostart()
