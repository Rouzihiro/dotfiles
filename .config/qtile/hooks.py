from libqtile import hook
import subprocess

# Startup hook
@hook.subscribe.startup_once
def autostart() -> None:
    """
    Hook that runs once during startup
    Used to autostart some essential apps related to Dotfiles.
    """
    from config import HOST, IS_WAYLAND, APPS

    base_commands = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        "systemctl --user restart pipewire",
        "blueman-applet",
        "udiskie", 
        "flameshot",
        "focus-mode",
        "conky -c ~/.config/conky/conky-qtile.conf",
    ]
    
    wayland_commands = [
        "foot --server",
        "swww-daemon", 
        "wallrandom"
    ]
    
    desktop_commands = [
        APPS["browser"],
        "discord --disable-gpu"
    ]
    
    commands = base_commands
    if IS_WAYLAND:
        commands.extend(wayland_commands)
    if HOST == "desktop":
        commands.extend(desktop_commands)
    
    for cmd in commands:
        subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

@hook.subscribe.client_managed
def force_fullscreen(client) -> None:
    """
    Some clients won't start fullscreen (exclusive to wayland)
    With this function we force clients defined in FULLSCREEN_RULES to enter fullscreen
    """
    from config import FULLSCREEN_RULES

    if any(client.match(rule) for rule in FULLSCREEN_RULES):
        client.fullscreen = True
