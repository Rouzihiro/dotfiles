<h1 align="center">
<br>
ArchLinux & Fedora Universal Installer for a Lightweight & Beautiful Setup
<br>
</h1>

### 🖥️ Automatic Installation:
```bash
git clone https://github.com/Rouzihiro/dotfiles ~/dotfiles
bash bootstrap.sh
bash ~/dotfiles/install/assets.sh
```

### Theme Switcher Demo

[![Theme Switcher Demo](https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/banner.png)](https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/theme.mp4)

---

## 🚀 Great performance for x86 and Apple Silicon M1

This setup with Sway WM idles at ~600MB RAM with our ultra-efficient stack:

✓ **C/Rust-powered tools** &nbsp; ✓ **Asahi Linux**-tuned kernel &nbsp; ✓ **Battery-optimized** power profiles

**Why it flies:** Zero Electron apps · GPU-optimized compositing · Minimal background services

---

## 🌟 Features

- **Cross-Platform**: x86_64 PCs, Apple Silicon (M1/M2) via Asahi Linux, Surface devices, consumer laptops
- **40+ themes** — instantly switchable, live across all apps
- **Modular Design** — select only the packages you need
- **Proven Stability** — MacBook Air M1, Surface Pro 2, various Intel laptops

---

# Flavors — Theme System

A centralized, Python-driven theming pipeline. One palette file per theme. One command to apply it everywhere, live, with no symlinking.

---

## How It Works

Each theme is defined by a single `palettes/<theme>.toml` file. When you switch themes, a Python generator compiles that palette into config files for every supported application using Jinja2 templates. A set of zsh scripts then reloads each running app in parallel — no restarts, no file copying, no symlinks.

```
palettes/sakura.toml  →  generate.py  →  app configs  →  apply.zsh  →  live reload
```

The flow in `apply.zsh`:

1. `generate.py <theme>` — renders all `.j2` templates against the palette
2. State is written to `$_OSYX_STATE_FILE` so the current theme survives reboots
3. Thyx preset is copied if one exists for the theme
4. All app reloads fire in parallel (`&!`) — kitty, hyprland/sway, mako, tmux, nvim, btop, wallpaper

---

## Directory Structure

```
flavors/
├── palettes/            # One <theme>.toml per theme — source of truth
├── templates/           # Jinja2 .j2 templates, one per application
├── generator/           # Python package (cli, colors, palette, render)
├── generate.py          # Entry point: python3 generate.py <theme>
├── generate-all.sh      # Compile every palette at once
├── backgrounds/         # Per-theme wallpaper symlinks → ~/assets/wallpapers/
├── theme/               # zsh scripts: apply, select, reload, config, pickers
├── themes.zsh           # Main entry point sourced by your shell
└── thyx-map.conf        # Theme → thyx preset mapping
```

---

## Palette Format

```toml
[palette]
bg        = "#3e2723"
bg_subtle = "#543f3b"
bg_muted  = "#6b5854"
fg        = "#d7ccc8"
fg_dim    = "#998a86"
accent    = "#bcaaa4"
cursor    = "#bcaaa4"
error     = "#bcaaa4"
warning   = "#d7ccc8"
success   = "#d7ccc8"
sel_bg    = "#d7ccc8"
sel_fg    = "#3e2723"
color0  = "#3e2723"
color1  = "#bcaaa4"
# color2–color15 ...
```

---

## Template Syntax

Templates live in `templates/` as `<app>.j2`. Use `{{key}}` placeholders — the generator resolves them into the correct color format per application:

| Syntax | Output | Use case |
|---|---|---|
| `{{key}}` | `#rrggbb` | Default — most apps |
| `{{key:hex}}` | `#rrggbb` | Explicit hex |
| `{{key:raw}}` | `rrggbb` | Foot, Hyprland |
| `{{key:rgb}}` | `rgb(r g b)` | CSS (space-separated) |
| `{{key:rgb_spaced}}` | `r g b` | Inline RGB values |
| `{{key:rgb_css}}` | `r, g, b` | GTK / Waybar `rgba()` |

Example:
```css
@define-color background rgba({{bg:rgb_css}}, 0.25);
```

