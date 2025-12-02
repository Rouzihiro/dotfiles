#!/usr/bin/env python3

import os
import re
import shutil
import subprocess
from pathlib import Path

def format_palette_name(theme_name):
    """
    Convert theme folder name to palette name.
    Simple rule: replace - with _, capitalize first letter of each word.
    Example: 'catppuccin-latte' -> 'Catppuccin_Latte'
    """
    # Replace hyphens with underscores
    name_with_underscores = theme_name.replace('-', '_')
    
    # Split by underscores
    parts = name_with_underscores.split('_')
    
    # Capitalize each part
    capitalized_parts = [part.capitalize() for part in parts]
    
    # Join back with underscores
    return '_'.join(capitalized_parts)

def get_current_theme():
    """Get current theme name and format it for starship."""
    try:
        # Get the current theme path
        theme_path = Path.home() / ".config" / "zorro" / "current" / "theme"
        
        if not theme_path.exists():
            print("❌ Current theme symlink not found")
            return None
        
        # Get the real path and extract theme name
        real_path = theme_path.resolve()
        theme_name = real_path.name
        
        # Format the theme name (same logic as bash script)
        # Convert kebab-case to Title_Case
        formatted = theme_name.replace('-', ' ').title().replace(' ', '_')
        
        print(f"   Current theme: {theme_name} → {formatted}")
        return formatted
        
    except Exception as e:
        print(f"❌ Error getting current theme: {e}")
        return None

def update_starship_palette(theme_name):
    """Update starship template with current palette."""
    try:
        starship_config = Path.home() / "dotfiles" / "projects" / "templates" / "starship-template.toml"
        
        if not starship_config.exists():
            print(f"❌ Starship config not found: {starship_config}")
            return False
        
        # Read the entire file
        with open(starship_config, 'r') as f:
            lines = f.readlines()
        
        # Check if we have at least 2 lines
        if len(lines) < 2:
            print("❌ Starship config is too short")
            return False
        
        # Get current palette from line 2 (0-indexed line 1)
        current_palette = None
        if 'palette =' in lines[1]:
            # Extract current palette value
            match = re.search(r"palette = '([^']*)'", lines[1])
            if match:
                current_palette = match.group(1)
        
        # Only update if theme changed
        if current_palette == theme_name:
            print(f"   Starship palette already set to: {theme_name}")
            return True
        
        # Update line 2 with new palette
        lines[1] = f"palette = '{theme_name}'\n"
        
        # Write back to file
        with open(starship_config, 'w') as f:
            f.writelines(lines)
        
        print(f"   Starship palette updated to: {theme_name}")
        return True
        
    except Exception as e:
        print(f"❌ Error updating starship palette: {e}")
        return False

def backup_starship_config(starship_path):
    """Backup existing starship.toml if it exists."""
    if starship_path.exists():
        backup_path = starship_path.parent / f"starship.toml.backup"
        shutil.copy2(starship_path, backup_path)
        print(f"📦 Backed up existing starship.toml to {backup_path}")
        return True
    return False

def copy_template(template_path, destination_path):
    """Copy template starship.toml to config directory."""
    try:
        shutil.copy2(template_path, destination_path)
        print(f"📄 Copied template to {destination_path}")
        return True
    except Exception as e:
        print(f"❌ Error copying template: {e}")
        return False

def extract_colors(tmux_colors_path):
    """Extract color definitions from tmux-colors.conf."""
    try:
        with open(tmux_colors_path, 'r') as f:
            content = f.read()
        
        # Pattern to match color definitions (handles various formats)
        color_pattern = r'(\w+)\s*[=:]\s*"?#([0-9a-fA-F]{6})"?'
        colors = dict(re.findall(color_pattern, content))
        
        # Colors we want to extract
        target_colors = {
            'base', 'text', 'crust', 'sig1', 'sig2', 
            'on_sig1', 'on_sig2', 'on_sigbg', 'sig_bg', 
            'sig_surface_high', 'red'
        }
        
        # Extract only the colors we want
        extracted = {}
        for color in target_colors:
            if color in colors:
                extracted[color] = f"#{colors[color]}"
        
        return extracted
    except Exception as e:
        print(f"  ❌ Error reading {tmux_colors_path}: {e}")
        return {}

