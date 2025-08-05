from libqtile import layout 
from libqtile.config import Match
from mode import mode

# Layouts
layouts = [layout.MonadTall(**mode.current)]

# Floating layout
floating_layout = layout.Floating(
    **mode.current,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
)
