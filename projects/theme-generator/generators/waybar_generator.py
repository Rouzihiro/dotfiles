from . import BaseGenerator

class WaybarGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "waybar.css"

    def c(self, key, fallback=None):
        """
        Safe color getter with fallback support.
        """
        return self.colors.get(key, fallback or self.colors.get("foreground"))

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)

        template = f"""@define-color foreground \t{self.c('foreground')};
@define-color background \t{self.c('background')};
@define-color bg \t\t\t\t{self.c('background')};
@define-color fg \t\t\t\t{self.c('foreground')};
@define-color bordercolor {self.c('gray', self.c('color8'))};
@define-color highlight \t{self.c('yellow', self.c('color3'))};
@define-color alert \t\t\t{self.c('red', self.c('color1'))};
@define-color activegreen {self.c('green', self.c('color2'))};
@define-color disabled    {self.c('color0')};

@define-color bg_alt      {self.c('color0')};
@define-color border      {self.c('color8')};

@define-color red         {self.c('color1')};
@define-color green       {self.c('color2')};
@define-color yellow      {self.c('color3')};
@define-color blue        {self.c('color4')};
@define-color purple      {self.c('color5')};
@define-color aqua        {self.c('color6')};

@define-color orange      {self.c('color16', self.c('color3'))};
@define-color gray        {self.c('color8')};
"""

        with open(output_file, 'w') as f:
            f.write(template)

        return output_file
