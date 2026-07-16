"""
rules.py — equivalent of sway's `for_window` floating rules.
These are the "floaty-*" titles and the runner_floating app you spawn
via $term2 --title / --app-id. Qtile matches on WM_CLASS or window title.
"""

from libqtile.config import Match
from libqtile.layout.floating import Floating

from theme import float_border_focus, float_border_normal, float_border_width

# Match(wm_class=...) still works unchanged under Wayland — Qtile maps a
# native Wayland client's app_id into the same wm_class field internally,
# so this file needs no backend-specific branching.
floating_layout = Floating(
    border_focus=float_border_focus,
    border_normal=float_border_normal,
    border_width=float_border_width,
    float_rules=[
        *Floating.default_float_rules,
        Match(title="floaty-big"),
        Match(title="floaty-medium"),
        Match(title="floaty-small"),
        Match(title="floaty-tiny"),
        Match(wm_class="runner_floating"),  # was --app-id=runner_floating in sway
    ],
)
