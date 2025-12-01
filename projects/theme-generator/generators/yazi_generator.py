#!/usr/bin/env python3

import re
import os
import shutil
from pathlib import Path
from . import BaseGenerator

class YaziGenerator(BaseGenerator):
    def default_filename(self):
        return "yazi.toml"
    
    def _parse_colors_file(self, filepath):
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
    
    def _merge_template(self, template_content, colors):
        """Merge color definitions into template content"""
        # Replace all placeholders with actual colors
        for name, color in colors.items():
            placeholder = f"{{{{{name}}}}}"
            template_content = template_content.replace(placeholder, color)
        
        return template_content
    
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
                themes.append((theme_name, tmux_path, root_path))
        
        return themes
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()
        
        # Setup paths
        home = Path.home()
        themes_dir = home / "dotfiles" / "themes"
        template_file = home / "dotfiles" / "projects" / "templates" / "yazi-template.toml"
        
        print("🎨 Yazi Theme Generator")
        print("=" * 60)
        
        # Check if template exists
        if not template_file.exists():
            print(f"❌ Template file not found: {template_file}")
            return None
        
        # Read template content
        try:
            with open(template_file, 'r') as f:
                template_content = f.read()
        except Exception as e:
            print(f"❌ Error reading template file: {e}")
            return None
        
        # Find all theme folders
        print("\n1. Discovering themes...")
        themes = self._find_all_themes(themes_dir)
        
        if not themes:
            print("❌ No themes found with tmux-colors.conf!")
            return None
        
        print(f"   Found {len(themes)} theme(s)")
        
        # Process each theme
        print("\n2. Generating yazi.toml files...")
        print("   (Existing yazi.toml files will be backed up as yazi.toml.backup)")
        print("=" * 60)
        
        successful = 0
        
        for theme_name, tmux_path, theme_folder in themes:
            print(f"\n🎨 Processing: {theme_name}")
            
            # Parse colors
            colors = self._parse_colors_file(tmux_path)
            
            # Check if we have all required colors
            required_colors = ['base', 'text', 'crust', 'sig1', 'sig2', 'on_sig1', 
                             'on_sig2', 'on_sigbg', 'sig_bg', 'sig_surface_high', 'red']
            
            missing = [c for c in required_colors if c not in colors]
            if missing:
                print(f"   ⚠ Missing colors: {missing}")
                # Fill missing with defaults
                for color in missing:
                    colors[color] = "#000000"
            
            # Show extracted colors
            found_colors = list(colors.keys())
            print(f"   ✓ Found {len(found_colors)}/{len(required_colors)} colors")
            
            # Merge template
            merged_content = self._merge_template(template_content, colors)
            
            # Backup existing yazi.toml if it exists
            yazi_output = theme_folder / "yazi.toml"
            if yazi_output.exists():
                backup_path = theme_folder / "yazi.toml.backup"
                shutil.copy2(yazi_output, backup_path)
                print(f"   📦 Backed up existing yazi.toml")
            
            # Write output
            with open(yazi_output, 'w') as f:
                f.write(merged_content)
            
            successful += 1
            print(f"   ✅ Generated {yazi_output}")
        
        # Summary
        print("\n" + "=" * 60)
        print("✨ Summary")
        print(f"   • Total themes found: {len(themes)}")
        print(f"   • Successfully generated: {successful}/{len(themes)}")
        
        # Show generated files
        if successful > 0:
            print("\n📁 Generated yazi.toml files:")
            for theme_name, tmux_path, theme_folder in themes:
                yazi_file = theme_folder / "yazi.toml"
                if yazi_file.exists():
                    backup_file = theme_folder / "yazi.toml.backup"
                    backup_status = " (with backup)" if backup_file.exists() else ""
                    print(f"   📄 {theme_name}/yazi.toml{backup_status}")
        
        # Return the last generated file path (or a default)
        if themes:
            last_theme_folder = themes[-1][2]
            return str(last_theme_folder / "yazi.toml")
        else:
            return None
