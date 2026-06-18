from __future__ import annotations

from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parents[1]
ROOT_DIR = SCRIPT_DIR.parent
FLAVORS_DIR = ROOT_DIR / "flavors"
BASE_DIR = FLAVORS_DIR / "base"
PALETTES_DIR = FLAVORS_DIR / "palettes"

OUTPUTS = {
    "mako.conf.j2": ".config/mako/config",
    "starship.toml.j2": ".config/starship.toml",
    # "dircolors.j2": ".dircolors",
    # "hypr.conf.j2": ".config/hypr/theme.conf",
    "hyprland.conf.j2": ".config/hypr/theme.conf",
    # "tmux.conf.j2": ".tmux.conf",
    "tmux-rey.conf.j2": ".config/tmux/tmux-colors.conf",
    # "wofi.css.j2": ".config/wofi/style.css",
    "nvim.lua.j2": ".config/nvim/lua/theme.lua",
    "rofi.rasi.j2": ".config/rofi/colors.rasi",
    "yazi.toml.j2": ".config/yazi/theme.toml",
    "waybar.css.j2": ".config/waybar/colors.css", 
    "sway-theme.j2": ".config/sway/confi.g/theme",
    "i3bar.j2": ".config/sway/confi.g/bar",
    "i3blocks.conf.j2": ".config/i3blocks/config",
    "sway-osd.css.j2": ".config/swayosd/colors.css",
    "swaync.css.j2": ".config/swaync/style.css",
    "lazygit.yml.j2": ".config/lazygit/config.yml",
    "eza.yml.j2": ".config/eza/theme.yml",
    "broot.toml.j2": ".config/broot/skins/current.toml",
    "btop.theme.j2": ".config/btop/themes/current.theme",
    "alacritty.toml.j2": ".config/alacritty/theme.toml",
    "gitconfig.j2": ".gitconfig.d/theme",
}
