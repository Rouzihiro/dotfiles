from . import BaseGenerator

class TmuxGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "tmux-palette.conf"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Only generate the first 28 lines (color definitions)
        color_section = f"""# Kanagawa Dragon Theme for Tmux
# Generated from kitty.conf

signature="{self.colors['purple']}"
rosewater="{self.colors['foreground']}"
flamingo="{self.colors['color7']}"
pink="{self.colors['purple']}"
mauve="{self.colors['purple']}"
red="{self.colors['red']}"
maroon="{self.colors['color1']}"
peach="{self.colors['orange']}"
yellow="{self.colors['yellow']}"
green="{self.colors['green']}"
teal="{self.colors['aqua']}"
sky="{self.colors['blue']}"
sapphire="{self.colors['blue']}"
blue="{self.colors['blue']}"
lavender="{self.colors['purple']}"
text="{self.colors['foreground']}"
subtext1="{self.colors['color7']}"
subtext0="{self.colors['color8']}"
overlay2="{self.colors['color8']}"
overlay1="{self.colors['color8']}"
overlay0="{self.colors['color8']}"
surface2="{self.colors['color8']}"
surface1="{self.colors['color8']}"
surface0="{self.colors['color0']}"
base="{self.colors['background']}"
mantle="{self.colors['color0']}"
crust="{self.colors['color0']}"
"""

        # Fixed tmux configuration (always the same)
        fixed_config = """# Basic setup
set -g status-position top
set -g status-style "fg=$text,bg=$base"
set -g base-index 1
set -g renumber-windows on

# Pane borders - using signature color for active, surface1 for inactive
set -g pane-active-border-style "fg=$signature"
set -g pane-border-style "fg=$surface1"

# Simplified status bar
set -g status-left ""
set -g status-right ""

##### Window Tabs - using overlay2 for inactive, signature for active
set -g window-status-separator " "
set -g window-status-format \
	"#[fg=$overlay2,bg=default]#[fg=$text,bg=$overlay2] #I:#W #[fg=$overlay2,bg=default]"

set -g window-status-current-format \
	"#[fg=$signature,bg=default]#[fg=$base,bg=$signature] #I:#W #[fg=$signature,bg=default]"

##### Right Status - matching starship's color progression
set -g status-right "\
#[fg=$signature,bg=default]\
#[fg=$crust,bg=$signature]  #(echo \"#{pane_current_path}\" | awk -F/ '{ if (NF<=2) print \\$NF; else print \\$(NF-1)\"/\"\\$NF; }') \
#[fg=$signature,bg=$blue]#[fg=$crust,bg=$blue] #(timew | awk '/^ *Total/ {print \\$NF}') \
#[fg=$blue,bg=default]"

##### Message Styling - using signature color for highlights
set -g message-style "fg=$crust,bg=$signature"
set -g message-command-style "fg=$text,bg=$base"

# Additional tmux elements that match starship
set -g mode-style "fg=$crust,bg=$signature"
set -g status-justify left

# Optional: Set selection colors to match
set -g copy-mode-match-style "fg=$crust,bg=$yellow"
set -g copy-mode-current-match-style "fg=$crust,bg=$peach"
"""
        
        # Combine both sections
        full_config = color_section + fixed_config
        
        with open(output_file, 'w') as f:
            f.write(full_config)
        return output_file
