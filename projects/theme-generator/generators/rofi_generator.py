from . import BaseGenerator

class RofiGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "rofi.rasi"
    
    def _get_signature_color_choice(self):
        """Interactive prompt for selecting signature colors"""
        print("\n" + "="*50)
        print("ROFI SIGNATURE COLOR SELECTION")
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
        
        print("\nPlease select colors for signature elements:")
        print("-" * 40)
        
        sig_choices = {}
        
        # Get signature background
        while True:
            choice = input("\nSelect signature background (sigbg) [default: 8 - bright black]: ").strip()
            if not choice:
                choice = '8'  # Default to bright black
            if choice in color_options:
                sig_choices['sigbg'] = color_options[choice][0]
                break
            else:
                print("Invalid choice! Please select a number from the list above.")
        
        # Get signature colors 1-3
        for i in range(1, 4):
            while True:
                choice = input(f"Select signature color {i} (sig{i}) [default: {i} - {color_options[str(i)][1]}]: ").strip()
                if not choice:
                    choice = str(i)  # Default to matching number
                if choice in color_options:
                    sig_choices[f'sig{i}'] = color_options[choice][0]
                    break
                else:
                    print("Invalid choice! Please select a number from the list above.")
        
        # Show final selection
        print("\nSignature color selection complete:")
        print("-" * 40)
        for sig_name, color_ref in sig_choices.items():
            color_value = self.colors.get(color_ref, 'N/A')
            print(f"  {sig_name}: @{color_ref} ({color_value})")
        
        confirm = input("\nContinue with generation? [Y/n]: ").strip().lower()
        if confirm in ('n', 'no'):
            print("Generation cancelled.")
            return None
            
        return sig_choices
    
    def _calculate_contrast_colors(self, sig_choices):
        """Calculate contrast colors for signature elements"""
        # Simple logic to determine good contrast colors
        contrast_colors = {}
        
        # For dark backgrounds, use light text; for light backgrounds, use dark text
        bg_color = self.colors.get(sig_choices['sigbg'], '#000000')
        # Simple brightness check
        if bg_color.startswith('#'):
            # Convert hex to approximate brightness
            hex_color = bg_color.lstrip('#')
            if len(hex_color) == 6:
                r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
                brightness = (r * 299 + g * 587 + b * 114) / 1000
                # If background is dark, use light text; if light, use dark text
                if brightness < 128:
                    contrast_colors['on_sigbg'] = 'color15'  # bright white
                else:
                    contrast_colors['on_sigbg'] = 'color0'   # black
        
        # For signature colors 1-3, use appropriate contrast
        for i in range(1, 4):
            sig_color = self.colors.get(sig_choices[f'sig{i}'], '#000000')
            if sig_color.startswith('#'):
                hex_color = sig_color.lstrip('#')
                if len(hex_color) == 6:
                    r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
                    brightness = (r * 299 + g * 587 + b * 114) / 1000
                    if brightness < 128:
                        contrast_colors[f'on_sig{i}'] = 'color15'  # bright white
                    else:
                        contrast_colors[f'on_sig{i}'] = 'color0'   # black
        
        return contrast_colors
    
    def _calculate_surface_colors(self, sig_choices):
        """Simple brightness-based surface color calculation"""
        sigbg_color_ref = sig_choices['sigbg']
        sigbg_hex = self.colors.get(sigbg_color_ref, '#000000')
        
        def hex_to_brightness(hex_color):
            """Calculate perceived brightness of hex color (0-255)"""
            if not hex_color.startswith('#') or len(hex_color) != 7:
                return 128
            hex_color = hex_color.lstrip('#')
            r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
            return (r * 299 + g * 587 + b * 114) / 1000
        
        def adjust_hex_brightness(hex_color, target_brightness):
            """Adjust hex color to target brightness"""
            if not hex_color.startswith('#') or len(hex_color) != 7:
                return hex_color
                
            current_brightness = hex_to_brightness(hex_color)
            if current_brightness == 0:
                return f"#{int(target_brightness):02x}{int(target_brightness):02x}{int(target_brightness):02x}"
                
            ratio = target_brightness / current_brightness
            
            hex_color = hex_color.lstrip('#')
            r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
            
            r = int(max(0, min(255, r * ratio)))
            g = int(max(0, min(255, g * ratio)))
            b = int(max(0, min(255, b * ratio)))
            
            return f"#{r:02x}{g:02x}{b:02x}"
        
        base_brightness = hex_to_brightness(sigbg_hex)
        
        # Create harmonious brightness levels (like Gruvbox)
        sig_surface = adjust_hex_brightness(sigbg_hex, max(10, base_brightness * 0.6))      # Darker
        sig_surface_container = adjust_hex_brightness(sigbg_hex, base_brightness * 0.9)     # Slightly darker
        sig_surface_high = adjust_hex_brightness(sigbg_hex, min(200, base_brightness * 1.8)) # Much lighter
        
        return {
            'sig-surface': sig_surface + 'CC',
            'sig-surface-container': sig_surface_container + '40', 
            'sig-surface-high': sig_surface_high + '80',
        }
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Get signature color choices from user
        sig_choices = self._get_signature_color_choice()
        if sig_choices is None:
            return None  # User cancelled
        
        # Calculate contrast colors
        contrast_colors = self._calculate_contrast_colors(sig_choices)
        
        # Calculate harmonious surface colors
        surface_colors = self._calculate_surface_colors(sig_choices)
        
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
    
    /* Signature colors - customized selection */
    sigbg: @{sig_choices['sigbg']};           /* signature background */
    sig1: @{sig_choices['sig1']};            /* signature color 1 */
    sig2: @{sig_choices['sig2']};            /* signature color 2 */
    sig3: @{sig_choices['sig3']};            /* signature color 3 */

    /* Contrast colors for signature elements */
    on-sigbg: @{contrast_colors.get('on_sigbg', 'color15')};    /* text on signature background */
    on-sig1: @{contrast_colors.get('on_sig1', 'color0')};      /* text on signature color 1 */
    on-sig2: @{contrast_colors.get('on_sig2', 'color0')};      /* text on signature color 2 */
    on-sig3: @{contrast_colors.get('on_sig3', 'color0')};      /* text on signature color 3 */

    /* Harmonious surface colors for menu elements */
    sig-surface: {surface_colors['sig-surface']};        /* surface with transparency */
    sig-surface-container: {surface_colors['sig-surface-container']};  /* surface container */
    sig-surface-high: {surface_colors['sig-surface-high']};       /* high surface */

    /* Text color reference */
    text-color: @on-sigbg;

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
        print(f"Rofi theme generated successfully: {output_file}")
        return output_file
