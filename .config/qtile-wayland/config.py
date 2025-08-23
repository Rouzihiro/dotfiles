import os
import subprocess
import sys
import socket
from libqtile import hook, qtile
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration
from qtile_extras.widget.decorations import PowerLineDecoration
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Key, KeyChord
from colors import colors

from mode import Mode
from os.path import expanduser, exists, normpath, getctime
from yaml import safe_load
from shutil import which
from json import dump, load
from inputs import wl_input_rules
wl_input_rules = wl_input_rules

sys.path.append(expanduser('~/.config/qtile/'))

from variables import *
keybindings_file = expanduser(keybindings_file)

widget_radius = 18

# Set backend
if qtile.core.name == "wayland":
    os.environ["XDG_SESSION_DESKTOP"] = "qtile:wlroots"
    os.environ["XDG_CURRENT_DESKTOP"] = "qtile:wlroots"

host = socket.gethostname()
mod = "mod4"
mode = Mode()

# Startup
@hook.subscribe.startup_once
def autostart():
    commands = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "systemctl --user restart pipewire",
        "foot --server",
        #"udiskie",
        #"conky -c ~/.config/conky/conky-qtile.conf",
        "focus-mode",
    ]

screenshots_path = expanduser(screenshots_path)
layouts_saved_file = expanduser(layouts_saved_file)
keybindings_file = expanduser(keybindings_file)
wallpapers_path = expanduser(wallpapers_path)

groups = [
    Group(i[0], label=i[1])
    for i in [("1", "󰈹"), ("2", ""), ("3", ""), ("4", "󰉋"), ("5", "󰭹"), ("6", "󰣇")]
]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )



with open(keybindings_file, 'rb') as file:
    keybindings = safe_load(file)

dmod = keybindings['dmod']

keys = [
    *[Key([dmod], num_keys[index], lazy.group[group.name].toscreen()) for index, group in enumerate(groups)],
    *[Key([dmod, "shift"], num_keys[index], lazy.window.togroup(group.name, switch_group=True)) for index, group in enumerate(groups)],
]

for keybind in keybindings['Keys']:
    keys.append(Key(keybind['mods'], keybind['key'], eval(keybind['command'])))

for keychord in keybindings['Keychords']:
    submappings = [Key(k['mods'], k['key'], eval(k['command'])) for k in keychord['submappings']]

    keys.append(KeyChord(keychord['mods'], keychord['key'], submappings))

layouts = [
    # layout.Columns(**layout_theme),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**mode.current),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = {
    "font": "JetBrains Mono Nerd Font Medium",
    "fontsize": 12,
    "padding": 3,
}
extension_defaults = widget_defaults.copy()

def get_backlight_device():
    """
    Detects and returns the first available backlight device.

    Returns:
        str: The name of the first available backlight device.
        None: If no backlight device is found.
    """
    backlight_dir = "/sys/class/backlight"
    if os.path.isdir(backlight_dir):
        devices = os.listdir(backlight_dir)
        if len(devices) > 0:
            return devices[0]
    return None


def get_wireless_interface():
    """
    Dynamically detect the wireless network interface.

    Returns:
        str: Name of the wireless network interface.
    """
    result = subprocess.run(["ip", "link"], capture_output=True, text=True, check=True)
    for line in result.stdout.split("\n"):
        if "wlan" in line or "wlp" in line:
            return line.split(":")[1].strip()
    return "wlan0"


sep_config = {
    "size_percent": 0,
    "padding": 8,
}

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text="󰀻",
                    foreground=colors["background"],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "rofi -show drun -p"
                        )
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["color4"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                ),
                widget.Sep(**sep_config),
                widget.TextBox(
                    text="󰖯",
                    foreground=colors["background"],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "rofi -show window -p"
                        )
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["color6"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                ),
                widget.Sep(**sep_config),
                widget.GroupBox(
                    borderwidth=0,
                    block_highlight_text_color=colors["color3"],
                    active=colors["foreground"],
                    inactive=colors["color8"],
                    disable_drag=True,
                    radius=True,
                    padding_x=0,
                    margin_x=28,
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                ),
                widget.Prompt(foreground=colors["color8"]),
                widget.Spacer(),
                widget.Memory(
                    format="󰍛 {MemUsed:.0f}{mm}",
                     mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(f"{terminal} -e btop")
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                    foreground=colors["color5"],
                ),
                widget.Sep(**sep_config),
                widget.CPU(
                    format="󰘚 {load_percent}%",
                     mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(f"{terminal} -e btop")
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                    foreground=colors["color6"],
                ),
                widget.Sep(**sep_config),
                widget.Battery(
                    format="{char} {percent:2.0%}",
                    charge_char="󰂄",
                    discharge_char="󰁹",
                    empty_char="󰂃",
                    full_char="󰁹",
                    show_short_text=False,
                    not_charging_char="󰁹",
                     mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("power-safe")
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                    foreground=colors["color2"],
                ),
                widget.Sep(**sep_config),
                widget.Backlight(
                    fmt="󰃚 {}",
                    backlight_name=get_backlight_device() or "intel_backlight",
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                    foreground=colors["color3"],
                ),
                widget.Sep(**sep_config),
                widget.Clock(
                    format="󰥔 %I:%M",
                    decorations=[
                        RectDecoration(
                            colour=colors["background"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                    foreground=colors["color4"],
                ),
                widget.Sep(**sep_config),
                widget.Wlan(
                    fmt="  {}",
                    format="{essid}",
                    interface=get_wireless_interface(),
                    foreground=colors["background"],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(f"{terminal} -e nmtui")
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["color2"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                ),
                widget.Sep(**sep_config),
                widget.TextBox(
                    text="󰐥",
                    foreground=colors["background"],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("power-menu-qtile")
                    },
                    decorations=[
                        RectDecoration(
                            colour=colors["color1"],
                            radius=widget_radius,
                            filled=True,
                        )
                    ],
                ),
            ],
            42,
            background="#00000000",
            border_color="#00000000",
            border_width=[8, 8, 0, 8],
        ),
    ),
]


# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    **mode.current,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wl_xcursor_theme = "Nordzy-cursors"
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "QTILE"