---

## Supported Applications

Templates are provided for:

- **Terminals** — Kitty, Foot
- **Compositor** — Hyprland, Sway (borders + bar)
- **Bar** — Waybar (CSS + color aliases), i3blocks
- **Notifications** — Mako, SwayNC
- **Shell** — Starship prompt
- **File managers** — Yazi, Broot
- **Tools** — Btop, Lazygit, Eza, Rofi, SwayOSD
- **Multiplexer** — Tmux
- **Editor** — Neovim

---

## Adding a New Theme

1. Create `palettes/mytheme.toml` with your color palette
2. Optionally add a wallpaper symlink in `backgrounds/mytheme.jpg`
3. Run the generator:
   ```bash
   python3 generate.py mytheme
   ```
4. Switch to it:
   ```bash
   # via the interactive picker
   themes.zsh
   # or
   bind = $mod, T, exec, uwsm app -- zsh -ic 'source ~/dotfiles/flavors/themes.zsh; _osyx_rofi_theme_picker'
   bindsym $mod+t exec zsh -ic 'source ~/dotfiles/flavors/themes.zsh; _osyx_rofi_theme_picker'
   ```

To regenerate all themes at once:
```bash
bash generate-all.sh
```

---

## Live Reload

When a theme is applied, the following happen in parallel:

| App | Reload method |
|-----|--------------|
| Kitty | `SIGUSR1` to all kitty pids |
| Hyprland | `hyprctl reload` |
| Sway | `swaymsg reload` |
| Mako | `makoctl reload` |
| Tmux | `tmux source-file ~/.tmux.conf` |
| Neovim | `OsyxFlip` via `--remote-send` over socket |
| Btop | `SIGUSR1` |
| Wallpaper | `wallpaper set` / `waypaper` |

---

## Manual Installation

```bash
cd ~/dotfiles/install/install.sh
```

The installer symlinks `~/dotfiles/.local/bin` → `~/.local/bin` and sets up all config files.

Add to your shell config:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Clone the assets repository:
```bash
git clone https://github.com/Rouzihiro/assets.git ~/assets
```

---

## Prerequisites

- Git, Python 3.x, a compatible shell (bash/zsh)
- Wayland compositor (Sway or Hyprland)
- Relevant desktop stack dependencies per your distro

---

## 🛠️ Tested Configurations

| Device | Status | Notes |
|--------|--------|-------|
| MacBook Air M1 (8GB) | ✅ Fully Working | Includes Asahi fixes |
| Microsoft Surface Pro 2 | ✅ Fully Working | Touchscreen support |
| Generic Intel Laptops | ✅ Fully Working | Broad compatibility |

---

## Themes

<table>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/catppuccin.png" width="400"/><br><b>Catppuccin</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/dune.png" width="400"/><br><b>Dune</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/etheral.png" width="400"/><br><b>Etheral</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/everforest.png" width="400"/><br><b>Everforest</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/flexoki-dark.png" width="400"/><br><b>Flexoki Dark</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/gruvbox.png" width="400"/><br><b>Gruvbox</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/gruvbox-material.png" width="400"/><br><b>Gruvbox Material</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/hackerman.png" width="400"/><br><b>Hackerman</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/kanagawa-dragon.png" width="400"/><br><b>Kanagawa Dragon</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/last-horizon.png" width="400"/><br><b>Last Horizon</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/lumon.png" width="400"/><br><b>Lumon</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/matte-black.png" width="400"/><br><b>Matte Black</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/miasma.png" width="400"/><br><b>Miasma</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/nightfox.png" width="400"/><br><b>Nightfox</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/nord.png" width="400"/><br><b>Nord</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/osaka.png" width="400"/><br><b>Osaka</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/retro-82.png" width="400"/><br><b>Retro 82</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/ristretto.png" width="400"/><br><b>Ristretto</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/rosepine.png" width="400"/><br><b>Rosé Pine</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/rosepine-darker.png" width="400"/><br><b>Rosé Pine Darker</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/sakura.png" width="400"/><br><b>Sakura</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/solarized-dark.png" width="400"/><br><b>Solarized Dark</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/solitude.png" width="400"/><br><b>Solitude</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/tokyonight.png" width="400"/><br><b>Tokyo Night</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/vague.png" width="400"/><br><b>Vague</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/vantablack.png" width="400"/><br><b>Vantablack</b></td>
</tr>
<tr>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/versailles.png" width="400"/><br><b>Versailles</b></td>
<td align="center"><img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/gojira.png" width="400"/><br><b>Gojira</b></td>
</tr>
</table>

