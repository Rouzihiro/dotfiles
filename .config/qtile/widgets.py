from libqtile import qtile
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration
from theme import colors

def powerline(direction: str) -> dict:
    """Create powerline decoration."""
    return {
        "decorations": [
            PowerLineDecoration(
                path=direction,
                stroke_weight=4,
                stroke_colour=colors["base00"],
                use_widget_background=True,
            )
        ]
    }

def search() -> None:
    qtile.cmd_spawn("rofi -show drun")

def create_widget_list() -> list:
    """Create and return the widget list for the bar."""

    from config import HOST

    base_color = colors["base15"] if colors["theme"] == "nord" else colors["base10"]

    widgets = [
        widget.Image(
            filename=f"~/.config/qtile/assets/{colors["theme"]}-logo.png",
            background=colors["base00"],
            margin_y=2,
            margin_x=12,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    "xdg-open https://wiki.nixos.org/wiki/NixOS_Wiki"
                )
            },
            **powerline("forward_slash"),
        ),
        widget.GroupBox(
            highlight_method="text",
            borderwidth=3,
            rounded=True,
            foreground=base_color,
            highlight_color=colors["base01"],
            active=base_color,
            inactive=colors["base03"],
            this_current_screen_border=colors["base09"],
            this_screen_border=colors["base01"],
            urgent_border=colors["base11"],
            disable_drag=True,
            **powerline("back_slash"),
        ),
        widget.Spacer(length=2),
        widget.CurrentLayout(
            foreground=colors["base09"],
            mode="both",
            icon_first=True,
            custom_icon_paths=[f"~/.config/qtile/assets/layout/{colors["theme"]}"],
            scale=0.7,
            padding=4,
        ),
        widget.Spacer(
            length=2,
            **powerline("back_slash"),
        ),
        widget.TextBox(
            text="  ",
            background=colors["base00"],
            foreground=base_color,
            mouse_callbacks={"Button1": search},
        ),
        widget.TextBox(
            fmt="Search",
            background=colors["base00"],
            foreground=base_color,
            mouse_callbacks={"Button1": search},
            **powerline("rounded_left"),
        ),
        widget.WindowName(
            foreground=colors["base09"],
            format=" {class} ",
            empty_group_string=" Desktop",
        ),
        widget.Spacer(**powerline("rounded_right")),
        widget.StatusNotifier(
            background=colors["base00"],
            padding=5,
            icon_size=16,
            menu_background=colors["base00"],
            menu_foreground_highlighted=colors["base00"],
            highlight_colour=colors["base09"],
        ),
        widget.Spacer(
            length=2,
            background=colors["base00"],
            **powerline("forward_slash"),
        ),
        widget.TextBox(
            text=" 󰍛",
            fontsize=20,
            foreground=colors["base09"],
        ),
        widget.Memory(
            format="{NotAvailable: .0f}{mm} ",
            foreground=colors["base09"],
            **powerline("forward_slash"),
        ),
    ]
    
    # Add battery widget for laptop
    if HOST == "laptop":
        widgets.append(
            widget.Battery(
                foreground=colors["base09"],
                charge_char=" 󰂄",
                discharge_char=" 󰁿", 
                empty_char=" 󰂎",
                format="{char} {percent:2.0%} {hour:d}:{min:02d} ",
                **powerline("forward_slash"),
            )
        )

    widgets.extend([
        widget.TextBox(
            text="  ",
            foreground=colors["base09"],
        ),
        widget.PulseVolume(
            fmt="{} ",
            foreground=colors["base09"],
            **powerline("forward_slash"),
        ),
        widget.TextBox(
            text="  ",
            fontsize=20,
            foreground=colors["base09"],
        ),
        widget.KeyboardLayout(
            fmt="{} ",
            foreground=colors["base09"],
            configured_keyboards=["us dvp", "ge", "us"],
            display_map={"us dvp": "DVP", "ge": "GE", "us": "US"},
            option="caps:escape",
            **powerline("back_slash"),
        ),
        widget.TextBox(
            text="  ",
            fontsize=16,
            background=colors["base00"],
            foreground=base_color,
        ),
        widget.Clock(
            format="%I:%M %p ",
            background=colors["base00"],
            foreground=base_color,
        ),
    ])

    return widgets
