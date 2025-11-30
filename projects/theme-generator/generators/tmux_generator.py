from . import BaseGenerator

class TmuxGenerator(BaseGenerator):
    def default_filename(self):
        return "tmux-palette.conf"
    
    def _get_signature_color_choice(self):
        """Interactive prompt for selecting signature colors for tmux"""
        print("\n" + "="*50)
        print("TMUX SIGNATURE COLOR SELECTION")
        print("="*50)
        
        # Available color options with descriptions
        color_options = {
            '0': ('color0', 'black'),
            '1': ('color1', 'red'),
            '2': ('color2', 'green'), 
            '3': ('color3', 'yellow'),
            '4': ('color4', 'blue'),
            '5': ('color5', 'magenta'),
            '6': ('color6', 'cyan'),
            '7': ('color7', 'white'),
            '8': ('color8', 'bright black'),
            '9': ('color9', 'bright red'),
            '10': ('color10', 'bright green'),
            '11': ('color11', 'bright yellow'),
            '12': ('color12', 'bright blue'),
            '13': ('color13', 'bright magenta'),
            '14': ('color14', 'bright cyan'),
            '15': ('color15', 'bright white'),
        }
        
        # Show available colors with their actual values
        print("\nAvailable colors:")
        print("-" * 40)
        for key, (color_name, description) in color_options.items():
            color_value = self.colors.get(color_name, 'N/A')
            print(f"  {key:>2}. {color_name:8} = {color_value:7} ({description})")
        
        print("\nPlease select colors for tmux elements:")
        print("-" * 40)
        
        sig_choices = {}
        
        # Get signature color (for active elements)
        while True:
            choice = input("\nSelect signature color (for active windows/borders) [default: 5 - magenta]: ").strip()
            if not choice:
                choice = '5'  # Default to magenta
            if choice in color_options:
                sig_choices['signature'] = color_options[choice][0]
                break
            else:
                print("Invalid choice! Please select a number from the list above.")
        
        # Show final selection
        print("\nTmux color selection complete:")
        print("-" * 40)
        for sig_name, color_ref in sig_choices.items():
            color_value = self.colors.get(color_ref, 'N/A')
            print(f"  {sig_name}: {color_value} (@{color_ref})")
        
        confirm = input("\nContinue with generation? [Y/n]: ").strip().lower()
        if confirm in ('n', 'no'):
            print("Generation cancelled.")
            return None
            
        return sig_choices
    
    def _calculate_harmonious_colors(self, sig_choices):
        """Calculate harmonious secondary colors based on signature color"""
        signature_hex = self.colors.get(sig_choices['signature'], '#000000')
        
        def hex_to_hsl(hex_color):
            """Convert hex color to HSL"""
            if not hex_color.startswith('#') or len(hex_color) != 7:
                return (0, 0, 0.5)
                
            hex_color = hex_color.lstrip('#')
            r, g, b = [int(hex_color[i:i+2], 16) / 255.0 for i in (0, 2, 4)]
            
            max_val = max(r, g, b)
            min_val = min(r, g, b)
            l = (max_val + min_val) / 2
            
            if max_val == min_val:
                h = s = 0
            else:
                d = max_val - min_val
                s = d / (2 - max_val - min_val) if l > 0.5 else d / (max_val + min_val)
                
                if max_val == r:
                    h = (g - b) / d + (6 if g < b else 0)
                elif max_val == g:
                    h = (b - r) / d + 2
                else:
                    h = (r - g) / d + 4
                h /= 6
                
            return (h, s, l)
        
        def hsl_to_hex(h, s, l):
            """Convert HSL to hex color"""
            def hue_to_rgb(p, q, t):
                if t < 0: t += 1
                if t > 1: t -= 1
                if t < 1/6: return p + (q - p) * 6 * t
                if t < 1/2: return q
                if t < 2/3: return p + (q - p) * (2/3 - t) * 6
                return p
                
            if s == 0:
                r = g = b = l
            else:
                q = l * (1 + s) if l < 0.5 else l + s - l * s
                p = 2 * l - q
                r = hue_to_rgb(p, q, h + 1/3)
                g = hue_to_rgb(p, q, h)
                b = hue_to_rgb(p, q, h - 1/3)
            
            r, g, b = [int(max(0, min(255, x * 255))) for x in (r, g, b)]
            return f"#{r:02x}{g:02x}{b:02x}"
        
        # Get HSL values of signature color
        sig_h, sig_s, sig_l = hex_to_hsl(signature_hex)
        
        # Create harmonious colors by adjusting hue and saturation
        harmonious_colors = {}
        
        # Green: 120° hue shift with similar saturation
        green_h = (sig_h + 0.333) % 1.0  # +120 degrees
        harmonious_colors['green'] = hsl_to_hex(green_h, min(1.0, sig_s * 1.1), sig_l)
        
        # Peach: 30° hue shift with increased lightness
        peach_h = (sig_h + 0.083) % 1.0  # +30 degrees
        harmonious_colors['peach'] = hsl_to_hex(peach_h, sig_s * 0.9, min(0.8, sig_l * 1.3))
        
        # Yellow: 60° hue shift with high saturation
        yellow_h = (sig_h + 0.167) % 1.0  # +60 degrees
        harmonious_colors['yellow'] = hsl_to_hex(yellow_h, min(1.0, sig_s * 1.2), min(0.9, sig_l * 1.2))
        
        return harmonious_colors
    
    def _calculate_tmux_colors(self, sig_choices, harmonious_colors):
        """Calculate all tmux colors including surfaces"""
        # Base colors from the theme
        base_colors = {
            'base': self.colors['background'],
            'text': self.colors['foreground'],
            'crust': self.colors['color0'],  # darkest color
        }
        
        # Surface colors based on theme brightness
        def hex_to_brightness(hex_color):
            """Calculate perceived brightness of hex color (0-255)"""
            if not hex_color.startswith('#') or len(hex_color) != 7:
                return 128
            hex_color = hex_color.lstrip('#')
            r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
            return (r * 299 + g * 587 + b * 114) / 1000
        
        base_brightness = hex_to_brightness(base_colors['base'])
        
        # Calculate surface colors based on base brightness
        if base_brightness < 128:  # Dark theme
            surface_colors = {
                'surface1': self.colors['color8'],  # bright black for dark themes
                'overlay2': self.colors['color7'],  # white for dark themes
            }
        else:  # Light theme
            surface_colors = {
                'surface1': self.colors['color7'],  # white for light themes  
                'overlay2': self.colors['color8'],  # bright black for light themes
            }
        
        # Combine all colors
        all_colors = {}
        all_colors.update(base_colors)
        all_colors.update(surface_colors)
        all_colors.update(harmonious_colors)
        
        # Add the signature color with its actual hex value
        all_colors['signature'] = self.colors[sig_choices['signature']]
        
        return all_colors
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()
        self.backup_file(output_file)
        
        # Get signature color choices from user
        sig_choices = self._get_signature_color_choice()
        if sig_choices is None:
            return None  # User cancelled
        
        # Calculate harmonious secondary colors
        harmonious_colors = self._calculate_harmonious_colors(sig_choices)
        
        # Calculate all tmux colors
        tmux_colors = self._calculate_tmux_colors(sig_choices, harmonious_colors)
        
        template = f"""# Tmux color configuration - Generated from theme
# Color definitions
red="{self.colors['color1']}"
green="{tmux_colors['green']}"
yellow="{tmux_colors['yellow']}"
blue="{self.colors['color4']}"
magenta="{self.colors['color5']}"
cyan="{self.colors['color6']}"
white="{self.colors['color7']}"
black="{self.colors['color0']}"

# Theme colors
base="{tmux_colors['base']}"
text="{tmux_colors['text']}"
crust="{tmux_colors['crust']}"
signature="{tmux_colors['signature']}"
peach="{tmux_colors['peach']}"
surface1="{tmux_colors['surface1']}"
overlay2="{tmux_colors['overlay2']}"

# Basic setup
set -g status-position top
set -g status-style "fg={tmux_colors['text']},bg={tmux_colors['base']}"
set -g base-index 1
set -g renumber-windows on

# Pane borders - using signature color for active, surface1 for inactive
set -g pane-active-border-style "fg={tmux_colors['signature']}"
set -g pane-border-style "fg={tmux_colors['surface1']}"

# Simplified status bar
set -g status-left ""
set -g status-right ""

##### Window Tabs - using overlay2 for inactive, signature for active
set -g window-status-separator " "
set -g window-status-format \\
	"#[fg={tmux_colors['overlay2']},bg=default]#[fg={tmux_colors['text']},bg={tmux_colors['overlay2']}] #I:#W #[fg={tmux_colors['overlay2']},bg=default]"

set -g window-status-current-format \\
	"#[fg={tmux_colors['signature']},bg=default]#[fg={tmux_colors['base']},bg={tmux_colors['signature']}] #I:#W #[fg={tmux_colors['signature']},bg=default]"

##### Right Status - using harmonious colors
set -g status-right '#[fg={tmux_colors['green']},bg=default]#[fg={tmux_colors['crust']},bg={tmux_colors['green']}]  #(basename "#{{pane_current_path}}") #[fg={tmux_colors['green']},bg={tmux_colors['peach']}]#[fg={tmux_colors['crust']},bg={tmux_colors['peach']}] #(timew | awk "/^ *Total/ {{print \\$NF}}") #[fg={tmux_colors['peach']},bg=default]'

##### Message Styling - using signature color for highlights
set -g message-style "fg={tmux_colors['crust']},bg={tmux_colors['signature']}"
set -g message-command-style "fg={tmux_colors['text']},bg={tmux_colors['base']}"

# Additional tmux elements that match starship
set -g mode-style "fg={tmux_colors['crust']},bg={tmux_colors['signature']}"
set -g status-justify left

# Optional: Set selection colors to match
set -g copy-mode-match-style "fg={tmux_colors['crust']},bg={tmux_colors['yellow']}"
set -g copy-mode-current-match-style "fg={tmux_colors['crust']},bg={tmux_colors['peach']}"
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        print(f"Tmux configuration generated successfully: {output_file}")
        return output_file
