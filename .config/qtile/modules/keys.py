from libqtile import qtile
from libqtile.config import Click, Drag, Key
from libqtile.lazy import lazy

from .groups import groups

mod = "mod4"
terminal = "kitty"

keys = [
    # Open terminal
    Key([mod], "Return", lazy.spawn(terminal), 
        desc="Launch terminal"),

    # Qtile System Actions
    Key([mod, "shift"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),

    # Active Window Actions
    Key([mod], "f", lazy.window.toggle_fullscreen(), 
        desc="Toggle window fullscreen"),
    Key([mod], "q", lazy.window.kill(), 
        desc="Close active window"),
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Increase active window size."
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Increase active window size."
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Decrease active window size."
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Decrease active window size."
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Increase active window size."
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Increase active window size."
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Decrease active window size."
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Decrease active window size."
        ),

    # Window Focus (Arrows and Vim keys)
    Key([mod], "Up", lazy.layout.up(),
        desc="Change focus to window above."),
    Key([mod], "Down", lazy.layout.down(),
        desc="Change focus to window below."),
    Key([mod], "Left", lazy.layout.left(),
        desc="Change focus to window on the left."),
    Key([mod], "Right", lazy.layout.right(),
        desc="Change focus to window on the right."),
    Key([mod], "k", lazy.layout.up(),
        desc="Change focus to window above."),
    Key([mod], "j", lazy.layout.down(),
        desc="Change focus to window below."),
    Key([mod], "h", lazy.layout.left(),
        desc="Change focus to window on the left."),
    Key([mod], "l", lazy.layout.right(),
        desc="Change focus to window on the right."),
    
    # Move windows around MonadTall/MonadWide Layouts
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(),
        desc="Shuffle window up."),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(),
        desc="Shuffle window down."),
    Key([mod, "shift"], "Left", lazy.layout.swap_left(),
        desc="Shuffle window left."),
    Key([mod, "shift"], "Right", lazy.layout.swap_right(),
        desc="Shuffle window right."),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Shuffle window up."),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Shuffle window down."),
    Key([mod, "shift"], "h", lazy.layout.swap_left(),
        desc="Shuffle window left."),
    Key([mod, "shift"], "l", lazy.layout.swap_right(),
        desc="Shuffle window right."),

    # Qtile Layout Actions
    Key([mod], "r", lazy.layout.reset(),
        desc="Reset the sizes of all window in group."),
    Key([mod], "Tab", lazy.next_layout(),
        desc="Switch to the next layout."),
    Key([mod, "shift"], "f", lazy.layout.flip(),
        desc="Flip layout for Monadtall/Monadwide"),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(),
        desc="Toggle floating window."),
    
    # Switch focus to specific monitor (out of three)
    Key([mod], "i",
        lazy.to_screen(0),
        desc='Keyboard focus to monitor 1'),
    Key([mod], "o",
        lazy.to_screen(1),
        desc='Keyboard focus to monitor 2'),
    Key([mod], "p",
        lazy.to_screen(2),
        desc='Keyboard focus to monitor 3'),

    # Switch focus of monitors
    Key([mod], "period",
        lazy.prev_screen(),
        desc='Move focus to next monitor'),
    Key([mod], "comma",
        lazy.next_screen(),
        desc='Move focus to prev monitor'),
]

# Add group specific keybindings
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Mod + number to move to that group."),
        Key(["mod1"], "Tab", lazy.screen.next_group(),
            desc="Move to next group."),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group(),
            desc="Move to previous group."),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            desc="Move focused window to new group."),
    ])

# Scratchpad keybindings
keys.extend([
    Key(["mod1"], "Return", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key(["mod1"], "v", lazy.group['scratchpad'].dropdown_toggle('volume')),
    Key([mod], "a", lazy.group['scratchpad'].dropdown_toggle('angular')),
    Key([mod], "n", lazy.group['scratchpad'].dropdown_toggle('notebook')),
])

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# Application keybindings
keys.extend([
    Key([mod, "shift"], "Return", lazy.spawn("thunar"),
        desc="Launch file browser"),
    Key([mod], "Space", lazy.spawn("rofi -show drun"),
        desc="Application launcher"),
    Key([mod], "b", lazy.spawn("firefox"),
        desc="Launch web browser"),
    Key([mod], "m", lazy.spawn("mailspring"),
        desc="Launch email client"),
    Key([mod], "w", lazy.spawn("variety -n"),
        desc="Randomly select a new wallpaper"),
    Key([mod, "shift"], "w", lazy.spawn("variety -p"),
        desc="Go back to previous wallpaper"),
    Key(["control", "mod1"], "w", lazy.spawn("variety --selector"),
        desc="Open wallpaper selector"),
    Key(["mod1"], "f", lazy.spawn("variety -f"),
        desc="Save current wallpaper to favorites"),
    Key([mod], "x", lazy.spawn("killall variety"),
        desc="Kill Variety"),

    # Media Keys
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+"),
        desc="Volume Up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-"),
        desc="Volume Down"),
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        desc="Toggle Mute"),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"),
        desc="Play/Pause"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"),
        desc="Next Song"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"),
        desc="Previous Song"),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop"),
        desc="Stop music"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set 5%+"),
        desc="Increase brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"),
        desc="Decrease brightness"),
])

# Add X11-specific keybindings
if qtile.core.name == "x11":
    keys.extend([
        Key([mod, "shift"], "r", lazy.restart(),
            desc="Restart Qtile"),
        Key([mod], "Escape", lazy.spawn("xflock4"),
            desc="Lock screen"),
        Key([mod], "v", lazy.spawn("/home/wingej0/dotfiles/qtile/scripts/greenclip.sh"),
            desc="Clipboard Manager"),
        Key([], "XF86TouchpadToggle", lazy.spawn("/home/wingej0/dotfiles/scripts/touchpad-toggle.sh"),
            desc="Toggle Touchpad"),
    ])
# Add Wayland-specific keybindings
elif qtile.core.name == "wayland":
    keys.extend([
        Key([mod, "shift"], "r", lazy.reload_config(),
            desc="Reload Qtile config"),
        Key([mod], "Escape", lazy.spawn("swaylock"),
            desc="Lock screen"),
        Key(["control", "mod1"], "delete", lazy.spawn("wlogout"),
            desc="Launch powermenu"),
        Key([mod], "v", lazy.spawn("/home/wingej0/.dotfiles/configs/qtile/scripts/clipboard.sh"),
            desc="Clipboard Manager"),
        Key([mod], "print", lazy.spawn("/home/wingej0/.dotfiles/configs/qtile/scripts/gif-recorder.sh"),
            desc="Gif Recorder")
    ])


