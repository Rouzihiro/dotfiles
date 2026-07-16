"""
bar.py — the actual top bar. Kept separate from config.py so it's an easy
drop-in target if osyx ever needs to swap widget sets, same modular pattern
as keys/groups/rules/autostart.

Everything visual pulls from theme.py — no hex values or fonts hardcoded
here, so a theme switch re-colors the bar with no edits needed in this file.
"""

from libqtile import bar, widget

from theme import (
    bar_bg,
    bar_fg,
    bar_active,
    bar_inactive,
    bar_urgent,
    bar_highlight,
    font,
    font_size,
    bar_size,
)


def _defaults(**overrides):
    """Base widget kwargs (font/size/colors from theme.py) with per-widget overrides."""
    base = dict(font=font, fontsize=font_size, padding=6, background=bar_bg, foreground=bar_fg)
    base.update(overrides)
    return base


def build_bar():
    return bar.Bar(
        [
            widget.GroupBox(
                highlight_method="line",
                active=bar_fg,
                inactive=bar_inactive,
                this_current_screen_border=bar_active,
                urgent_border=bar_urgent,
                **_defaults(),
            ),
            widget.Sep(**_defaults(padding=10)),
            widget.CurrentLayout(**_defaults(foreground=bar_highlight)),
            widget.Sep(**_defaults(padding=10)),
            widget.WindowName(**_defaults(foreground=bar_fg)),
            widget.Systray(background=bar_bg, padding=8),
            widget.Sep(**_defaults(padding=10)),
            widget.Volume(**_defaults(foreground=bar_highlight)),
            widget.Battery(format="{char} {percent:2.0%}", **_defaults(foreground=bar_highlight)),
            widget.Clock(format="%a %d %b  %H:%M", **_defaults(foreground=bar_active)),
        ],
        bar_size,
        background=bar_bg,
        margin=[6, 8, 0, 8],  # top, right, bottom, left — floats the bar off the screen edges
    )
