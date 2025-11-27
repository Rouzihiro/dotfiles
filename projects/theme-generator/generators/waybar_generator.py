from . import BaseGenerator

class WaybarGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "waybar.css"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""@define-color foreground \t{self.colors['foreground']};
@define-color background \t{self.colors['background']};
@define-color bg \t\t\t\t{self.colors['background']};
@define-color fg \t\t\t\t{self.colors['foreground']};
@define-color bordercolor {self.colors['gray']};
@define-color highlight \t{self.colors['yellow']};
@define-color alert \t\t\t{self.colors['red']};
@define-color activegreen {self.colors['green']};
@define-color disabled    {self.colors['color0']};

@define-color bg_alt      {self.colors['color0']};
@define-color border      {self.colors['color8']};

@define-color red         {self.colors['color1']};
@define-color green       {self.colors['color2']};
@define-color yellow      {self.colors['color3']};
@define-color blue        {self.colors['color4']};
@define-color purple      {self.colors['color5']};
@define-color aqua        {self.colors['color6']};
@define-color orange      {self.colors['color16']};
@define-color gray        {self.colors['color8']};
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
