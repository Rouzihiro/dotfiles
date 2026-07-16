import os

HOME = os.path.expanduser("~")

# Mod key: sway used Mod4, matches directly.
mod = "mod4"
alt = "mod1"

opacity = 0.9

# --- Core apps ---
terminal = "foot"
terminal2 = "kitty"
launcher = f"rofi -show drun -m -1 -theme {HOME}/.config/rofi/launcher.rasi"

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
