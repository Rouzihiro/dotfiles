from libqtile import qtile
from libqtile.config import EzKey, KeyChord, Key
from libqtile.lazy import lazy
from mode import mode

# Key bindings
def create_keys():
    """Create and return all key bindings."""

    from config import APPS, MOD

    qtile_keys = [
        # Window focus
        EzKey("M-h", lazy.layout.left(), desc="Move focus to left"),
        EzKey("M-l", lazy.layout.right(), desc="Move focus to right"),
        EzKey("M-j", lazy.layout.down(), desc="Move focus down"),
        EzKey("M-k", lazy.layout.up(), desc="Move focus up"),
        EzKey("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),

        # Window movement
        EzKey("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        EzKey("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        EzKey("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
        EzKey("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

        # Window resizing
        EzKey("M-C-j", lazy.layout.shrink(), desc="Shrink window"),
        EzKey("M-C-k", lazy.layout.grow(), desc="Grow window"),
        EzKey("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

        # Layout controls
        EzKey("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
        EzKey("M-z", lazy.next_layout(), desc="Toggle between layouts"),

        # Window controls
        EzKey("M-S-q", lazy.window.kill(), desc="Kill focused window"),
        EzKey("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
        EzKey("M-S-<space>", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),

        # System controls
        EzKey("M-C-r", lazy.reload_config(), desc="Reload the config"),
        EzKey("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
        EzKey("M-m", lazy.function(mode.toggle), desc="Toggle DND"),

        # Applications
        EzKey("M-<Return>", lazy.spawn(APPS["terminal"]), desc="Launch terminal"),
        EzKey("M-d", lazy.spawn(APPS["launcher"]), desc="Exec app launcher"),
        EzKey("M-e", lazy.spawn(APPS["file_manager"]), desc="Exec File manager"),
        EzKey("M-b", lazy.spawn(APPS["browser"]), desc="Exec browser"),
        EzKey("M-c", lazy.spawn(APPS["editor"]), desc="Exec editor"),
        EzKey("M-<Tab>", lazy.spawn(APPS["notification_center"]), desc="Exec notification center"),

        # Scripts
        EzKey("M-S-n", lazy.spawn("rofi-notes"), desc="Spawn rofi with notes script"),
        EzKey("M-C-t", lazy.spawn("toggle-theme"), desc="Exec theme switcher script"),
        EzKey("M-w", lazy.spawn("wallrandom"), desc="Exec random wallpaper script"),
        EzKey("M-C-p", lazy.spawn("wl-color-picker"), desc="Exec color picker application"),

        # Scratchpad
        EzKey("M-s", lazy.group["scratchpad"].dropdown_toggle("Music")),
        EzKey("M-a", lazy.group["scratchpad"].dropdown_toggle("Term")),

        # Screenshots
        EzKey("M-S-s", lazy.spawn("flameshot gui -c && wl-paste --type image/png > /tmp/clip.png", shell=True)),
        EzKey("M-o", lazy.spawn("eog /tmp/clip.png"), desc="Open last captured image"),

        # Keyboard layout
        EzKey("S-<Tab>", lazy.widget["keyboardlayout"].next_keyboard()),

        # Media keys - Audio
        EzKey("<XF86AudioRaiseVolume>", lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+")),
        EzKey("<XF86AudioLowerVolume>", lazy.spawn("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-")),
        EzKey("<XF86AudioMute>", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
        EzKey("<XF86AudioPlay>", lazy.spawn("playerctl --player=spotify,%any play-pause")),
        EzKey("<XF86AudioPrev>", lazy.spawn("playerctl --player=spotify,%any previous")),
        EzKey("<XF86AudioNext>", lazy.spawn("playerctl --player=spotify,%any next")),

        # Media keys - Brightness
        EzKey("<XF86MonBrightnessDown>", lazy.spawn("brightnessctl set 5%-")),
        EzKey("<XF86MonBrightnessUp>", lazy.spawn("brightnessctl set +5%")),

        # MPD controls
        EzKey("M-p", lazy.spawn("mpc toggle"), desc="Pause/Unpause mpd player"),
        EzKey("M-S-<period>", lazy.spawn("mpc next"), desc="Mpd play next song"),
        EzKey("M-S-<comma>", lazy.spawn("mpc prev"), desc="Mpd play prev song"),
        EzKey("M-<semicolon>", lazy.spawn("mpc volume +5"), desc="Mpd volume up"),
        EzKey("M-S-<semicolon>", lazy.spawn("mpc volume -5"), desc="Mpd volume down"),

        # KeyChord
        KeyChord([MOD], "i", [EzKey("M-i", lazy.ungrab_all_chords())], mode=True, name="Vm Mode"),
    ]

    # Workspace key bindings
    WORKSPACE_KEYS = [
        ("ampersand", "1"), ("bracketleft", "2"), ("braceleft", "3"), 
        ("braceright", "4"), ("parenleft", "5"), ("equal", "6"),
        ("asterisk", "7"), ("parenright", "8"), ("plus", "9"), ("bracketright", "0"),
    ]

    # VT switching for Wayland
    for vt in range(1, 8):
        qtile_keys.append(
            Key(
                ["control", "mod1"],
                f"f{vt}",
                lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
                desc=f"Switch to VT{vt}",
            )
        )

    for key, group in WORKSPACE_KEYS:
        qtile_keys += [
            Key([MOD], key, lazy.group[group].toscreen()),
            Key([MOD, "shift"], key, lazy.window.togroup(group)),
        ]

    return qtile_keys

