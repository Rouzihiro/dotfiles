from libqtile import bar, widget

import theme


def _defaults(**kwargs):
    base = {
        "font": theme.font,
        "fontsize": theme.font_size,
        "padding": 8,
        "background": theme.bar_bg,
        "foreground": theme.bar_fg,
    }

    base.update(kwargs)
    return base


def spacer(width=10):
    return widget.Sep(
        size=width,
        linewidth=0,
        padding=0,
        background=theme.bar_bg,
    )


def build_bar():

    return bar.Bar(
        [
            widget.GroupBox(
                **_defaults(),
                borderwidth=0,
                active=theme.bar_fg,
                inactive=theme.bar_inactive,
                this_current_screen_border=theme.bar_active,
                this_screen_border=theme.bar_highlight,
                urgent_border=theme.bar_urgent,
                highlight_method="line",
                padding_x=10,
                padding_y=4,
                margin_x=5,
                disable_drag=True,
            ),
            spacer(15),
        ],
        theme.bar_size,
        background=theme.bar_bg,
    )
