import os
import subprocess
import socket
from libqtile import hook, qtile
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from libqtile.backend.wayland import InputConfig
from qtile_extras.widget.decorations import PowerLineDecoration
from libqtile.config import Key, KeyChord
from theme import colors

# Set backend
if qtile.core.name == "wayland":
    os.environ["XDG_SESSION_DESKTOP"] = "qtile:wlroots"
    os.environ["XDG_CURRENT_DESKTOP"] = "qtile:wlroots"


# Startup
@hook.subscribe.startup_once
def autostart():
    commands = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &",
        "systemctl --user restart pipewire &",
        "foot --server &",
        #"swaync &",
        #"udiskie &",
       "conky -c ~/.config/conky/conky-qtile.conf &",
       ]
    [
        subprocess.run(
            i,
            shell=True,
        )
        for i in commands
    ]


# Variables
mod = "mod4"
ALT = "mod1"
host = socket.gethostname()
terminal = "footclient"
browser = "librewolf"
launcher = "wofi --show drun"
fileManager = "nautilus"
editor = "foot -e nvim"

keys = [

    Key([ALT], "e", lazy.spawn("foot -e yazi")),
    Key([mod, "shift"], "Backspace", lazy.spawn("powerswitch-wofi")),
    Key([mod, "shift"], "Backspace", lazy.spawn("foot -e btop")),
    Key([mod, "shift"], "v", lazy.spawn("videotool-wofi")),
    Key([mod], "v", lazy.spawn("browse-videos")),
    Key([mod, "shift"], "x", lazy.spawn(f"{terminal} -e zsh -c executer")),
    Key([mod], "x", lazy.spawn("browse-scripts")),
    Key([mod], "i", lazy.spawn("ocr-translate")),
    Key([mod], "o", lazy.spawn("ocr")),
    Key([mod, "shift"], "o", lazy.spawn("ocr-prompt")),
    Key([mod, "shift"], "w", lazy.spawn("wallpaper")),
    Key([mod], "w", lazy.spawn("wallpaper-random")),
    Key([mod], "k", lazy.spawn("keybinds-shell")),
    Key([mod], "b", lazy.spawn("browse-web")),
    Key([mod, "shift"], "m", lazy.spawn("monitor-switch-qtile-gui")),
    # Screenshot

   # Fullscreen screenshot with notification
    Key([mod], "Print", lazy.spawn("sh -c 'grim ~/Pictures/screenshots/screen-$(date '+%Y%m%d-%H%M%S').png && notify-send \"Screenshot\" \"Fullscreen screenshot saved\"'"),

    # Copy selected screenshot to clipboard with notification
    Key([], "Print", lazy.spawn("sh -c 'slurp | grim -g - - | wl-copy && notify-send \"Screenshot\" \"Screenshot copied to clipboard\"'"),

 # Select an area to screenshot with notification (Super + S)
    Key([mod, "shift"], "s", lazy.spawn("sh -c 'slurp | grim -g - ~/Pictures/screenshots/screen-$(date '+%Y%m%d-%H%M%S').png && notify-send \"Screenshot\" \"Selected area screenshot saved\"'"),

    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "Shift"], "space", lazy.layout.next()),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()), 
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "j", lazy.layout.shrink()),
    Key([mod, "control"], "k", lazy.layout.grow()),
    Key([mod], "n", lazy.layout.normalize()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn(terminal)),
    # Toggle between different layouts as defined below
    Key([mod], "z", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "t", lazy.window.toggle_floating()),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "SPACE", lazy.spawn(launcher), desc="Exec app launcher"),
    Key([mod], "e", lazy.spawn(fileManager), desc="Exec File manager"),
    Key([mod, "Shift"], "b", lazy.spawn(browser), desc="Exec browser"),
    Key([mod], "c", lazy.spawn(editor), desc="Exec editor"),
   
    #Key(["Shift"], "Tab", lazy.widget["keyboardlayout"].next_keyboard()),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl --player=spotify,%any play-pause")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl --player=spotify,%any previous")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl --player=spotify,%any next")),

