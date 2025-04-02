import os
import subprocess
import socket
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


# Set backend
if qtile.core.name == "wayland":
    os.environ["XDG_SESSION_DESKTOP"] = "qtile:wlroots"
    os.environ["XDG_CURRENT_DESKTOP"] = "qtile:wlroots"

# Variables
host = socket.gethostname()
mod = "mod4"
terminal = "footclient" if qtile.core.name == "wayland" else "alacritty"
browser = "librewolf"
launcher = "rofi -show drun"
fileManager = "thunar"
editor = "code"
ntCenter = "swaync-client -t -sw"
mode = Mode()


# Startup
@hook.subscribe.startup_once
def autostart():
    commands = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "systemctl --user restart pipewire",
        "foot --server",
        "swaync",
        "udiskie",
        "flameshot",
        "conky -c ~/.config/conky/conky-qtile.conf",
        browser,
        "discord",
        "focus-mode",
    ]
    if host == "laptop":
        commands.remove(browser)
        commands.remove("discord")
    for cmd in commands:
        subprocess.Popen(
            cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )


FULLSCREEN_RULES = [
    Match(wm_class="flameshot"),
]


@hook.subscribe.client_managed
def force_fullscreen(client):
    if any(client.match(rule) for rule in FULLSCREEN_RULES):
        client.fullscreen = True


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "j", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod, "control"], "k", lazy.layout.grow(), desc="Grow window"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod],
        "o",
        lazy.function(mode.toggle),
        desc="Toggle DND",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "z", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "Shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "Shift"],
        "space",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn(launcher), desc="Exec app launcher"),
    Key([mod], "e", lazy.spawn(fileManager), desc="Exec File manager"),
    Key([mod], "b", lazy.spawn(browser), desc="Exec browser"),
    Key([mod], "c", lazy.spawn(editor), desc="Exec editor"),
    Key([mod], "Tab", lazy.spawn(ntCenter), desc="Exec notification center"),
    Key([mod, "Shift"], "s", lazy.spawn("flameshot gui -c")),
    Key(
        [mod], "p", lazy.spawn("wl-color-picker"), desc="Exec color picker application"
    ),
    Key(["Shift"], "Tab", lazy.widget["keyboardlayout"].next_keyboard()),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"),
    ),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl --player=com.github.th_ch.youtube_music,%any play-pause"),
    ),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl --player=com.github.th_ch.youtube_music,%any previous"),
    ),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("playerctl --player=com.github.th_ch.youtube_music,%any next"),
    ),
    KeyChord(
        [mod],
        "i",
        [Key([mod], "i", lazy.ungrab_all_chords())],
        mode=True,
        name="Vm Mode",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


# groups = [Group(i) for i in "123456789"]
groups = [
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "Music",
                "youtube-music --ozone-platform=x11",
                opacity=1,
                height=0.5,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "Term",
                "foot" if terminal == "footclient" else terminal,
                opacity=1,
                height=0.5,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    *[Group(f"{i}", label="") for i in range(1, 10)],
    Group(
        "2",
        matches=[
            Match(wm_class="Navigator"),
            Match(wm_class="vivaldi-stable"),
            Match(wm_class="librewolf"),
            Match(wm_class="brave-browser"),
        ],
    ),
    Group("4", matches=[Match(wm_class="obsidian")]),
    Group("9", matches=[Match(wm_class="discord")]),
    Group("0", label="", matches=[Match(wm_class="steam")]),
]

for i in groups:
    if not isinstance(i, ScratchPad):
        keys.extend(
            [
                # mod1 + group number = switch to group
                Key(
                    [mod],
                    i.name,
                    lazy.group[i.name].toscreen(),
                    desc="Switch to group {}".format(i.name),
                ),
                # mod1 + shift + group number = switch to & move focused window to group
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=True),
                    desc="Switch to & move focused window to group {}".format(i.name),
                ),
                Key([mod], "s", lazy.group["scratchpad"].dropdown_toggle("Music")),
                Key([mod], "a", lazy.group["scratchpad"].dropdown_toggle("Term")),
                # Or, use below if you prefer not to switch to that group.
                # # mod1 + shift + group number = move focused window to group
                # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                #     desc="move focused window to group {}".format(i.name)),
            ]
        )


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
        configured_keyboards=["us dvorak", "ge", "us"],
        display_map={"us dvorak": "USDV", "ge": "GE", "us": "US"},
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
        wallpaper="~/.config/wallpapers/outer_space.jpg",
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
