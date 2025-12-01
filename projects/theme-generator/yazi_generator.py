#!/usr/bin/env python3
import re
import os
import sys
from pathlib import Path
import shutil

# Hardcoded paths
HOME = Path.home()
TEMPLATE_FILE = HOME / "dotfiles" / "projects" / "templates" / "yazi-template.toml"
THEMES_DIR = HOME / "dotfiles" / "themes"

def parse_colors_file(filepath):
    """Parse tmux colors file and extract only the specific color definitions we need"""
    colors = {}
    
    # These are the specific color variables we want to extract
    target_colors = {
        'base', 'text', 'crust', 'sig1', 'sig2', 'on_sig1', 
        'on_sig2', 'on_sigbg', 'sig_bg', 'sig_surface_high', 'red'
    }
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Look for color definitions in various formats
    for color_name in target_colors:
        # Try different patterns
        patterns = [
            rf'{color_name}\s*=\s*"([^"]+)"',              # name="#RRGGBB"
            rf'set.*@?{color_name}\s+"([^"]+)"',          # set @name "#RRGGBB"
            rf'\${color_name}\s*=\s*"([^"]+)"',           # $name="#RRGGBB"
            rf'{color_name}\s*:\s*"([^"]+)"',             # name: "#RRGGBB"
            rf'{color_name}\s*=\s*([^#\s]+#\w+)',         # name=#RRGGBB (without quotes)
            rf'{color_name}\s*=\s*([^#\s]+#\w+)\s*;',     # name=#RRGGBB; (CSS style)
            rf'{color_name}\s*=\s*([^#\s]+#\w+)\s*$',     # name=#RRGGBB at end of line
        ]
        
        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                color_value = match.group(1).strip().strip('"').strip("'")
                # Ensure it starts with #
                if not color_value.startswith('#'):
                    color_value = '#' + color_value
                colors[color_name] = color_value
                break
    
    return colors

def merge_template(template_content, colors):
    """Merge color definitions into template content"""
    # Replace all placeholders with actual colors
    for name, color in colors.items():
        placeholder = f"{{{{{name}}}}}"
        template_content = template_content.replace(placeholder, color)
    
    return template_content

def generate_yazi_theme(theme_folder, template_content):
    """Generate a Yazi theme file for a specific theme folder"""
    colors_file = theme_folder / "tmux-colors.conf"
    
    if not colors_file.exists():
        print(f"  ⚠ No tmux-colors.conf found in {theme_folder.name}")
        return False
    
    # Parse colors
    colors = parse_colors_file(colors_file)
    
    # Check if we have all required colors
    required_colors = ['base', 'text', 'crust', 'sig1', 'sig2', 'on_sig1', 
                      'on_sig2', 'on_sigbg', 'sig_bg', 'sig_surface_high', 'red']
    
    missing = [c for c in required_colors if c not in colors]
    if missing:
        print(f"  ⚠ Missing colors in {theme_folder.name}: {missing}")
        # Fill missing with defaults
        for color in missing:
            colors[color] = "#000000"
    
    # Show extracted colors
    found_colors = list(colors.keys())
    print(f"  ✓ Found {len(found_colors)}/{len(required_colors)} colors: {', '.join(found_colors)}")
    
    # Merge template
    merged_content = merge_template(template_content, colors)
    
    # Write output as yazi.toml
    output_file = theme_folder / "yazi.toml"
    with open(output_file, 'w') as f:
        f.write(merged_content)
    
    return True

def backup_existing_yazi_theme(theme_folder):
    """Backup existing yazi.toml if it exists"""
    yazi_file = theme_folder / "yazi.toml"
    
    if yazi_file.exists():
        backup_path = theme_folder / "yazi.toml.backup"
        shutil.copy2(yazi_file, backup_path)
        return True
    return False

def main():
    # Check if directories exist
    if not TEMPLATE_FILE.exists():
        print(f"Error: Template file not found: {TEMPLATE_FILE}")
        sys.exit(1)
    
    if not THEMES_DIR.exists():
        print(f"Error: Themes directory not found: {THEMES_DIR}")
        sys.exit(1)
    
    print(f"Using template: {TEMPLATE_FILE}")
    print(f"Themes directory: {THEMES_DIR}")
    print("")
    
    # Read template content
    try:
        with open(TEMPLATE_FILE, 'r') as f:
            template_content = f.read()
    except Exception as e:
        print(f"Error reading template file: {e}")
        sys.exit(1)
    
    # Find all theme folders
    theme_folders = []
    for item in THEMES_DIR.iterdir():
        if item.is_dir():
            # Check if it's likely a theme folder by looking for tmux-colors.conf
            if (item / "tmux-colors.conf").exists():
                theme_folders.append(item)
    
    if not theme_folders:
        print(f"No theme folders with tmux-colors.conf found in {THEMES_DIR}")
        sys.exit(1)
    
    print(f"Found {len(theme_folders)} theme folders:")
    for folder in theme_folders:
        print(f"  - {folder.name}")
    
    print("\n" + "="*60)
    print("Generating yazi.toml files...")
    print("(Existing yazi.toml files will be backed up as yazi.toml.backup)")
    print("="*60 + "\n")
    
    successful = 0
    for theme_folder in theme_folders:
        print(f"🎨 Processing: {theme_folder.name}")
        
        # Backup existing yazi.toml if it exists
        if backup_existing_yazi_theme(theme_folder):
            print(f"  📦 Backed up existing yazi.toml")
        
        # Generate new yazi.toml
        if generate_yazi_theme(theme_folder, template_content):
            successful += 1
            print(f"  ✅ Generated yazi.toml")
        else:
            print(f"  ❌ Failed to generate yazi.toml")
        
        print("")  # Empty line between themes
    
    print("="*60)
    print(f"SUMMARY")
    print("="*60)
    print(f"✅ Successfully generated: {successful}/{len(theme_folders)} theme folders")
    print(f"📁 Total themes found: {len(theme_folders)}")
    
    if successful > 0:
        print("\nGenerated yazi.toml files:")
        for theme_folder in theme_folders:
            yazi_file = theme_folder / "yazi.toml"
            if yazi_file.exists():
                # Check if backup was created
                backup_file = theme_folder / "yazi.toml.backup"
                backup_status = " (with backup)" if backup_file.exists() else ""
                print(f"  📄 {theme_folder.name}/yazi.toml{backup_status}")

if __name__ == "__main__":
    main()
