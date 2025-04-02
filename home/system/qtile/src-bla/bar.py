from libqtile import bar, widget
from qtile_extras.widget.decorations import PowerLineDecoration
from theme import colors

def powerline(arg):
    return {
        "decorations": [
            PowerLineDecoration(
                path=f"{arg}",
                stroke_weight=4,
                stroke_colour=colors["base00"],
                use_widget_background=True,
            )
        ]
    }

def get_bar(host):
    widget_defaults = {
        "font": "JetBrains Mono Nerd Font Medium",
        "fontsize": 14,
        "padding": 3,
    }

    widget_list = [
        widget.Image(
            filename="~/.config/qtile/assets/nord-logo.png",
            background=colors["base00"],
            margin_y=2,
            margin_x=12,
            **powerline("forward_slash"),
        ),
        widget.GroupBox(
            highlight_method="text",
            borderwidth=3,
            active=colors["base15"],
            inactive=colors["base03"],
            this_current_screen_border=colors["base09"],
            **powerline("back_slash"),
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=["~/.config/qtile/assets/layout"],
            padding=4,
            scale=0.7,
        ),
        widget.WindowName(foreground=colors["base09"], format="{class}"),
        widget.StatusNotifier(icon_size=16),
        widget.Memory(format="{MemUsed: .0f}{mm}", foreground=colors["base09"]),
        widget.Battery(
            format="{char} {percent:2.0%}",
            foreground=colors["base09"],
            charge_char="󰂄",
            discharge_char="󰁿"
        ),
        widget.PulseVolume(fmt="  {}", foreground=colors["base09"]),
        widget.KeyboardLayout(
            configured_keyboards=["us dvorak", "ge", "us"],
            display_map={"us dvorak": "USDV", "ge": "GE", "us": "US"},
            foreground=colors["base09"]
        ),
        widget.Clock(format="  %I:%M %p", foreground=colors["base15"]),
    ]

    if host != "laptop":
        del widget_list[5]  # Remove battery widget

    return bar.Bar(widget_list, 24, background=colors["base01"])
