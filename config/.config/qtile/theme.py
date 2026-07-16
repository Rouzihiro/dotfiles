"""
theme.py — ALL color/theme values live here and nowhere else.

This is the file your osyx Jinja2 pipeline should regenerate and drop in,
same role as theme.lua for Neovim. Every other module (config.py, rules.py,
autostart.py) imports from here instead of hardcoding hex values, so a theme
switch only ever touches this one file + a `qtile cmd-obj -o cmd -f restart`.

Palette keys below match a typical base16-style TOML (bg/fg + 8 ANSI colors
+ 8 bright variants) — map these directly from whatever your palette TOML
already uses for kitty/starship. Qtile wants "hex" format (e.g. "#1e1e2e"),
same as the `hex` variant in your existing Jinja2 template.
"""

# --- Core palette (fill from your active palette TOML) ---
bg = "#1e1e2e"
fg = "#cdd6f4"

black = "#45475a"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#cba6f7"
cyan = "#94e2d5"
white = "#bac2de"

bright_black = "#585b70"
bright_red = "#f38ba8"
bright_green = "#a6e3a1"
bright_yellow = "#f9e2af"
bright_blue = "#89b4fa"
bright_magenta = "#cba6f7"
bright_cyan = "#94e2d5"
bright_white = "#a6adc8"

# --- Semantic aliases used by the rest of the config ---
# (keeps config.py/rules.py reading intent, not raw palette slots)
border_focus = blue
border_normal = black
border_width = 2

# Floating-window border (scratchpad, floaty-* windows, runner_floating)
float_border_focus = magenta
float_border_normal = black
float_border_width = 2

opacity = 0.9

# --- Wallpaper (moved here from settings.py — it's theme data, not a static app path) ---
wallpaper = "~/Pictures/wallpapers/sakura/forest.jpg"

# --- Bar / widget colors ---
bar_bg = bg
bar_fg = fg
bar_active = blue        # active group / focused indicator
bar_inactive = bright_black
bar_urgent = red
bar_highlight = magenta   # current layout icon, prompt, etc.

font = "JetBrainsMono Nerd Font"
font_size = 13
bar_size = 28
