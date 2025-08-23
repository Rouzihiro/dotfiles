import os
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Mod key (Alt or Super/Windows key)
mod = "mod1"  # Alt key
# mod = "mod4"  # Super/Windows key

# Terminal emulator
terminal = guess_terminal()  # Automatically detects your terminal
# terminal = "alacritty"  # Or specify manually
# terminal = "xterm"

# Key bindings
keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    
    # Move windows between left/right columns or move up/down in current stack
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    
    # Grow/shrink windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    
    # Toggle between split and unsplit sides of stack
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    
    # Launch terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    
    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    
    # Kill focused window
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    
    # Restart Qtile
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    
    # Shutdown Qtile
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    
    # Launch rofi (install it first: sudo pacman -S rofi)
    Key([mod], "d", lazy.spawn("rofi -show run"), desc="Spawn a command using rofi"),
]

# Groups/Workspaces
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # Switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        # Move window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc=f"Move focused window to group {i.name}"),
    ])

# Layouts
layouts = [
    layout.Columns(border_focus='#ff0000', border_width=2, margin=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# Widget defaults
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# Screens (status bar)
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
            ],
            24,  # Bar height
        ),
    ),
]

# Mouse bindings
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Floating layout rules
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
    ]
)

# Other settings
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# WM name
wmname = "LG3D"
