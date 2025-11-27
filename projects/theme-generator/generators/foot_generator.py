from . import BaseGenerator

class FootGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "foot.ini"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""[colors]
background = {self.colors['background'].lstrip('#')}
foreground = {self.colors['foreground'].lstrip('#')}
regular0 = {self.colors['color0'].lstrip('#')}
regular1 = {self.colors['color1'].lstrip('#')}
regular2 = {self.colors['color2'].lstrip('#')}
regular3 = {self.colors['color3'].lstrip('#')}
regular4 = {self.colors['color4'].lstrip('#')}
regular5 = {self.colors['color5'].lstrip('#')}
regular6 = {self.colors['color6'].lstrip('#')}
regular7 = {self.colors['color7'].lstrip('#')}
bright0  = {self.colors['color8'].lstrip('#')}
bright1  = {self.colors['color9'].lstrip('#')}
bright2  = {self.colors['color10'].lstrip('#')}
bright3  = {self.colors['color11'].lstrip('#')}
bright4  = {self.colors['color12'].lstrip('#')}
bright5  = {self.colors['color13'].lstrip('#')}
bright6  = {self.colors['color14'].lstrip('#')}
bright7  = {self.colors['color15'].lstrip('#')}
dim0 = {self.colors['color8'].lstrip('#')}
dim1 = {self.colors['color9'].lstrip('#')}
dim2 = {self.colors['color10'].lstrip('#')}
dim3 = {self.colors['color11'].lstrip('#')}
dim4 = {self.colors['color12'].lstrip('#')}
dim5 = {self.colors['color13'].lstrip('#')}
dim6 = {self.colors['color14'].lstrip('#')}
dim7 = {self.colors['color7'].lstrip('#')}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
