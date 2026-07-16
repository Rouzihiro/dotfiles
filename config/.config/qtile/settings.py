"""
settings.py — variables equivalent to the top of your sway config
(where you set $mod, $term, $launcher, etc).

Now targeting Qtile's Wayland backend, so foot/swaylock are back in play —
no more X11 substitutions needed for those two.
"""

import os

HOME = os.path.expanduser("~")

# Mod key: sway used Mod4, matches directly.
mod = "mod4"
alt = "mod1"

opacity = 0.9

# --- Core apps ---
terminal = "foot"            # was swapped to kitty for X11 — foot works natively under Wayland
terminal2 = "kitty"          # unchanged — kitty also has native Wayland support
launcher = f"rofi -show drun -theme {HOME}/.config/rofi/launcher.rasi"
# NOTE: stock rofi is X11-only; under Qtile's Wayland backend it'll launch via
# XWayland automatically (Qtile spawns XWayland on demand for X11 clients),
# so no change is strictly required. If you'd rather go fully native, the
# rofi-wayland fork (github.com/lbonn/rofi) is a drop-in replacement binary.
browser = "firefox"
files = "thunar"
fm = f"{terminal} -e superb"
tfm = f"{terminal} -e yazi"
editor = f"{terminal} -e nvim"

# swaylock uses the ext-session-lock-v1 protocol. Qtile's wlroots backend
# should support it, but this is less battle-tested than sway/Hyprland's
# own implementation — if it doesn't lock cleanly, waylock is the fallback.
lockscreen = f"swaylock -i {HOME}/Pictures/lockscreen/VIM.png"

# wallpaper lives in theme.py now — it's theme data, not a static app path

# Rofi scripts (unchanged — these are just scripts, not sway-specific)
ROFI_SCRIPTS = f"{HOME}/.config/rofi/scripts"
