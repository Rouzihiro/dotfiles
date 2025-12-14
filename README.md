<h1 align="center" style="display: flex; justify-content: center; align-items: center;">
<img src="./assets/Zorro-OS.png" width="500px" style="center" />
<br>
ArchLinux & Fedora Universal Installer for a Lightweight & Beautiful Setup
<br>
</h1>

### 🖥️ Automatic Installation:
```bash
bash <(curl -sSL https://kutt.it/ReyDot)
```

![Theme Switcher Demo](./assets/theme-switcher.gif)


# Blazing Fast Theme Switcher

A simple, efficient, and centralized theme management system for your dotfiles and applications.

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

## Installation

Clone your dotfiles and make sure the scripts and themes are in place:

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

# Core System
- **Shell:** `zsh` & `bash`
- **Kernel:** Linux 6.14.8-asahi-1-1-ARCH

![Sway Home Screenshot](./assets/wall.png)
![Sway Home Screenshot 2](./assets/nvim.png)
![Sway Home Screenshot 3](./assets/nvim2.png)
![Sway Home Screenshot 4](./assets/tmux.png)
![Sway Home Screenshot 5](./assets/fetch.png)
![Sway Home Screenshot 6](./assets/utilities.png)
![Sway Home Screenshot 7](./assets/rofi.png)
![Sway Home Screenshot 8](./assets/thunar.png)

## Window Managers

### Sway Ecosystem
| Component | Description | Language |
|-----------|-------------|------------
| [Sway](https://github.com/swaywm/sway) | Window Manager | ![C][c] |
| [Swaybg](https://github.com/swaywm/swaybg) | Wallpaper manager | ![C][c] |
| [Swaylock](https://github.com/swaywm/swaylock) | Screen locker | ![C][c] |
| [Swayidle](https://github.com/swaywm/swayidle) | Idle management | ![C][c] |
| [i3blocks](https://github.com/vivien/i3blocks) | Status Bar for Sway/i3 | ![C][c] |

![Sway Home Screenshot 9](./assets/bar1.png)
![Sway Home Screenshot 10](./assets/bar2.png)

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
| [Bob](https://github.com/MordechaiHadad/bob) | Neovim Version Manager (Nightly Installer) | ![Rust][rust] |
| [Brave Browser](https://brave.com) | Web Browser | ![JavaScript][js] |
| [Btop](https://github.com/aristocratos/btop) | System Monitor | ![C++][cpp] |
| [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System Information Tool | ![C][c] |
| [Foot](https://codeberg.org/dnkl/foot) | Terminal Emulator | ![C][c] |
| [Fuzzel](https://codeberg.org/dnkl/fuzzel) | Wayland Application Launcher | ![C][c] |
| [fzf-preview](https://github.com/yuki-yano/fzf-preview.vim) | Fuzzy Finder Preview Plugin | ![TypeScript][ts] |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI Client | ![Go][go] |
| [Librewolf](https://librewolf.net/) | Privacy-Focused Firefox Fork | ![C++][cpp] |
| [Neovim](https://neovim.io/) | Text Editor | ![C][c] |
| [nvim-nightly](https://github.com/neovim/neovim) | Nightly Build of Neovim | ![C][c] |
| [Satty](https://github.com/gabm/satty) | Screenshot Annotation Tool | ![Rust][rust] |
| [Swappy](https://github.com/jtheoof/swappy) | Wayland Screenshot Editor | ![C][c] |
| [Thunar](https://docs.xfce.org/xfce/thunar/start) | File Manager | ![C][c] |
| [Vifm](https://vifm.info/) | Terminal File Manager | ![C][c] |
| [Zathura](https://github.com/pwmt/zathura) | PDF Reader | ![C][c] |


### Gaming
| Component | Description | Language |
|-----------|-------------|-----------|
| [Steam](https://store.steampowered.com/) | Game Distribution Platform | ![C++][cpp] |
| [AntimicroX](https://github.com/AntiMicroX/antimicrox) | Gamepad to Keyboard/Mouse Mapper | ![C++][cpp] |
---


### 🖥️ Manual Installation Experience

**For best visual experience install FZF:**
```bash
git clone https://github.com/Rouzihiro/dotfiles.git
cd dotfiles
chmod +x install-arch.sh
chmod +x install-fedora.sh
chmod +x install-themes.sh
./install-arch.sh
./install-fedora.sh
./install-themes.sh
```
### 🌈 Customization

    Edit package lists in /pkgs directory

    Add your fixes to /fixes (see existing examples)

    Select packages interactively during installation


### several Shell Enhanced Functions

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

# Base color palette
color0-15 

# Application-specific colors
background #YOUR_BACKGROUND
foreground #YOUR_FOREGROUND
selection_foreground #YOUR_SELECTION_FG
selection_background #YOUR_SELECTION_BG
cursor #YOUR_CURSOR
cursor_text_color #YOUR_CURSOR_TEXT
url_color #YOUR_URL_COLOR
active_tab_foreground #YOUR_ACTIVE_TAB_FG
active_tab_background #YOUR_ACTIVE_TAB_BG
inactive_tab_foreground #YOUR_INACTIVE_TAB_FG
inactive_tab_background #YOUR_INACTIVE_TAB_BG

Replace all the `#YOUR_...` placeholders with your actual hex color values.

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
