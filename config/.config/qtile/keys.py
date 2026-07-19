from libqtile.config import Key
from libqtile.lazy import lazy

from settings import (
    mod,
    alt,
    terminal,
    terminal2,
    launcher,
    fm,
    tfm,
    files,
    editor,
    lockscreen,
    ROFI_SCRIPTS,
)

def browser_hub(qtile):
    browser_group = qtile.groups_map["B"]

    if qtile.current_group != browser_group:
        browser_group.toscreen()
        return
    
    if not browser_group.windows:
        qtile.spawn("firefox")

    else:
        qtile.spawn(f"{ROFI_SCRIPTS}/rofi-bookmarks")


def dashboard_toggle(qtile):
    dashboard_group = qtile.groups_map["D"]

    if qtile.current_group != dashboard_group:
        dashboard_group.toscreen()
        return

    if dashboard_group.windows:
        qtile.spawn("bash -c '$HOME/Projects/dashboard/stop-dashboard.sh'")
    else:
        qtile.spawn("bash -c '$HOME/Projects/dashboard/start-dashboard-2.sh'")

def terminal_hub(qtile):
    terminal_group = qtile.groups_map["1"]

    if qtile.current_group != terminal_group:
        terminal_group.toscreen()
        return

    if not terminal_group.windows:
        qtile.spawn(terminal)
    else:
       qtile.spawn(
            f"{terminal} -e /home/rey/.config/qtile/scripts/new-tmux.sh"
)


keys = [
    Key([mod], "Escape", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-power")),
    Key([mod], "Return", lazy.function(terminal_hub)),
    Key([mod, alt], "Return", lazy.spawn(terminal)),
    Key([mod, "shift"], "Return", lazy.spawn(f"{terminal} -T floaty-big")),
    Key([mod], "k", lazy.spawn(terminal2)),

    Key([alt], "r", lazy.spawn("zsh -ic 'themes rotate'")),

    Key([mod], "space", lazy.spawn(launcher)),
    Key([mod, alt], "space", lazy.spawn(f"{ROFI_SCRIPTS}/quick-actions")),
    Key([mod, "control"], "space", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-scripts")),

    Key([mod], "a", lazy.spawn(f"{terminal2} -e btop")),
    Key([mod, alt], "a", lazy.spawn(f"{terminal2} --title floaty-big -e sh -c ncdu")),

    # Browser hub
    Key([mod], "b", lazy.function(browser_hub)),
    Key([mod, alt], "b", lazy.spawn("firefox")),
    Key([mod, "shift"], "b", lazy.spawn(f"{terminal2} --title floaty-big -e sh -c bt")),

Key(
    [mod],
    "d",
    lazy.function(dashboard_toggle),
    desc="Dashboard toggle",
),

    Key(
        [mod, alt],
        "d",
        lazy.spawn("bash -c '$HOME/Projects/dashboard/stop-dashboard.sh'"),
        desc="stop dashboard",
    ),

    Key(
        [mod, "shift"],
        "d",
        lazy.window.togroup("D", switch_group=True),
        desc="Move window to dashboard",
    ),

    Key([mod], "e", lazy.spawn(fm)),
    Key([mod, alt], "e", lazy.spawn(tfm)),
    Key([mod, "shift"], "e", lazy.spawn(files)),

    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),

    Key([mod], "g", lazy.spawn("~/.config/qtile/scripts/dashboard-git.sh")),
    Key(
        [mod, alt],
        "g",
        lazy.spawn(
            f'{terminal2} --title floaty-big -e zsh -ic "fzf-aliases; exec zsh"'
        ),
    ),

    Key([mod], "i", lazy.spawn(f"{terminal2} --title floaty-medium -e sh -c fzf-wifi")),
    Key([mod, alt], "i", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-wifi")),

    Key([mod, alt], "l", lazy.spawn(lockscreen)),

    Key([mod], "m", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-mount-usb")),
    Key([mod, alt], "m", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-monitor-switch")),

    Key([mod], "n", lazy.spawn(f"{terminal2} --title floaty-small -e sh -c fzf-notes")),
    Key([mod, alt], "n", lazy.spawn(editor)),
    Key([mod, "shift"], "n", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-notes")),

    Key([mod], "o", lazy.spawn("ocr")),
    Key([mod, alt], "o", lazy.spawn("sh -c text-picker")),

    # Scratchpad
    Key([mod], "p", lazy.group["scratchpad"].dropdown_toggle("term")),
    Key(
        [mod, alt],
        "p",
        lazy.window.toggle_floating(),
        lazy.window.set_size_floating(1200, 1000),
        lazy.window.center(),
    ),
    Key([mod, "shift"], "p", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-power-profile")),

    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "q", lazy.shutdown()),

    Key([mod], "r", lazy.spawn("screenrecord")),
    Key([mod, alt], "r", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-screenrecord")),
    Key([mod, "shift"], "r", lazy.reload_config()),

    Key([mod], "s", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-screenshot")),
    Key([mod, alt], "s", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-screenshot-fs")),

    Key(
        [mod],
        "t",
        lazy.spawn(
            "zsh -ic 'source ~/dotfiles/flavors/themes.zsh; _osyx_rofi_theme_picker'"
        ),
    ),
    Key([mod, alt], "t", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-timewarrior")),

    Key([mod], "v", lazy.spawn(f"{terminal2} --title floaty-small -e sh fzf-video-play")),
    Key([mod, alt], "v", lazy.spawn(f"{terminal2} --title floaty-tiny -e sh fzf-video-tool")),
    Key([mod, "shift"], "v", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-video-tool")),

    Key([mod], "w", lazy.spawn(f"{ROFI_SCRIPTS}/rofi-wall")),
    Key([mod, alt], "w", lazy.spawn("/home/rey/scripts/wallwaper-random.sh")),

    Key([mod], "x", lazy.spawn("asryx")),

    Key([mod], "z", lazy.spawn("~/.config/qtile/scripts/keybindings-qtile")),

    Key([mod], "grave", lazy.spawn("~/.config/qtile/scripts/list-qtile-windows")),

    # Focus
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),

    # Move windows
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),

    # Cycle windows
    Key([mod], "Tab", lazy.layout.next()),
    Key([mod, "shift"], "Tab", lazy.layout.previous()),

    # Brightness
    Key([], "XF86MonBrightnessDown",
        lazy.spawn("/home/rey/.config/qtile/scripts/brightness.sh down")),
    Key([], "XF86MonBrightnessUp",
        lazy.spawn("/home/rey/.config/qtile/scripts/brightness.sh up")),

    # Volume
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("/home/rey/.config/qtile/scripts/volume.sh down")),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("/home/rey/.config/qtile/scripts/volume.sh up")),
    Key([], "XF86AudioMute",
        lazy.spawn("/home/rey/.config/qtile/scripts/volume.sh mute")),

    # Media
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
]

for group in ["1", "2", "3", "4", "5"]:
    keys.extend([
        Key([mod], group, lazy.group[group].toscreen()),
        Key([mod, "shift"], group, lazy.window.togroup(group, switch_group=False)),
    ])