KeyChord([mod], "i", [
    Key([], "i", lazy.ungrab_all_chords()) 
], mode=True, name="Vm Mode"),
        
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
        "p",
        [
            DropDown(
                "Music", "spotify", opacity=1, height=0.5, on_focus_lost_hide=False
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
    Group("1", label=" "),
    Group("2", label="󰈹 ", matches=[Match(wm_class="Navigator"), Match(wm_class="vivaldi-stable")], spawn=browser,),
    Group("3", label=" "),
    Group("4", label=" ", matches=[Match(wm_class="obsidian")]),
    Group("5", label=" "),
    Group("6", label="󰑈 "),
    Group("7", label=" "),
    Group("8", label="󰧮 "),
    Group("9", label=" ", matches=[Match(wm_class="discord")], spawn="discord"),
    Group("0", label="󰮂 ", matches=[Match(wm_class="steam")]),
]

layout_theme = {
    "border_focus": "#5E81AC",
    "border_normal": "#4C566A",
    "border_width": 2,
    "margin": 5,
}

layouts = [
    # layout.Columns(**layout_theme),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
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


def powerline(direction):
    return {
        "decorations": [
            PowerLineDecoration(
                path=f"arrow_{direction}",
                use_widget_background=True,  # Ensures background color is applied
            )
        ]
    }


widget_list = [
    widget.Spacer(length=2, **powerline("left")),
    widget.GroupBox(
        background=colors["base00"],
        fontsize=20,
        active=colors["base09"],
        inactive=colors["base03"],
        block_highlight_text_color="#FFFFFF",
        highlight_method="line",
        highlight_color=colors["base01"],
        this_current_screen_border=colors["base09"],
        urgent_alert_method="line",
        urgent_border=colors["base11"],
        disable_drag=True,
        **powerline("left"),
    ),
    widget.Spacer(
        length=2,
    ),
    widget.TextBox(
        foreground=colors["base05"],
        text="|",
        padding=2,
    ),
    widget.CurrentLayoutIcon(foreground=colors["base05"], padding=4, scale=0.6),
    widget.CurrentLayout(
        foreground=colors["base05"],
        padding=5,
    ),
    widget.TextBox(
        foreground=colors["base05"],
        text="|",
        padding=2,
    ),
    widget.Spacer(**powerline("right")),
    widget.CPU(
        background=colors["base00"],
        foreground=colors["base09"],
        format="󰍹 Cpu:{load_percent}%",
        mouse_callbacks={"Button1": lambda: qtile.spawn(f"{terminal} btop")},
        **powerline("right"),
    ),
    widget.Memory(
        foreground=colors["base15"],
        format=" Mem:{NotAvailable:.0f}{mm}",
        mouse_callbacks={"Button1": lambda: qtile.spawn(f"{terminal} btop")},
        **powerline("right"),
    ),
    widget.DF(
        background=colors["base00"],
        update_interval=60,
        foreground=colors["base14"],
        mouse_callbacks={"Button1": lambda: qtile.spawn(f"{terminal} -H df")},
        partition="/",
        format="🖴 Disk:{uf}{m}",
        visible_on_warn=False,
        **powerline("right"),
    ),
    widget.Spacer(length=6, **powerline("right")),
    widget.TextBox(
        background=colors["base03"],
        fmt=" ",
        padding=None,
        fontsize=26,
        foreground=colors["base09"],
        mouse_callbacks={
            "Button1": lambda: qtile.spawn(f"{browser} github.com/Rouzihiro/HP-Nix")
        },
        **powerline("left"),
    ),
    widget.Spacer(length=6, **powerline("left")),
    widget.Clock(
        background=colors["base00"],
        foreground=colors["base11"],
        format="󰥔 Time:%H:%M ",
        **powerline("left"),
    ),
    widget.Clock(
        foreground=colors["base13"], format=" Date:%d-%m ", **powerline("left")
    ),
    widget.StatusNotifier(background=colors["base00"], padding=5, **powerline("left")),
    widget.Spacer(**powerline("right")),
    widget.Battery(
        background=colors["base00"],
        foreground=colors["base14"],
        charge_char="󰂄",
        discharge_char="󰁿",
        empty_char="󰂎",
        format="{char} {percent:2.0%} {hour:d}:{min:02d}",
        **powerline("right"),
    ),
    widget.GenPollText(
        update_interval=300,
        func=lambda: subprocess.check_output(
            "printf $(uname -r)", shell=True, text=True
        ),
        foreground=colors["base12"],
        fmt=" {}",
        **powerline("right"),
    ),
    widget.PulseVolume(
        background=colors["base00"],
        foreground=colors["base13"],
        fmt=" :{}",
        **powerline("right"),
    ),
    widget.KeyboardLayout(
        foreground=colors["base08"],
        configured_keyboards=["de"],
        display_map={"de": "DE"},
        option="caps:escape",
        fmt=" Kbd:{}",
        **powerline("right"),
    ),
    widget.WindowName(
        background=colors["base00"],
        foreground=colors["base06"],
        format="{class} ",
        empty_group_string="Desktop",
        max_chars=12,
        width=90,
        **powerline("right"),
    ),
    widget.Chord(
        chords_colors={
            "launch": (colors["base01"], colors["base12"]),
        },
        foreground=colors["base12"],
        fmt="| {} |",
        name_transform=lambda name: name.upper(),
    ),
]

if host != "HP":
    del widget_list[-6]

screens = [
    Screen(
        wallpaper=f"~/Pictures/wallpapers/Earth.jpg",
        wallpaper_mode="fill",
        top=bar.Bar(widget_list, 24, background=colors["base01"], reserve=True),
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
    **layout_theme,
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
    "type:touchpad": 
    InputConfig(tap=True, natural_scroll=True, dwt=True),
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
