import os
import subprocess

from libqtile import hook, qtile

# Startup applications
@hook.subscribe.startup_once
def autostart():
   if qtile.core.name == "x11":
      autostartscript = "~/.dotfiles/home/configs/qtile/scripts/x11-autostart.sh"
   elif qtile.core.name == "wayland":
      autostartscript = "~/.dotfiles/home/configs/qtile/scripts/wayland-autostart.sh"
   
   home = os.path.expanduser(autostartscript)
   subprocess.Popen([home])
   