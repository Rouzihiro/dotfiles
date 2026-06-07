from . import BaseGenerator

class SwayGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "sway-theme"

    def c(self, key, fallback=None):
        return self.colors.get(key, fallback or self.colors.get("foreground"))

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)

        bg = self.c("background")
        fg = self.c("foreground")
        fg_dim = self.c("color8", self.c("gray"))

        sig1 = self.c("sig1")
        sig2 = self.c("sig2", self.c("color2"))
        sig3 = self.c("sig3", self.c("color1"))

        template = f"""
# Sway client window colors (semantic system)

client.focused          {sig1}   {bg}   {fg}      {sig1}   {sig1}
client.focused_inactive {bg}     {bg}   {sig2}    {sig2}   {bg}
client.unfocused        {bg}     {bg}   {fg_dim}  {bg}     {bg}
client.urgent           {sig3}   {bg}   {fg}      {sig3}   {sig3}
"""

        with open(output_file, "w") as f:
            f.write(template)
