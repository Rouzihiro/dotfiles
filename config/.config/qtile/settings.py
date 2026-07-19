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

lockscreen = f"swaylock -i {HOME}/Pictures/lockscreen/VIM.png"
ROFI_SCRIPTS = f"{HOME}/.config/rofi/scripts"
