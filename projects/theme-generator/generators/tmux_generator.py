#!/usr/bin/env python3

import os
import re
import shutil
from pathlib import Path
from . import BaseGenerator

class TmuxRofiGenerator(BaseGenerator):
    def default_filename(self):
        return "tmux-colors.conf"
    
    def _parse_rofi_colors(self, rofi_file_path):
        """Parse colors from rofi.rasi file and resolve @colorX references"""
        colors = {}
        
        if not os.path.exists(rofi_file_path):
            print(f"❌ Error: {rofi_file_path} not found")
            return {}
        
        with open(rofi_file_path, 'r') as f:
            content = f.read()
        
        # Extract all color definitions
        color_pattern = r'([a-zA-Z0-9-]+):\s*([^;]+)'
        matches = re.findall(color_pattern, content)
        
        # Store all color variables for reference resolution
        color_map = {}
        for var_name, var_value in matches:
            var_name = var_name.strip()
            var_value = var_value.strip()
            color_map[var_name] = var_value
        
        # Function to resolve color references (handle @colorX)
        def resolve_color(value):
            if value.startswith('@'):
                ref_name = value[1:]  # Remove @ symbol
                return color_map.get(ref_name, value)
            return value
        
        # Function to remove alpha channel from colors
        def remove_alpha(color):
            if color.startswith('#') and len(color) == 9:  # 8 chars + # symbol
                return color[:7]  # Remove last 2 characters (alpha)
            return color
        
        # Extract base colors
        colors['base'] = remove_alpha(resolve_color(color_map.get('background', '#000000')))
        colors['text'] = remove_alpha(resolve_color(color_map.get('foreground', '#ffffff')))
        colors['crust'] = remove_alpha(resolve_color(color_map.get('color8', '#000000')))
        
        # Extract signature colors
        colors['sig1'] = remove_alpha(resolve_color(color_map.get('sig1', '#000000')))
        colors['sig2'] = remove_alpha(resolve_color(color_map.get('sig2', '#000000')))
        colors['on_sig1'] = remove_alpha(resolve_color(color_map.get('on-sig1', '#ffffff')))
        colors['on_sig2'] = remove_alpha(resolve_color(color_map.get('on-sig2', '#ffffff')))
        colors['on_sigbg'] = remove_alpha(resolve_color(color_map.get('on-sigbg', '#ffffff')))
        colors['sig_bg'] = remove_alpha(resolve_color(color_map.get('sigbg', '#000000')))
        colors['sig_surface_high'] = remove_alpha(resolve_color(color_map.get('sig-surface-high', '#000000')))
        
        # Extract main color palette
        colors['red'] = remove_alpha(resolve_color(color_map.get('color1', '#ff0000')))
        colors['green'] = remove_alpha(resolve_color(color_map.get('color2', '#00ff00')))
        colors['yellow'] = remove_alpha(resolve_color(color_map.get('color3', '#ffff00')))
        colors['blue'] = remove_alpha(resolve_color(color_map.get('color4', '#0000ff')))
        colors['magenta'] = remove_alpha(resolve_color(color_map.get('color5', '#ff00ff')))
        colors['cyan'] = remove_alpha(resolve_color(color_map.get('color6', '#00ffff')))
        colors['white'] = remove_alpha(resolve_color(color_map.get('color7', '#ffffff')))
        colors['black'] = remove_alpha(resolve_color(color_map.get('color0', '#000000')))
        
        # Extract bright colors
        colors['bright_black'] = remove_alpha(resolve_color(color_map.get('color8', '#000000')))
        colors['bright_red'] = remove_alpha(resolve_color(color_map.get('color9', '#ff0000')))
        colors['bright_green'] = remove_alpha(resolve_color(color_map.get('color10', '#00ff00')))
        colors['bright_yellow'] = remove_alpha(resolve_color(color_map.get('color11', '#ffff00')))
        colors['bright_blue'] = remove_alpha(resolve_color(color_map.get('color12', '#0000ff')))
        colors['bright_magenta'] = remove_alpha(resolve_color(color_map.get('color13', '#ff00ff')))
        colors['bright_cyan'] = remove_alpha(resolve_color(color_map.get('color14', '#00ffff')))
        colors['bright_white'] = remove_alpha(resolve_color(color_map.get('color15', '#ffffff')))
        
        return colors
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()
        output_path = Path(output_file)
        
        # Setup paths
        home = Path.home()
        template_file = home / "dotfiles" / "projects" / "templates" / "tmux-template.conf"
        input_file = "rofi.rasi"  # Current directory
        
        print("🎨 Tmux Colors Generator (from Rofi)")
        print("=" * 60)
        
        # Check if input files exist
        if not os.path.exists(input_file):
            print(f"❌ Error: {input_file} not found in current directory")
            return None
        
        if not template_file.exists():
            print(f"❌ Error: {template_file} not found")
            return None
        
        # Step 1: Backup existing output file
        print("\n1. Checking for existing config...")
        self.backup_file(str(output_path))
        
        # Step 2: Copy template to output
        print("\n2. Copying template...")
        try:
            shutil.copy2(template_file, output_path)
            print(f"   📄 Copied template to {output_path}")
        except Exception as e:
            print(f"   ❌ Error copying template: {e}")
            return None
        
        # Step 3: Parse colors from rofi.rasi
        print("\n3. Extracting colors from rofi.rasi...")
        colors = self._parse_rofi_colors(input_file)
        
        if not colors:
            print("   ❌ No colors could be extracted")
            return None
        
        # Generate color definitions
        color_definitions = """# Color definitions extracted from rofi.rasi
# Base colors
base="{base}"
text="{text}"
crust="{crust}"

# Signature colors
sig1="{sig1}"
sig2="{sig2}"
on_sig1="{on_sig1}"
on_sig2="{on_sig2}"
on_sigbg="{on_sigbg}"
sig_bg="{sig_bg}"
sig_surface_high="{sig_surface_high}"

# Color palette (from Rofi colors)
red="{red}"
green="{green}"
yellow="{yellow}"
blue="{blue}"
magenta="{magenta}"
cyan="{cyan}"
white="{white}"
black="{black}"

# Bright colors
bright_black="{bright_black}"
bright_red="{bright_red}"
bright_green="{bright_green}"
bright_yellow="{bright_yellow}"
bright_blue="{bright_blue}"
bright_magenta="{bright_magenta}"
bright_cyan="{bright_cyan}"
bright_white="{bright_white}"

""".format(**colors)
        
        # Step 4: Read existing output file content
        with open(output_path, 'r') as f:
            existing_content = f.read()
        
        # Step 5: Prepend color definitions to existing content
        combined_content = color_definitions + existing_content
        
        # Write the combined content back to file
        with open(output_path, 'w') as f:
            f.write(combined_content)
        
        print("\n4. Summary")
        print("=" * 60)
        print(f"   ✅ Conversion complete!")
        print(f"   📁 Output file: {output_path}")
        print(f"   🎨 Colors extracted: {len(colors)}")
        print(f"   📝 Note: Alpha channels removed from colors for tmux compatibility")
        
        return str(output_path)
