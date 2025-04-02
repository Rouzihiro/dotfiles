import os
import subprocess
import socket
import sys
from libqtile import hook, qtile
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration
from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Key, KeyChord
from theme import colors
from mode import Mode

from mode import Mode
from os.path import expanduser, exists, normpath, getctime
from yaml import safe_load
from shutil import which
from json import dump, load

sys.path.append(expanduser('~/.config/qtile/'))

from variables import *
keybindings_file = expanduser(keybindings_file)

# Set backend
if qtile.core.name == "wayland":
    os.environ["XDG_SESSION_DESKTOP"] = "qtile:wlroots"
    os.environ["XDG_CURRENT_DESKTOP"] = "qtile:wlroots"

# Variables
host = socket.gethostname()
mod = "mod4"
terminal = "footclient" if qtile.core.name == "wayland" else "alacritty"
browser = "qutebrowser"
launcher = "rofi -show drun"
fileManager = "thunar"
editor = "nvim"
ntCenter = "swaync-client -t -sw"
mode = Mode()


# Startup
@hook.subscribe.startup_once
def autostart():
    commands = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "systemctl --user restart pipewire",
        "foot --server",
        #"swaync",
        #"udiskie",
        #"flameshot",
        #"conky -c ~/.config/conky/conky-qtile.conf",
        "focus-mode",
    ]

screenshots_path = expanduser(screenshots_path)
layouts_saved_file = expanduser(layouts_saved_file)
keybindings_file = expanduser(keybindings_file)
wallpapers_path = expanduser(wallpapers_path)

#autostarts = list(map(expanduser, autostarts))

if not exists(path := layouts_saved_file):
    with open(path, 'w') as file:
        file.write('{}')

if not exists(screenshots_path):
    makedirs(screenshots_path)

if not exists(wallpapers_path):
    makedirs(wallpapers_path)

def guess(apps):
    for app in apps:
        if which(app): break

    return app

if not terminal:
    terminal = guess([
        'foot'
        'alacritty',
        'kgx',
        'kconsole',
        'xterm',
        'urxvt',
        'kitty',
        'st'
    ])

if not browser:
    browser = guess([
        'qutebrowser'
        'zen-browser',
        'librewolf',
        'vivaldi',
        'waterfox',
        'brave',
        'firefox',
        'chromium',
        'chrome'
    ])

if not file_manager:
    file_manager = guess([
        'thunar',
        'pcmanfm',
        'nautilus',
        'dolphin'
    ])    


#  _____                          
# |   __| ___  ___  _ _  ___  ___ 
# |  |  ||  _|| . || | || . ||_ -|
# |_____||_|  |___||___||  _||___|
#                       |_|       

groups_names = list(map(str, range(1, groups_count + 1)))
groups = [Group(name) for name in groups_names]


#  _____  _              _              _        
# |   __|| |_  ___  ___ | |_  ___  _ _ | |_  ___ 
# |__   ||   || . ||  _||  _||  _|| | ||  _||_ -|
# |_____||_|_||___||_|  |_|  |___||___||_|  |___|

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
    "fontsize": 14,
    "padding": 3,
}
extension_defaults = widget_defaults.copy()


def powerline(arg):
    return {
        "decorations": [
            PowerLineDecoration(
                path=f"{arg}",
                stroke_weight=4,
                stroke_colour=colors["base00"],
                use_widget_background=True,  # Ensures background color is applied
            )
        ]
    }


def search():
    qtile.cmd_spawn("rofi -show drun")


widget_list = [
    widget.Image(
        filename="~/.config/qtile/assets/nord-logo.png",
        background=colors["base00"],
        margin_y=2,
        margin_x=12,
        mouse_callbacks={
            "Button1": lambda: qtile.cmd_spawn("xdg-open https://nordtheme.com")
        },
        **powerline("forward_slash"),
    ),
    widget.GroupBox(
        highlight_method="text",
        borderwidth=3,
        rounded=True,
        active=colors["base15"],
        highlight_color=colors["base01"],
        inactive=colors["base03"],
        this_current_screen_border=colors["base09"],
        this_screen_border=colors["base01"],
        urgent_border=colors["base11"],
        disable_drag=True,
        **powerline("back_slash"),
    ),
    widget.Spacer(length=2),
    widget.CurrentLayoutIcon(
        custom_icon_paths=["~/.config/qtile/assets/layout"],
        padding=4,
        scale=0.7,
    ),
    widget.CurrentLayout(
        foreground=colors["base09"],
        padding=4,
    ),
    widget.Spacer(
        length=2,
        **powerline("back_slash"),
    ),
    widget.TextBox(
        text="  ",
        background=colors["base00"],
        foreground=colors["base15"],
        mouse_callbacks={"Button1": search},
    ),
    widget.TextBox(
        fmt="Search",
        background=colors["base00"],
        foreground=colors["base15"],
        mouse_callbacks={"Button1": search},
        **powerline("rounded_left"),
    ),
    widget.WindowName(
        foreground=colors["base09"],
        format=" {class} ",
        empty_group_string="Desktop",
    ),
    widget.Spacer(**powerline("rounded_right")),
    widget.StatusNotifier(
        background=colors["base00"],
        padding=5,
        icon_size=16,
        menu_background=colors["base00"],
        menu_foreground_highlighted=colors["base00"],
        highlight_colour=colors["base10"],
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
    widget.Battery(
        foreground=colors["base09"],
        charge_char=" 󰂄",
        discharge_char=" 󰁿",
        empty_char=" 󰂎",
        format="{char} {percent:2.0%} {hour:d}:{min:02d} ",
        **powerline("forward_slash"),
    ),
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
        configured_keyboards=["de"],
        display_map={"de": "DE"},
        option="caps:escape",
        **powerline("back_slash"),
    ),
    widget.TextBox(
        text="  ",
        fontsize=16,
        background=colors["base00"],
        foreground=colors["base15"],
    ),
    widget.Clock(
        format="%I:%M %p ",
        background=colors["base00"],
        foreground=colors["base15"],
    ),
]

if host != "laptop":
    del widget_list[14]

screens = [
    Screen(
        wallpaper="~/Pictures/wallpapers/Dune3.png",
        wallpaper_mode="fill",
        top=bar.Bar(widget_list, 24, background=colors["base01"]),
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

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:pointer": InputConfig(
        accel_profile="flat",
    ),
}

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
