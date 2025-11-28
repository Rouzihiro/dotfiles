from . import BaseGenerator

class RofiGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "rofi.rasi"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""* {{
    background: {self.colors['background']};
    foreground: {self.colors['foreground']};
    selection-background: {self.colors['selection_background']};
    selection-foreground: {self.colors['selection_foreground']};
    border-color: {self.colors['selection_background']};
    
    /* Normal colors */
    color0: {self.colors['color0']};
    color1: {self.colors['color1']};
    color2: {self.colors['color2']};
    color3: {self.colors['color3']};
    color4: {self.colors['color4']};
    color5: {self.colors['color5']};
    color6: {self.colors['color6']};
    color7: {self.colors['color7']};
    
    /* Bright colors */
    color8: {self.colors['color8']};
    color9: {self.colors['color9']};
    color10: {self.colors['color10']};
    color11: {self.colors['color11']};
    color12: {self.colors['color12']};
    color13: {self.colors['color13']};
    color14: {self.colors['color14']};
    color15: {self.colors['color15']};
    
    /* Extended colors */
    color16: {self.colors['color16']};
    color17: {self.colors['color17']};
}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
