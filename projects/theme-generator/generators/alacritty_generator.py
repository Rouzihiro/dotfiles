from . import BaseGenerator

class AlacrittyGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "alacritty.toml"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""[colors.primary]
background = '{self.colors['background']}'
foreground = '{self.colors['foreground']}'

[colors.normal]
black = '{self.colors['color0']}'
red = '{self.colors['color1']}'
green = '{self.colors['color2']}'
yellow = '{self.colors['color3']}'
blue = '{self.colors['color4']}'
magenta = '{self.colors['color5']}'
cyan = '{self.colors['color6']}'
white = '{self.colors['color7']}'

[colors.bright]
black = '{self.colors['color8']}'
red = '{self.colors['color9']}'
green = '{self.colors['color10']}'
yellow = '{self.colors['color11']}'
blue = '{self.colors['color12']}'
magenta = '{self.colors['color13']}'
cyan = '{self.colors['color14']}'
white = '{self.colors['color15']}'

[colors.selection]
background = '{self.colors['selection_background']}'
foreground = '{self.colors['selection_foreground']}'

[[colors.indexed_colors]]
index = 16
color = '{self.colors['color16']}'

[[colors.indexed_colors]]
index = 17
color = '{self.colors['color17']}'
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
