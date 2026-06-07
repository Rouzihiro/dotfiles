from . import BaseGenerator

class BarGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "bar"

    def c(self, key, fallback=None):
        return self.colors.get(key, fallback or self.colors.get("foreground"))

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)

        template = f"""
bar {{
    position top
    tray_padding 0
    status_command i3blocks -c ~/.config/i3blocks/config
    separator_symbol ""

    font pango:DroidSansM Nerd Font 10

    colors {{
        background {self.c('background')}
        statusline {self.c('foreground')}
        separator  {self.c('border', self.c('color8'))}

        focused_workspace  {self.c('sig1')} {self.c('sig1')} {self.c('background')}
        active_workspace   {self.c('sig2', self.c('color2'))} {self.c('sig2', self.c('color2'))} {self.c('background')}
        inactive_workspace {self.c('background')} {self.c('background')} {self.c('gray', self.c('color8'))}
        urgent_workspace   {self.c('sig3', self.c('color1'))} {self.c('sig3', self.c('color1'))} {self.c('background')}

        binding_mode       {self.c('sig1', self.c('color5'))} {self.c('sig1', self.c('color5'))} {self.c('background')}
    }}
}}
"""
        with open(output_file, "w") as f:
            f.write(template)
