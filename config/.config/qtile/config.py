from libqtile import hook, qtile
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Screen
from libqtile.layout import Columns, Max

from keys import get_keys
from groups import groups
from rules import floating_layout
from autostart import autostart

import theme
from bar_lite import build_bar


keys = get_keys()


layouts = [
    Columns(
        border_focus=theme.border_focus,
        border_normal=theme.border_normal,
        border_width=theme.border_width,
        margin=4,
    ),
    Max(),
]


screens = [
    Screen(
        top=build_bar(),
    ),
    Screen(
        top=build_bar(),
    ),
]


mouse = []


dgroups_key_binder = None
dgroups_app_rules = []

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
auto_minimize = True

reconfigure_screens = True


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


@hook.subscribe.startup_once
def _autostart():
    autostart()


@hook.subscribe.screen_change
def _on_screen_change(event):
    qtile.reconfigure_screens()

    for group in qtile.groups:
        if group.screen is None:
            group.toscreen(0)
