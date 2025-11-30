from . import BaseGenerator
import os
import re

class TmuxGenerator(BaseGenerator):
    def default_filename(self):
        return "tmux-palette.conf"
    
    def _parse_rofi_colors(self, rofi_file_path="rofi.rasi"):
        """Parse colors from rofi.rasi file to extract the actual hex values"""
        colors = {}
        
        if not os.path.exists(rofi_file_path):
            print(f"Warning: {rofi_file_path} not found, using theme colors")
            return self.colors
        
        with open(rofi_file_path, 'r') as f:
            content = f.read()
        
        # Extract all color definitions
        color_pattern = r'(\w+):\s*([^;]+);'
        matches = re.findall(color_pattern, content)
        
        for key, value in matches:
            key = key.strip()
            value = value.strip()
            
            # Handle @colorX references by looking up their actual values
            if value.startswith('@'):
                ref_color = value[1:]  # Remove @ symbol
                # Find the referenced color value
                ref_pattern = rf'{ref_color}:\s*([^;]+);'
                ref_match = re.search(ref_pattern, content)
                if ref_match:
                    value = ref_match.group(1).strip()
            
            # Remove transparency from surface colors
            if 'CC' in value or '80' in value or '40' in value:
                value = value.replace('CC', '').replace('80', '').replace('40', '')
            
            # Store the color
            colors[key] = value
        
        return colors
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()
        self.backup_file(output_file)
        
        # Parse colors from rofi.rasi
        rofi_colors = self._parse_rofi_colors()
        
        # Generate just the color definitions
        color_definitions = f"""# Color definitions extracted from rofi.rasi
base="{rofi_colors.get('background', self.colors['background'])}"
text="{rofi_colors.get('foreground', self.colors['foreground'])}"
crust="{rofi_colors.get('color0', self.colors['color0'])}"

# Signature colors
sig1="{rofi_colors.get('color5', self.colors['color5'])}"
sig2="{rofi_colors.get('color9', self.colors['color9'])}"
on_sig1="{rofi_colors.get('color0', self.colors['color0'])}"
on_sig2="{rofi_colors.get('color0', self.colors['color0'])}"
on_sigbg="{rofi_colors.get('color15', self.colors['color15'])}"

# Surface colors
sig_bg="{rofi_colors.get('color8', self.colors['color8'])}"
sig_surface_high="#856c7c"

# Color palette
red="{rofi_colors.get('color1', self.colors['color1'])}"
green="{rofi_colors.get('color2', self.colors['color2'])}"
yellow="{rofi_colors.get('color3', self.colors['color3'])}"
blue="{rofi_colors.get('color4', self.colors['color4'])}"
magenta="{rofi_colors.get('color5', self.colors['color5'])}"
cyan="{rofi_colors.get('color6', self.colors['color6'])}"
white="{rofi_colors.get('color7', self.colors['color7'])}"
black="{rofi_colors.get('color0', self.colors['color0'])}"

# Bright colors
bright_black="{rofi_colors.get('color8', self.colors['color8'])}"
bright_red="{rofi_colors.get('color9', self.colors['color9'])}"
bright_green="{rofi_colors.get('color10', self.colors['color10'])}"
bright_yellow="{rofi_colors.get('color11', self.colors['color11'])}"
bright_blue="{rofi_colors.get('color12', self.colors['color12'])}"
bright_magenta="{rofi_colors.get('color13', self.colors['color13'])}"
bright_cyan="{rofi_colors.get('color14', self.colors['color14'])}"
bright_white="{rofi_colors.get('color15', self.colors['color15'])}"

"""
        
        # Read the existing file content (if any)
        existing_content = ""
        if os.path.exists(output_file):
            with open(output_file, 'r') as f:
                existing_content = f.read()
        
        # Remove any existing color definitions (lines that look like color variables)
        lines = existing_content.split('\n')
        filtered_lines = []
        skip_next_empty = False
        
        for line in lines:
            # Skip lines that look like color definitions (variable="value")
            if re.match(r'^\w+="[^"]*"', line) or line.startswith('# Color definitions'):
                skip_next_empty = True
                continue
            # Skip empty line after color definitions
            if skip_next_empty and line.strip() == '':
                skip_next_empty = False
                continue
            filtered_lines.append(line)
        
        # Combine new color definitions with filtered existing content
        filtered_content = '\n'.join(filtered_lines).strip()
        full_content = color_definitions + filtered_content
        
        with open(output_file, 'w') as f:
            f.write(full_content)
        
        print(f"Tmux palette updated successfully: {output_file}")
        print("Colors extracted from rofi.rasi and prepended to existing config")
        
        return output_file
