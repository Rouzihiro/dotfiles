from libqtile import hook, qtile
from libqtile.backend.wayland import InputConfig
from libqtile.config import Screen
from libqtile.layout import Columns, Max

from keys import keys
from groups import groups
from rules import floating_layout
from autostart import autostart
import theme
from bar import build_bar

mod = "mod4"

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
reconfigure_screens = False
auto_minimize = True


wl_input_rules = {
    "type:keyboard": InputConfig(kb_layout="us"),
    "type:touchpad": InputConfig(tap=True, natural_scroll=True),
}


@hook.subscribe.startup_once
def _autostart():
    autostart()


@hook.subscribe.screen_change
def _on_screen_change(event):
    qtile.reconfigure_screens()
    for group in qtile.groups:
        if group.screen is None or group.screen not in qtile.screens:
            group.toscreen(0, toggle=False)
