from .get_theme import colors

from libqtile import layout
from libqtile.config import Match

# Define layouts and layout themes
layout_theme = {
    "margin":8,
    "border_width": 4,
    "border_focus": colors['color11'],
    "border_normal": colors['color0'],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
    layout.Floating(**layout_theme),
    layout.Max(**layout_theme),
    layout.Spiral(
        main_pane_ratio = 0.70,
        ratio = 0.52,
        new_client_position = "bottom",
        **layout_theme
    )
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Mailspring"),
        Match(func=lambda c: c.is_transient_for()),
    ], 
    fullscreen_border_width = 0, 
    border_width = 4, 
    border_focus = colors['color11'],
    border_normal = colors['color1']
)
