from . import BaseGenerator

class DircolorsGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "dircolors"
    
    def hex_to_rgb(self, hex_color):
        """Convert hex color to RGB tuple"""
        hex_color = hex_color.lstrip('#')
        if len(hex_color) == 6:
            return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
        elif len(hex_color) == 3:
            return tuple(int(hex_color[i]*2, 16) for i in (0, 1, 2))
        return (255, 255, 255)  # default to white
    
    def rgb_to_ansi(self, r, g, b):
        """Convert RGB to ANSI 256 color code"""
        return f"38;2;{r};{g};{b}"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Convert hex colors to RGB tuples
        blue_rgb = self.hex_to_rgb(self.colors['blue'])
        green_rgb = self.hex_to_rgb(self.colors['green'])
        red_rgb = self.hex_to_rgb(self.colors['red'])
        yellow_rgb = self.hex_to_rgb(self.colors['yellow'])
        aqua_rgb = self.hex_to_rgb(self.colors['aqua'])
        orange_rgb = self.hex_to_rgb(self.colors['orange'])
        gray_rgb = self.hex_to_rgb(self.colors['gray'])
        
        template = f"""# Kanagawa Dragon Theme for dircolors
# Generated from kitty.conf

RESET 0

DIR {self.rgb_to_ansi(*blue_rgb)}
LINK {self.rgb_to_ansi(*green_rgb)}
SOCK 01;{self.rgb_to_ansi(*red_rgb)}
FIFO {self.rgb_to_ansi(*yellow_rgb)}
EXEC 01;{self.rgb_to_ansi(*red_rgb)}
BLK {self.rgb_to_ansi(*yellow_rgb)}
CHR {self.rgb_to_ansi(*aqua_rgb)}
ORPH 01;{self.rgb_to_ansi(*red_rgb)}
MISSING 01;{self.rgb_to_ansi(*red_rgb)}

.tar  01;{self.rgb_to_ansi(*yellow_rgb)}
.tgz  01;{self.rgb_to_ansi(*yellow_rgb)}
.zip  01;{self.rgb_to_ansi(*yellow_rgb)}
.rar  01;{self.rgb_to_ansi(*yellow_rgb)}
.7z   01;{self.rgb_to_ansi(*yellow_rgb)}
.gz   01;{self.rgb_to_ansi(*yellow_rgb)}

.jpg  {self.rgb_to_ansi(*blue_rgb)}
.jpeg {self.rgb_to_ansi(*blue_rgb)}
.png  {self.rgb_to_ansi(*blue_rgb)}
.gif  {self.rgb_to_ansi(*blue_rgb)}
.svg  {self.rgb_to_ansi(*blue_rgb)}

.mp3  {self.rgb_to_ansi(*green_rgb)}
.flac {self.rgb_to_ansi(*green_rgb)}
.mp4 {self.rgb_to_ansi(*green_rgb)}
.mkv {self.rgb_to_ansi(*green_rgb)}
.webm {self.rgb_to_ansi(*green_rgb)}

.pdf  {self.rgb_to_ansi(*orange_rgb)}
.doc  {self.rgb_to_ansi(*orange_rgb)}
.docx {self.rgb_to_ansi(*orange_rgb)}
.odt  {self.rgb_to_ansi(*orange_rgb)}
.txt  {self.rgb_to_ansi(*gray_rgb)}
.md   {self.rgb_to_ansi(*gray_rgb)}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
