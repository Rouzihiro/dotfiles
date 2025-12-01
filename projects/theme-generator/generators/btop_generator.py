from . import BaseGenerator

class BtopGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "btop.theme"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        template = f"""# Generated from kitty.conf

# Colors should be in 6 or 2 character hexadecimal or single spaced rgb decimal: "#RRGGBB", "#BW" or "0-255 0-255 0-255"
# example for white: "#FFFFFF", "#ff" or "255 255 255".

# All graphs and meters can be gradients
# For single color graphs leave "mid" and "end" variable empty.
# Use "start" and "end" variables for two color gradient
# Use "start", "mid" and "end" for three color gradient

# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]="{self.colors['background']}"

# Main text color
theme[main_fg]="{self.colors['gray']}"

# Title color for boxes
theme[title]="{self.colors['foreground']}"

# Highlight color for keyboard shortcuts
theme[hi_fg]="{self.colors['yellow']}"

# Background color of selected items
theme[selected_bg]="{self.colors['background']}"

# Foreground color of selected items
theme[selected_fg]="{self.colors['yellow']}"

# Color of inactive/disabled text
theme[inactive_fg]="{self.colors['background']}"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling
theme[graph_text]="{self.colors['color8']}"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text
theme[proc_misc]="{self.colors['green']}"

# Cpu box outline color
theme[cpu_box]="{self.colors['gray']}"

# Memory/disks box outline color
theme[mem_box]="{self.colors['gray']}"

# Net up/down box outline color
theme[net_box]="{self.colors['gray']}"

# Processes box outline color
theme[proc_box]="{self.colors['gray']}"

# Box divider line and small boxes line color
theme[div_line]="{self.colors['gray']}"

# Temperature graph colors
theme[temp_start]="{self.colors['blue']}"
theme[temp_mid]="{self.colors['purple']}"
theme[temp_end]="{self.colors['color9']}"

# CPU graph colors
theme[cpu_start]="{self.colors['green']}"
theme[cpu_mid]="{self.colors['yellow']}"
theme[cpu_end]="{self.colors['red']}"

# Mem/Disk free meter
theme[free_start]="{self.colors['color2']}"
theme[free_mid]=""
theme[free_end]="{self.colors['green']}"

# Mem/Disk cached meter
theme[cached_start]="{self.colors['blue']}"
theme[cached_mid]=""
theme[cached_end]="{self.colors['color12']}"

# Mem/Disk available meter
theme[available_start]="{self.colors['color3']}"
theme[available_mid]=""
theme[available_end]="{self.colors['yellow']}"

# Mem/Disk used meter
theme[used_start]="{self.colors['color1']}"
theme[used_mid]=""
theme[used_end]="{self.colors['red']}"

# Download graph colors
theme[download_start]="{self.colors['color13']}"
theme[download_mid]="{self.colors['color5']}"
theme[download_end]="{self.colors['purple']}"

# Upload graph colors
theme[upload_start]="{self.colors['color13']}"
theme[upload_mid]="{self.colors['color5']}"
theme[upload_end]="{self.colors['purple']}"
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
