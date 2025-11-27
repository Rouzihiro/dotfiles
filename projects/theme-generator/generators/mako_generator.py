from . import BaseGenerator

class MakoGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "mako.ini"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""include=~/.config/mako/core.ini

text-color={self.colors['foreground']}
border-color={self.colors['gray']}
background-color={self.colors['background']}
padding=10
border-size=1
font=Liberation Sans 11
max-icon-size=32
outer-margin=20
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
