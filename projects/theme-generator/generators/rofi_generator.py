from . import BaseGenerator

class RofiGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "rofi.rasi"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""* {{
    primary: {self.colors['color3']};
    primary-fixed: {self.colors['color3']};
    primary-fixed-dim: {self.colors['color11']};
    on-primary: {self.colors['color0']};
    on-primary-fixed: {self.colors['color0']};
    on-primary-fixed-variant: {self.colors['color8']};
    primary-container: {self.colors['color4']};
    on-primary-container: {self.colors['foreground']};
    secondary: {self.colors['color7']};
    secondary-fixed: {self.colors['color7']};
    secondary-fixed-dim: {self.colors['color8']};
    on-secondary: {self.colors['color0']};
    on-secondary-fixed: {self.colors['color0']};
    on-secondary-fixed-variant: {self.colors['color8']};
    secondary-container: {self.colors['color6']};
    on-secondary-container: {self.colors['foreground']};
    tertiary: {self.colors['color15']};
    tertiary-fixed: {self.colors['color15']};
    tertiary-fixed-dim: {self.colors['color7']};
    on-tertiary: {self.colors['color0']};
    on-tertiary-fixed: {self.colors['color0']};
    on-tertiary-fixed-variant: {self.colors['color8']};
    tertiary-container: {self.colors['color5']};
    on-tertiary-container: {self.colors['foreground']};
    error: {self.colors['color1']};
    on-error: {self.colors['color0']};
    error-container: {self.colors['color9']};
    on-error-container: {self.colors['foreground']};
    surface: {self.colors['color0']};
    on-surface: {self.colors['foreground']};
    on-surface-variant: {self.colors['color7']};
    outline: {self.colors['color8']};
    outline-variant: {self.colors['color8']};
    shadow: #000000;
    scrim: #000000;
    inverse-surface: {self.colors['foreground']};
    inverse-on-surface: {self.colors['color0']};
    inverse-primary: {self.colors['color4']};
    surface-dim: {self.colors['color0']};
    surface-bright: {self.colors['color8']};
    surface-container-lowest: {self.colors['color0']};
    surface-container-low: {self.colors['color0']};
    surface-container: {self.colors['color8']};
    surface-container-high: {self.colors['color8']};
    surface-container-highest: {self.colors['color8']};
}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
