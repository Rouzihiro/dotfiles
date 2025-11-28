from . import BaseGenerator

class RofiGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "rofi.rasi"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Build extended colors section only if they exist
        extended_colors = ""
        if 'color16' in self.colors:
            extended_colors += f"    color16: {self.colors['color16']};          /* orange */\n"
        if 'color17' in self.colors:
            extended_colors += f"    color17: {self.colors['color17']};          /* peach */\n"
        
        template = f"""* {{
    background: {self.colors['background']};      /* background */
    foreground: {self.colors['foreground']};      /* foreground */
    selection-background: {self.colors['selection_background']};  /* selection bg */
    selection-foreground: {self.colors['selection_foreground']};  /* selection fg */
    border-color: {self.colors['selection_background']};    /* border */
    
    /* Signature colors - customize these per theme */
    sigbg: @color8;           /* signature background */
    sig1: @color1;            /* signature color 1 */
    sig2: @color2;            /* signature color 2 */
    sig3: @color3;            /* signature color 3 */

    /* Normal colors */
    color0: {self.colors['color0']};          /* black */
    color1: {self.colors['color1']};          /* red */
    color2: {self.colors['color2']};          /* green */
    color3: {self.colors['color3']};          /* yellow */
    color4: {self.colors['color4']};          /* blue */
    color5: {self.colors['color5']};          /* magenta */
    color6: {self.colors['color6']};          /* cyan */
    color7: {self.colors['color7']};          /* white */

    /* Bright colors */
    color8: {self.colors['color8']};          /* bright black */
    color9: {self.colors['color9']};          /* bright red */
    color10: {self.colors['color10']};         /* bright green */
    color11: {self.colors['color11']};         /* bright yellow */
    color12: {self.colors['color12']};         /* bright blue */
    color13: {self.colors['color13']};         /* bright magenta */
    color14: {self.colors['color14']};         /* bright cyan */
    color15: {self.colors['color15']};         /* bright white */

    /* Extended colors */
{extended_colors}}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
