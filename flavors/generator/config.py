from __future__ import annotations

from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parents[1]
ROOT_DIR = SCRIPT_DIR.parent
FLAVORS_DIR = ROOT_DIR / "flavors"
BASE_DIR = FLAVORS_DIR / "base"
PALETTES_DIR = FLAVORS_DIR / "palettes"

OUTPUTS = {
    "alacritty.toml.j2": str(Path.home() / ".config/alacritty/theme.toml"),
    "broot.toml.j2":     str(Path.home() / ".config/broot/skins/current.toml"),
    "btop.theme.j2":     str(Path.home() / ".config/btop/themes/current.theme"),
    "eza.yml.j2":        str(Path.home() / ".config/eza/theme.yml"),
    "foot.ini.j2":       str(Path.home() / ".config/foot/current-theme.ini"),
    "gitconfig.j2":      str(Path.home() / ".gitconfig.d/theme"),
    "hyprland.conf.j2":  str(Path.home() / ".config/hypr/theme.conf"),
    "i3bar.j2":          str(Path.home() / ".config/sway/confi.g/bar"),
    "i3blocks.conf.j2":  str(Path.home() / ".config/i3blocks/config"),
    "kitty.conf.j2":     str(Path.home() / ".config/kitty/colors.conf"),
    "lazygit.yml.j2":    str(Path.home() / ".config/lazygit/config.yml"),
    "mako.conf.j2":      str(Path.home() / ".config/mako/config"),
    "nvim.lua.j2":       str(Path.home() / ".config/nvim/lua/theme.lua"),
    "rofi.rasi.j2":      str(Path.home() / ".config/rofi/colors.rasi"),
    "starship.toml.j2":  str(Path.home() / ".config/starship.toml"),
    "sway-osd.css.j2":   str(Path.home() / ".config/swayosd/colors.css"),
    "sway-theme.j2":     str(Path.home() / ".config/sway/config.d/theme"),
    "swaync.css.j2":     str(Path.home() / ".config/swaync/style.css"),
    "tmux.conf.j2":      str(Path.home() / ".config/tmux/tmux-colors.conf"),
    "waybar.css.j2":     str(Path.home() / ".config/waybar/colors.css"),
    "yazi.toml.j2":      str(Path.home() / ".config/yazi/theme.toml"),
    # "dircolors.j2":    str(Path.home() / ".dircolors"),
    # "hypr.conf.j2":    str(Path.home() / ".config/hypr/theme.conf"),
    # "wofi.css.j2":     str(Path.home() / ".config/wofi/style.css"),
}
