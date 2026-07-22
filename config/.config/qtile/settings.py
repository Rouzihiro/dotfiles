import os

HOME = os.path.expanduser("~")

mod = "mod4"
alt = "mod1"

opacity = 0.9

CONFIG = f"{HOME}/.config"
SCRIPTS = f"{HOME}/scripts"
QTILE_SCRIPTS = f"{CONFIG}/qtile/scripts"
ROFI_SCRIPTS = f"{CONFIG}/rofi/scripts"
PROJECTS = f"{HOME}/Projects"
DASHBOARD_DIR = f"{PROJECTS}/dashboard"

terminal = "foot"
terminal2 = "kitty"
browser = f"{HOME}/.local/bin/zen"
files = "thunar"
fm = f"{terminal} -e superb"
tfm = f"{terminal} -e yazi"
editor = f"{terminal} -e nvim"

launcher = f"rofi -show drun -m -1 -theme {HOME}/.config/rofi/launcher.rasi"
lockscreen = f"swaylock -i {HOME}/Pictures/lockscreen/VIM.png"
