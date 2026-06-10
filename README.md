<h1 align="center" style="display: flex; justify-content: center; align-items: center;">
<!-- <img src="https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/Zorro-OS.png" width="500px" style="center" /> -->
<br>
ArchLinux & Fedora Universal Installer for a Lightweight & Beautiful Setup
<br>
</h1>

![Banner](https://raw.githubusercontent.com/Rouzihiro/assets/main/4dotfiles/banner.png)

### 🖥️ Automatic Installation:
```bash
git clone https://github.com/Rouzihiro/dotfiles ~/dotfiles
bash ~/dotfiles/.github/dots_bootstrap.sh
bash ~/dotfiles/.github/assets.sh
```

### Theme Switcher Demo

https://github.com/user-attachments/assets/75b108d7-b7f5-4757-b0a9-b01c8b649eb5

# Blazing Fast Theme Switcher

A simple, efficient, and centralized theme management system for your dotfiles and applications.

---

[Jump to Theme Generator Guide](#theme-generator---how-to)

---
## Overview

With this setup, you define all your themes **once** inside your dotfiles. Then, using a small script, you can switch themes across all your applications **instantly**.

The magic? **Symlinks.** Instead of moving files or copying themes around, the script updates a single symlink pointing to the currently active theme folder. All your apps source their color schemes from that symlink, making theme switching:

- **Blazing fast**
- **Safe** (no file duplication or accidental overwrites)
- **Centralized** (one place to manage all themes)

---

## Features

- Centralized theme definitions in your dotfiles
- Instant theme switching across all apps
- Minimal disk operations (symlink only)
- Compatible with Nvim, Wofi, multiple Terminals, Tmux, Starship and other tools that read theme files

---

## Manual Installation

Run the installation script:

```bash
cd ~/dotfiles
./install-arch.sh or ./install-fedora.sh 
```

The installer will:
- Symlink `~/dotfiles/.local/bin` → `~/.local/bin`
- Set up configuration files and themes
- Prepare required scripts and utilities

---

## PATH Configuration

This setup uses a hierarchical `~/.local/bin` structure, including subdirectories.

To ensure all tools are available, add the following to your shell configuration (`.bashrc`, `.zshrc`, etc.):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

> Note: The directory is structured with multiple subfolders that need to be added to `$PATH`.

---

## Assets

Clone the required assets repository into your home directory:

```bash
git clone https://github.com/Rouzihiro/assets.git ~/assets
```

---

## Prerequisites

Make sure the following are installed before running the setup:

- Git
- Python 3.x
- A compatible shell (bash/zsh/fish)
- Required desktop environment / compositor dependencies (Sway/Wayland stack if used)

---

## Notes

- The installation script manages all symlinks automatically
- No manual copying of scripts is required
- Themes are expected in: `~/dotfiles/themes`
- Assets including wallpapers and icons are expected in: `~/assets`

```bash
# Example directory structure
~/.dotfiles/
├── install-themes.sh
├── themes/
│   ├── theme1/
│   ├── theme2/
│   └── ...
└── .local/bin/rofi/wofi-theme-switcher
```

## 🚀 Great performance for x86 and Apple Silicon M1
  
This setup with Sway WM idles at ~600MB RAM with our ultra-efficient stack:  

✓ **C/Rust-powered tools**

✓ **Asahi Linux**-tuned kernel

✓ **Battery-optimized** power profiles  

**Why it flies:**  
- Zero Electron apps  
- GPU-optimized compositing  
- Minimal background services  

## 🌟 Features

- **Cross-Platform Compatibility**: Works on:
  - All standard x86_64 PCs
  - Apple Silicon (M1/M2) via Asahi Linux
  - Microsoft Surface devices
  - Various consumer laptops (HP, Dell, Lenovo, etc.)
- **Modular Design**: Select only the packages you need
- **Proven Stability**: Successfully installed on:
  - MacBook Air M1 (8GB)
  - MacBook Pro (Intel)
  - Microsoft Surface Pro 2
  - Various friends/family devices
- **Included Fixes**: Hardware-specific solutions in `/fixes` directory

## 🛠️ Tested Configurations

| Device | Status | Notes |
|--------|--------|-------|
| MacBook Air M1 (8GB) | ✅ Fully Working | Includes Asahi fixes |
| Microsoft Surface Pro 2 | ✅ Fully Working | Touchscreen support |
| Generic Intel Laptops | ✅ Fully Working | Broad compatibility |

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

## Window Managers

### Sway Ecosystem
| Component | Description | Language |
|-----------|-------------|------------
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

## Notes & Bookmarks Setup

Create a dedicated directory for your markdown notes:

```bash
mkdir -p ~/Documents/Notes
```

Inside this directory, create your note files. These files are used by the Rofi bookmark/notes scripts and can be freely customized:

---

## Bookmark File Configuration

Define the files used by your Rofi bookmark script in your configuration:

```bash
BOOKMARK_FILES="
$HOME/Documents/Notes/gaming.md
$HOME/Documents/Notes/coding.md
$HOME/Documents/Notes/work.md
"
```

Each file acts as a category for quick access via the Rofi notes/bookmark system.


### System Components
| Component | Description | Language |
|-----------|-------------|-----------|
| [Tmux](https://github.com/tmux/tmux) | Terminal Multiplexer | ![C][c] |
| [Starship](https://github.com/starship/starship) | Cross-Shell Prompt | ![Rust][rust] |
| [Dunst](https://dunst-project.org/) | Notification Daemon | ![C][c] |
| [Rofi-Wayland](https://gitlab.com/dgirault/wofi) | Application Launcher | ![C][c] |
| [wlr-randr](https://sr.ht/~emersion/wlr-randr/) | Display Output Manager| ![C][c] |


### Applications
| Component | Description | Language |
|-----------|-------------|-----------|
| [Autotiling-rs](https://github.com/nwg-piotr/autotiling-rs) | Auto-Tiling Script for Sway/Hyprland | ![Rust][rust] |
| [Brave Browser](https://brave.com) | Web Browser | ![JavaScript][js] |
| [Btop](https://github.com/aristocratos/btop) | System Monitor | ![C++][cpp] |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System Information Tool | ![C][c] |
| [Foot](https://codeberg.org/dnkl/foot) | Terminal Emulator | ![C][c] |
| [Fuzzel](https://codeberg.org/dnkl/fuzzel) | Wayland Application Launcher | ![C][c] |
| [fzf-preview](https://github.com/yuki-yano/fzf-preview.vim) | Fuzzy Finder Preview Plugin | ![TypeScript][ts] |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI Client | ![Go][go] |
| [Neovim](https://neovim.io/) | Text Editor | ![C][c] |
| [nvim](https://github.com/neovim/neovim) | Neovim | ![C][c] |
| [Satty](https://github.com/gabm/satty) | Screenshot Annotation Tool | ![Rust][rust] |
| [Swappy](https://github.com/jtheoof/swappy) | Wayland Screenshot Editor | ![C][c] |
| [Thunar](https://docs.xfce.org/xfce/thunar/start) | File Manager | ![C][c] |
| [Yazi](https://github.com/sxyazi/yazi) | Terminal File Manager | ![Rust][rust] |
| [Broot](https://github.com/Canop/broot) | Terminal File Manager | ![Rust][rust] |
| [Vifm](https://vifm.info/) | Terminal File Manager | ![C][c] |
| [Zathura](https://github.com/pwmt/zathura) | PDF Reader | ![C][c] |


### Gaming
| Component | Description | Language |
|-----------|-------------|-----------|
| [Steam](https://store.steampowered.com/) | Game Distribution Platform | ![C++][cpp] |
| [AntimicroX](https://github.com/AntiMicroX/antimicrox) | Gamepad to Keyboard/Mouse Mapper | ![C++][cpp] |
---

# Theme Generator - How To

## Overview
This project generates consistent theme files across multiple applications based on a single Kitty terminal color palette configuration.

## Prerequisites
- Python 3.x installed
- `$HOME/dotfiles/themes` directory exists
- `$HOME/dotfiles/.local/bin` in your shell PATH

## Setup Instructions

### 1. Create Your Kitty Configuration
First, create a `kitty.conf` file in your themes directory with your desired color palette:
Create the file at `$HOME/dotfiles/themes/kitty.conf` with the following content:


### 2. Generate Theme Files
After creating your `kitty.conf` file, run the theme generator:

python ~/dotfiles/projects/theme-generator/main.py

This will parse your Kitty color palette and generate theme files for various applications (Vim, terminal, etc.) in the appropriate directories.

### 3. Generate Starship Configuration
Finally, run the Starship generator to create a consistent prompt configuration:

python ~/dotfiles/projects/theme-generator/starship_generator.py

This will create a Starship configuration file that matches your color palette.

### 4. Install and Apply Themes
Run the theme installer script to make the new theme available in your theme selector:

$HOME/dotfiles/install-themes.sh

### 5. Generate Palette Files
Finally, generate the palette files for your theme selector:

$HOME/dotfiles/.local/bin/zorro/z-theme-palettes-gen

## Notes
- The theme generator reads from `$HOME/dotfiles/themes/kitty.conf`
- Generated files will be placed in their respective application directories
- Run all scripts whenever you update your color palette to keep everything synchronized
- Ensure `$HOME/dotfiles/.local/bin` is in your shell PATH for the palette generator to work


<!-- Badge Definitions -->
[rust]: https://img.shields.io/badge/-Rust-DEA584?logo=rust&logoColor=black
[nim]: https://img.shields.io/badge/-nim-%23ffe953
[sh]: https://img.shields.io/badge/-shell-green
[go]: https://img.shields.io/badge/-go-68D7E2
[cpp]: https://img.shields.io/badge/-c%2B%2B-red
[c]: https://img.shields.io/badge/-c-lightgrey
[z]: https://img.shields.io/badge/-zig-yellow
[va]: https://img.shields.io/badge/-vala-blueviolet
[da]: https://img.shields.io/badge/-dart-02D3B3
[py]: https://img.shields.io/badge/-python-blue
[ts]: https://img.shields.io/badge/-TS-007BCD
[js]: https://img.shields.io/badge/-javascript-F7DF1E
[go]: https://img.shields.io/badge/-go-68D7E2
[nix]: https://img.shields.io/badge/-nix-7e7eff
