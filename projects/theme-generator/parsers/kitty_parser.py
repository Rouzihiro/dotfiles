import os
import re
from pathlib import Path

class KittyParser:
    def __init__(self, kitty_source="kitty.conf"):
        self.kitty_source = kitty_source
        self.colors = {}
    
    def parse(self):
        """Parse colors from kitty config file"""
        if not os.path.exists(self.kitty_source):
            raise FileNotFoundError(f"Kitty config not found: {self.kitty_source}")
        
        print(f"🎨 Parsing colors from: {self.kitty_source}")
        
        with open(self.kitty_source, 'r') as f:
            content = f.read()
        
        # Extract colors using regex
        color_patterns = {
            'background': r'^background\s+(\S+)',
            'foreground': r'^foreground\s+(\S+)',
            'selection_background': r'^selection_background\s+(\S+)',
            'selection_foreground': r'^selection_foreground\s+(\S+)',
        }
        
        # Add color0 through color17
        for i in range(18):
            color_patterns[f'color{i}'] = rf'^color{i}\s+(\S+)'
        
        for key, pattern in color_patterns.items():
            match = re.search(pattern, content, re.MULTILINE)
            if match:
                self.colors[key] = match.group(1)
            else:
                print(f"⚠️  Warning: {key} not found in kitty config")
        
        # Set semantic names for easier access
        self.colors.update({
            'bg': self.colors.get('background', ''),
            'fg': self.colors.get('foreground', ''),
            'bordercolor': self.colors.get('color8', ''),
            'highlight': self.colors.get('color11', ''),
            'alert': self.colors.get('color1', ''),
            'activegreen': self.colors.get('color2', ''),
            'disabled': self.colors.get('color0', ''),
            'bg_alt': self.colors.get('color0', ''),
            'border': self.colors.get('color8', ''),
            'red': self.colors.get('color1', ''),
            'green': self.colors.get('color2', ''),
            'yellow': self.colors.get('color3', ''),
            'blue': self.colors.get('color4', ''),
            'purple': self.colors.get('color5', ''),
            'aqua': self.colors.get('color6', ''),
            'orange': self.colors.get('color16', ''),
            'gray': self.colors.get('color8', ''),
        })
        
        print(f"✅ Parsed {len([k for k in self.colors if k.startswith('color')])} colors")
        return self.colors
