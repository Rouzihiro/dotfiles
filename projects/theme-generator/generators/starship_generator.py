#!/usr/bin/env python3

import os
import re
import shutil
from pathlib import Path
from . import BaseGenerator

class StarshipGenerator(BaseGenerator):
    def default_filename(self):
        return "starship.toml"
    
    def format_palette_name(self, theme_name):
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
    
    def _extract_colors_from_tmux(self, tmux_colors_path):
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
    
    def _find_all_themes(self, themes_dir):
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
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()
        
        # Setup paths - adjust these to your needs
        home = Path.home()
        themes_dir = home / "dotfiles" / "themes"
        template = home / "dotfiles" / "projects" / "templates" / "starship-template.toml"
        
        print("🎨 Starship Palette Generator")
        print("=" * 40)
        
        # Convert output_file to Path and ensure directory exists
        output_path = Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Step 1: Backup existing config
        print("\n1. Checking for existing config...")
        self.backup_file(str(output_path))  # Convert to string for backup_file
        
        # Step 2: Copy template
        print("\n2. Setting up new config...")
        if not template.exists():
            print(f"❌ Template not found: {template}")
            return None
        
        try:
            shutil.copy2(template, output_path)
            print(f"📄 Copied template to {output_path}")
        except Exception as e:
            print(f"❌ Error copying template: {e}")
            return None
        
        # Step 3: Find all themes
        print("\n3. Discovering themes...")
        themes = self._find_all_themes(themes_dir)
        
        if not themes:
            print("❌ No themes found with tmux-colors.conf!")
            return None
        
        print(f"   Found {len(themes)} theme(s)")
        
        # Step 4: Process each theme
        print("\n4. Extracting colors...")
        success_count = 0
        
        for theme_name, tmux_path in sorted(themes, key=lambda x: x[0]):
            palette_name = self.format_palette_name(theme_name)
            print(f"   • {theme_name:20} → {palette_name}")
            
            colors = self._extract_colors_from_tmux(tmux_path)
            
            if colors:
                # Append palette to starship.toml
                with open(output_path, 'a') as f:
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
        print(f"   • Total themes found: {len(themes)}")
        print(f"   • Palettes created: {success_count}")
        print(f"   • Config file: {output_path}")
        
        # Show example usage
        if success_count > 0:
            print("\n💡 Quick Start:")
            print("   To use a palette, add this to your starship.toml:")
            print("   [format]")
            print("   palette = \"Everforest\"")
            print("\n   Or use a specific variant:")
            print("   palette = \"Catppuccin_Latte\"")
        
        return str(output_path)