def find_all_themes(themes_dir):
    """Find all theme folders with tmux-colors.conf."""
    themes = []
    themes_dir = Path(themes_dir)
    
    if not themes_dir.exists():
        print(f"❌ Themes directory not found: {themes_dir}")
        return themes
    
    # Look for tmux-colors.conf in all subdirectories
    for root, dirs, files in os.walk(themes_dir):
        root_path = Path(root)
        if 'tmux-colors.conf' in files:
            # Get the theme folder name (the immediate parent directory)
            theme_name = root_path.name
            tmux_path = root_path / 'tmux-colors.conf'
            themes.append((theme_name, tmux_path))
    
    return themes

def main():
    # Setup paths
    home = Path.home()
    dotfiles = home / "dotfiles"
    themes_dir = dotfiles / "themes"
    template = dotfiles / "projects" / "templates" / "starship-template.toml"
    starship_config = home / ".config" / "starship.toml"
    
    print("🎨 Starship Palette Generator")
    print("=" * 40)
    
    # Step 0: Get current theme and update template
    print("\n0. Getting current theme...")
    current_theme = get_current_theme()
    
    if current_theme:
        if update_starship_palette(current_theme):
            print("✅ Template updated with current palette")
        else:
            print("⚠️  Could not update template, continuing anyway...")
    
    print("=" * 40)
    
    # Ensure config directory exists
    starship_config.parent.mkdir(exist_ok=True)
    
    # Step 1: Backup existing config
    print("\n1. Checking for existing config...")
    backed_up = backup_starship_config(starship_config)
    
    # Step 2: Copy template
    print("\n2. Setting up new config...")
    if not template.exists():
        print(f"❌ Template not found: {template}")
        return
    
    if not copy_template(template, starship_config):
        return
    
    # Step 3: Find all themes
    print("\n3. Discovering themes...")
    themes = find_all_themes(themes_dir)
    
    if not themes:
        print("❌ No themes found with tmux-colors.conf!")
        return
    
    print(f"   Found {len(themes)} theme(s)")
    
    # Step 4: Process each theme
    print("\n4. Extracting colors...")
    success_count = 0
    
    for theme_name, tmux_path in sorted(themes, key=lambda x: x[0]):
        palette_name = format_palette_name(theme_name)
        print(f"   • {theme_name:20} → {palette_name}")
        
        colors = extract_colors(tmux_path)
        
        if colors:
            # Append palette to starship.toml
            with open(starship_config, 'a') as f:
                f.write(f"\n\n[palettes.{palette_name}]\n")
                for color_name in sorted(colors.keys()):
                    f.write(f'{color_name} = "{colors[color_name]}"\n')
            
            success_count += 1
            print(f"     ✅ Added {len(colors)} colors")
        else:
            print(f"     ⚠️  No colors found")
    
    # Step 5: Summary
    print("\n" + "=" * 40)
    print("✨ Summary")
    print(f"   • Current theme: {current_theme or 'Not found'}")
    print(f"   • Total themes found: {len(themes)}")
    print(f"   • Palettes created: {success_count}")
    print(f"   • Config file: {starship_config}")
    
    if backed_up:
        print(f"   • Backup saved: starship.toml.backup")
    
    # Show example usage
    if success_count > 0:
        print("\n💡 Quick Start:")
        print("   Palette in use (from template):")
        print(f"   palette = \"{current_theme or 'YourTheme'}\"")
        print("\n   Available palettes:")
        for theme_name, _ in sorted(themes, key=lambda x: x[0]):
            palette_name = format_palette_name(theme_name)
            print(f"   • {palette_name}")

if __name__ == "__main__":
    main()
