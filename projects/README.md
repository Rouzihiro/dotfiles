# Theme Generator System - Complete Modular Implementation

## 🎯 Overview
Created a comprehensive, modular theme generator system that automatically converts Kitty terminal themes into configuration files for various applications. The system is now fully extensible and can generate themes for 13+ different applications.

## ✨ New Features

### 🔧 Core Architecture
- **Modular Generator System**: Automatic discovery of generators - no manual imports needed
- **Base Generator Class**: Abstract base class with backup functionality and consistent interface
- **Kitty Parser**: Robust color parsing from Kitty config files

### 🎨 Supported Applications (13 Generators)
1. **waybar** - Status bar CSS configuration
2. **rofi** - Application launcher theme
3. **hyprland** - Window manager colors
4. **mako** - Notification daemon configuration
5. **foot** - Terminal emulator colors
6. **btop** - Resource monitor theme
7. **dircolors** - LS_COLORS with RGB support
8. **eza** - Modern file listing colors
9. **lazygit** - Git TUI theme
10. **sway** - Window manager color variables
11. **tmux** - Terminal multiplexer theme
12. **yazi** - Modern file manager TOML config
13. **alacritty** - Terminal emulator colors

### 🚀 Key Improvements
- **Auto-discovery**: Generators are automatically detected - just add files to `generators/` folder
- **Smart Naming**: Classes named `AppGenerator` become `app` commands
- **Backup System**: Automatic timestamped backups of existing files
- **Error Handling**: Graceful failure with helpful error messages
- **Help System**: `--list` and `--help` commands for easy discovery

## 🎮 Usage
```bash
# Generate all theme files
python main.py

# Generate specific application
python main.py waybar
python main.py alacritty

# List available generators
python main.py --list

# Show help
python main.py --help
```


🔄 Workflow
Place kitty.conf in current directory

Run python main.py to generate all theme files

Existing files are automatically backed up with timestamps

New generators can be added by simply creating new files in generators/

🎨 Theme Consistency
All generated themes maintain perfect color consistency with the original Kanagawa Dragon palette, ensuring a cohesive visual experience across the entire desktop environment.

This system eliminates manual theme synchronization and provides a single source of truth for your color scheme across all applications.
