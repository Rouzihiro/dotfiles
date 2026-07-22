"""
rules.py — floating rules + special window placement.
"""

from libqtile import hook
from libqtile.config import Match
from libqtile.layout.floating import Floating

from theme import (
    float_border_focus,
    float_border_normal,
    float_border_width,
)


floating_layout = Floating(
    border_focus=float_border_focus,
    border_normal=float_border_normal,
    border_width=float_border_width,
    float_rules=[
        *Floating.default_float_rules,
        Match(wm_class="floaty-medium"),
        Match(wm_class="floaty-small"),
        Match(wm_class="floaty-big"),
        Match(wm_class="floaty-tiny"),
        Match(wm_class="runner_floating"),
        Match(wm_class="dashboard.py"),
    ],
)


@hook.subscribe.client_new
def dashboard_to_workspace(window):
    """
    Move dashboard to dedicated dashboard workspace.
    """

    try:
        wm_class = window.get_wm_class()

        if wm_class and "dashboard.py" in wm_class:
            window.togroup("5")

    except Exception:
        pass
