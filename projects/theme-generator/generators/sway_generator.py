from . import BaseGenerator

class SwayGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "sway"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""# Generated from kitty.conf

# Default foreground
set $fujiWhite      {self.colors['foreground']}

# Dark foreground (statuslines)
set $oldWhite       {self.colors['color7']}

# Dark background (statuslines and floating windows)
set $sumiInk0       {self.colors['color0']}

# Default background
set $sumiInk1       {self.colors['background']}

# Lighter background (colorcolumn, folds)
set $sumiInk2       {self.colors['color8']}

# Lighter background (cursorline)
set $sumiInk3       {self.colors['color8']}

# Darker foreground (line numbers, fold column, non-text characters), float borders
set $sumiInk4       {self.colors['gray']}

# Popup background, visual selection background
set $waveBlue1      {self.colors['color4']}

# Popup selection background, search background
set $waveBlue2      {self.colors['blue']}

# Diff Add (background)
set $winterGreen    {self.colors['color2']}

# Diff Change (background)
set $winterYellow   {self.colors['color3']}

# Diff Deleted (background)
set $winterRed      {self.colors['red']}

# Diff Line (background)
set $winterBlue     {self.colors['color4']}

# Git Add
set $autumnGreen    {self.colors['green']}

# Git Delete
set $autumnRed      {self.colors['red']}

# Git Change
set $autumnYellow   {self.colors['yellow']}

# Diagnostic Error
set $samuraiRed     {self.colors['red']}

# Diagnostic Warning
set $roninYellow    {self.colors['yellow']}

# Diagnostic Info
set $waveAqua1      {self.colors['blue']}

# Diagnostic Hint
set $dragonBlue     {self.colors['blue']}

# Comments
set $fujiGray       {self.colors['gray']}

# Light foreground
set $springViolet1  {self.colors['color7']}

# Statements and Keywords
set $oniViolet      {self.colors['purple']}

# Functions and Titles
set $crystalBlue    {self.colors['blue']}

# Brackets and punctuation
set $springViolet2  {self.colors['purple']}

# Specials and builtin functions
set $springBlue     {self.colors['blue']}

# Not used (assigned Nightfox-consistent shades)
set $lightBlue      {self.colors['aqua']}
set $boatYellow1    {self.colors['color3']}

# Types
set $waveAqua2      {self.colors['aqua']}

# Strings
set $springGreen    {self.colors['green']}

# Operators, RegEx
set $boatYellow2    {self.colors['color3']}

# Identifiers
set $carpYellow     {self.colors['yellow']}

# Numbers
set $sakuraPink     {self.colors['purple']}

# Standout specials 1 (builtin variables)
set $waveRed        {self.colors['red']}

# Standout specials 2 (exception handling, return)
set $peachRed       {self.colors['red']}

# Constants, imports, booleans
set $surimiOrange   {self.colors['orange']}

# Deprecated
set $katanaGray     {self.colors['gray']}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