---

## Window Managers

### Sway Ecosystem
| Component | Description | Language |
|-----------|-------------|----------|
| [Sway](https://github.com/swaywm/sway) | Window Manager | ![C][c] |
| [Swaybg](https://github.com/swaywm/swaybg) | Wallpaper manager | ![C][c] |
| [Swaylock](https://github.com/swaywm/swaylock) | Screen locker | ![C][c] |
| [Swayidle](https://github.com/swaywm/swayidle) | Idle management | ![C][c] |
| [Waybar](https://github.com/Alexays/Waybar) | Status Bar | ![C++][cpp] |
| [i3blocks](https://github.com/vivien/i3blocks) | Status Bar for Sway/i3 | ![C][c] |

### Keybindings

<details>
<summary><b>Applications</b></summary>

| Key | Action |
|------|---------|
| `Super + Return` | Foot Terminal |
| `Super + Alt + Return` | Floating Kitty Terminal |
| `Super + Shift + Return` | Kitty Terminal |
| `Super + E` | Custom TUI File Manager |
| `Super + Alt + E` | Yazi |
| `Super + Shift + E` | Thunar |
| `Super + N` | FZF Notes |
| `Super + Alt + N` | Neovim |
| `Super + Shift + N` | Notes Dashboard |
| `Super + A` | Btop |
| `Super + Alt + A` | NCDU |
| `Super + R` | TUI Runner |
| `Super + O` | OCR Tool |
| `Super + Alt + O` | Text Picker |
| `Super + M` | USB Mount Menu |
| `Super + Shift + M` | Memory Usage (ps_mem) |

</details>

<details>
<summary><b>Launchers & Menus</b></summary>

| Key | Action |
|------|---------|
| `Super + Space` | App Launcher |
| `Super + Ctrl + Space` | Script Launcher |
| `Super + Alt + Space` | Quick Actions |
| `Super + B` | Bookmarks |
| `Super + Alt + B` | Open Browser |
| `Super + Shift + B` | Bluetooth Menu |
| `Super + I` | Wi-Fi Menu (TUI) |
| `Super + Alt + I` | Wi-Fi Menu (Rofi) |
| `Super + D` | Download Manager |
| `Super + Alt + D` | Documents |
| `Super + Shift + D` | Music Downloader |
| `Super + T` | Theme Selector |
| `Super + Alt + T` | Timewarrior |
| `Super + V` | Video Browser |
| `Super + Alt + V` | Video Tools |
| `Super + W` | Wallpaper Selector |
| `Super + Alt + W` | Random Wallpaper |
| `Super + Z` | Keybinding Cheatsheet |
| `Super + \`` | Window List |

</details>

<details>
<summary><b>Window Management</b></summary>

| Key | Action |
|------|---------|
| `Super + H/J/K/L` | Focus Window |
| `Super + Shift + H/J/K/L` | Move Window |
| `Super + Ctrl + H/J/K/L` | Resize Window |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Toggle Floating |
| `Super + Q` | Close Window |
| `Super + P` | Show Scratchpad |
| `Super + Shift + P` | Move Window to Scratchpad |
| `3-Finger Swipe Left/Right` | Previous / Next Workspace |
| `3-Finger Swipe Up` | Toggle Floating |
| `4-Finger Swipe` | Move Active Window |

</details>

<details>
<summary><b>System</b></summary>

| Key | Action |
|------|---------|
| `Super + Alt + L` | Lock Screen |
| `Super + Escape` | Power Menu |
| `Super + Ctrl + Q` | Exit Sway |
| `Super + Shift + R` | Reload Configuration |
| `Super + Alt + M` | Monitor Switcher |
| `Super + Alt + P` | Power Profile |
| `Super + Alt + W` | Random Wallpaper |
| `Super + W` | Wallpaper Selector |
| `Super + Shift + I` | VM Mode |

</details>

<details>
<summary><b>Screenshots & Recording</b></summary>

| Key | Action |
|------|---------|
| `Super + S` | Screenshot Menu |
| `Super + Alt + S` | Fullscreen Screenshot |
| `Super + Alt + R` | Screen Recording |

</details>

<details>
<summary><b>Media & Brightness</b></summary>

| Key | Action |
|------|---------|
| `XF86AudioRaiseVolume` | Volume Up |
| `XF86AudioLowerVolume` | Volume Down |
| `XF86AudioMute` | Toggle Mute |
| `XF86AudioPlay` | Play / Pause |
| `XF86AudioPrev` | Previous Track |
| `XF86AudioNext` | Next Track |
| `XF86MonBrightnessUp` | Brightness Up |
| `XF86MonBrightnessDown` | Brightness Down |

</details>

See `.config/sway/config.d/keybindings.conf` for the complete configuration.

---

### System Components
| Component | Description | Language |
|-----------|-------------|-----------|
| [Tmux](https://github.com/tmux/tmux) | Terminal Multiplexer | ![C][c] |
| [Starship](https://github.com/starship/starship) | Cross-Shell Prompt | ![Rust][rust] |
| [Dunst](https://dunst-project.org/) | Notification Daemon | ![C][c] |
| [Rofi-Wayland](https://gitlab.com/dgirault/wofi) | Application Launcher | ![C][c] |
| [wlr-randr](https://sr.ht/~emersion/wlr-randr/) | Display Output Manager | ![C][c] |

### Applications
| Component | Description | Language |
|-----------|-------------|-----------|
| [Autotiling-rs](https://github.com/nwg-piotr/autotiling-rs) | Auto-Tiling Script for Sway/Hyprland | ![Rust][rust] |
| [Brave Browser](https://brave.com) | Web Browser | ![JavaScript][js] |
| [Btop](https://github.com/aristocratos/btop) | System Monitor | ![C++][cpp] |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System Information Tool | ![C][c] |
| [Foot](https://codeberg.org/dnkl/foot) | Terminal Emulator | ![C][c] |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI Client | ![Go][go] |
| [Neovim](https://neovim.io/) | Text Editor | ![C][c] |
| [Satty](https://github.com/gabm/satty) | Screenshot Annotation Tool | ![Rust][rust] |
| [Swappy](https://github.com/jtheoof/swappy) | Wayland Screenshot Editor | ![C][c] |
| [Thunar](https://docs.xfce.org/xfce/thunar/start) | File Manager | ![C][c] |
| [Broot](https://github.com/Canop/broot) | Terminal File Manager | ![Rust][rust] |
| [Zathura](https://github.com/pwmt/zathura) | PDF Reader | ![C][c] |

### Gaming
| Component | Description | Language |
|-----------|-------------|-----------|
| [Steam](https://store.steampowered.com/) | Game Distribution Platform | ![C++][cpp] |
| [AntimicroX](https://github.com/AntiMicroX/antimicrox) | Gamepad to Keyboard/Mouse Mapper | ![C++][cpp] |

---

## Notes & Bookmarks Setup

```bash
mkdir -p ~/Documents/Notes
```

Define files used by the bookmark script:

```bash
BOOKMARK_FILES="
$HOME/Documents/Notes/gaming.md
$HOME/Documents/Notes/coding.md
$HOME/Documents/Notes/work.md
"
```

---

<!-- Badge Definitions -->
[rust]: https://img.shields.io/badge/-Rust-DEA584?logo=rust&logoColor=black
[go]: https://img.shields.io/badge/-go-68D7E2
[cpp]: https://img.shields.io/badge/-c%2B%2B-red
[c]: https://img.shields.io/badge/-c-lightgrey
[py]: https://img.shields.io/badge/-python-blue
[ts]: https://img.shields.io/badge/-TS-007BCD
[js]: https://img.shields.io/badge/-javascript-F7DF1E
