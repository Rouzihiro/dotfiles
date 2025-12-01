#!/usr/bin/env python3
"""
Optimized Rofi Theme Generator - Colors Only
Combines interactive selection with WCAG-compliant color science
"""

from . import BaseGenerator
import math

class RofiGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "rofi.rasi"
    
    def hex_to_rgb(self, hex_color):
        """Convert hex color to RGB tuple"""
        if not hex_color or hex_color == 'transparent':
            return (0, 0, 0)
        hex_color = hex_color.lstrip('#')
        if len(hex_color) == 8:  # Handle alpha channel
            hex_color = hex_color[:6]
        elif len(hex_color) == 3:  # Handle shorthand
            hex_color = ''.join([c*2 for c in hex_color])
        return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
    
    def rgb_to_hex(self, rgb):
        """Convert RGB tuple to hex color"""
        return '#{:02x}{:02x}{:02x}'.format(*rgb)
    
    def get_luminance(self, rgb):
        """Calculate relative luminance (WCAG 2.1 formula)"""
        r, g, b = [x / 255.0 for x in rgb]
        
        # Convert to linear RGB
        r = r / 12.92 if r <= 0.03928 else ((r + 0.055) / 1.055) ** 2.4
        g = g / 12.92 if g <= 0.03928 else ((g + 0.055) / 1.055) ** 2.4
        b = b / 12.92 if b <= 0.03928 else ((b + 0.055) / 1.055) ** 2.4
        
        # Calculate luminance
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    
    def get_contrast_ratio(self, color1_hex, color2_hex):
        """Calculate WCAG contrast ratio between two colors"""
        rgb1 = self.hex_to_rgb(color1_hex)
        rgb2 = self.hex_to_rgb(color2_hex)
        
        l1 = self.get_luminance(rgb1)
        l2 = self.get_luminance(rgb2)
        
        # Ensure lighter color is first
        if l1 < l2:
            l1, l2 = l2, l1
        
        return (l1 + 0.05) / (l2 + 0.05)
    
    def get_best_contrast_color(self, hex_color, light_option='#fbf1c7', dark_option='#282828'):
        """Determine best contrast color using WCAG luminance threshold"""
        if not hex_color or hex_color == 'transparent':
            return light_option  # Default to light text
        
        rgb = self.hex_to_rgb(hex_color)
        luminance = self.get_luminance(rgb)
        
        # WCAG threshold for light vs dark text (0.179 = 4.5:1 contrast against white)
        return dark_option if luminance > 0.179 else light_option
    
    def adjust_color_brightness(self, hex_color, factor):
        """Adjust color brightness while preserving hue (perceptually better)"""
        if not hex_color or hex_color == 'transparent':
            return hex_color
        
        rgb = self.hex_to_rgb(hex_color)
        
        # Convert to HSL-like adjustment (preserves hue better than linear RGB)
        if factor > 0:  # Lighten
            adjusted = tuple(
                int(x + (255 - x) * factor) for x in rgb
            )
        else:  # Darken
            adjusted = tuple(
                int(x * (1 + factor)) for x in rgb  # factor is negative here
            )
        
        return self.rgb_to_hex(adjusted)
    
    def adjust_color_saturation(self, hex_color, factor):
        """Adjust color saturation"""
        if not hex_color or hex_color == 'transparent':
            return hex_color
        
        # Convert to HSL, adjust saturation, convert back
        rgb = self.hex_to_rgb(hex_color)
        r, g, b = [x/255.0 for x in rgb]
        
        max_val = max(r, g, b)
        min_val = min(r, g, b)
        
        # Calculate lightness
        l = (max_val + min_val) / 2
        
        if max_val == min_val:  # Grayscale
            return hex_color
        
        # Calculate saturation
        d = max_val - min_val
        s = d / (2 - max_val - min_val) if l > 0.5 else d / (max_val + min_val)
        
        # Adjust saturation
        s = max(0, min(1, s * (1 + factor)))
        
        # Convert back to RGB
        if l < 0.5:
            max_val = l * (1 + s)
        else:
            max_val = l + s - l * s
        min_val = 2 * l - max_val
        
        def hue_to_rgb(p, q, t):
            if t < 0: t += 1
            if t > 1: t -= 1
            if t < 1/6: return p + (q - p) * 6 * t
            if t < 1/2: return q
            if t < 2/3: return p + (q - p) * (2/3 - t) * 6
            return p
        
        # Calculate hue (simplified)
        hue = 0
        if max_val == r:
            hue = (g - b) / d + (6 if g < b else 0)
        elif max_val == g:
            hue = (b - r) / d + 2
        else:
            hue = (r - g) / d + 4
        hue /= 6
        
        # Convert back to RGB
        q = max_val if l < 0.5 else l + s - l * s
        p = 2 * l - q
        
        tr = hue + 1/3
        tg = hue
        tb = hue - 1/3
        
        r = int(hue_to_rgb(p, q, tr) * 255)
        g = int(hue_to_rgb(p, q, tg) * 255)
        b = int(hue_to_rgb(p, q, tb) * 255)
        
        return self.rgb_to_hex((r, g, b))
    
    def _get_signature_color_choice(self):
        """Interactive prompt for selecting signature colors"""
        print("\n" + "="*60)
        print("🎨 ROFI SIGNATURE COLOR SELECTION")
        print("="*60)
        
        # Available color options with descriptions
        color_options = {
            'bg': ('background', 'background'),
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
        print("\n📊 Available colors:")
        print("-" * 60)
        for key, (color_name, description) in color_options.items():
            # Special handling for 'background' key
            if key == 'bg':
                color_value = self.colors.get('background', 'N/A')
            else:
                color_value = self.colors.get(color_name, 'N/A')
            print(f"  {key:>2}. {color_name:8} = {color_value:9} ({description})")
        
        print("\n🎯 Please select colors for signature elements:")
        print("-" * 60)
        
        sig_choices = {}
        
        # Get signature background with 'bg' as default
        while True:
            choice = input("\nSelect signature background (sigbg) [default: bg - background]: ").strip()
            if not choice:
                choice = 'bg'  # Default to background
            if choice in color_options:
                sig_choices['sigbg'] = color_options[choice][0]
                break
            else:
                print("❌ Invalid choice! Please select from the options above (bg, 0-15).")
        
        # Get signature colors 1-3 with smart suggestions
        for i in range(1, 4):
            while True:
                # Avoid suggesting same as background
                if choice in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15'):
                    default = str((int(choice) + i) % 16)
                else:
                    default = str(i)  # Default to color1, color2, color3
                
                suggestion = f"[default: {default} - {color_options.get(default, ('', ''))[1]}]"
                
                choice_i = input(f"Select signature color {i} (sig{i}) {suggestion}: ").strip()
                if not choice_i:
                    choice_i = default
                
                if choice_i in color_options:
                    sig_choices[f'sig{i}'] = color_options[choice_i][0]
                    
                    # Check contrast with background for primary color
                    if i == 1:
                        bg_ref = sig_choices['sigbg']
                        sig_ref = sig_choices[f'sig{i}']
                        
                        # Get actual color values for contrast check
                        bg_color = self.colors.get(bg_ref, self.colors.get('background', '#000000'))
                        sig_color = self.colors.get(sig_ref, '#000000')
                        
                        contrast = self.get_contrast_ratio(bg_color, sig_color)
                        if contrast < 3:  # Minimum contrast warning
                            print(f"⚠️  Warning: Low contrast ({contrast:.1f}:1) with background")
                            if input("   Continue anyway? [y/N]: ").strip().lower() != 'y':
                                continue
                    
                    break
                else:
                    print("❌ Invalid choice! Please select from the options above (bg, 0-15).")
        
        # Show final selection
        print("\n✅ Signature color selection complete:")
        print("-" * 60)
        for sig_name, color_ref in sig_choices.items():
            # Special handling for 'background' key
            if color_ref == 'background':
                color_value = self.colors.get('background', 'N/A')
            else:
                color_value = self.colors.get(color_ref, 'N/A')
            print(f"  {sig_name}: @{color_ref} ({color_value})")
        
        confirm = input("\n🚀 Continue with generation? [Y/n]: ").strip().lower()
        if confirm in ('n', 'no'):
            print("Generation cancelled.")
            return None
            
        return sig_choices
    
    def _calculate_contrast_colors(self, sig_choices):
        """Calculate WCAG-compliant contrast colors for signature elements"""
        contrast_colors = {}
        
        # Get light/dark options from theme colors
        light_text = self.colors.get('color15', '#fbf1c7')  # bright white
        dark_text = self.colors.get('color0', '#282828')    # black
        
        # Calculate contrast colors for each signature element
        for key, color_ref in sig_choices.items():
            hex_color = self.colors.get(color_ref, '#000000')
            contrast_color = self.get_best_contrast_color(hex_color, light_text, dark_text)
            
            # Find which theme color is closest to the contrast color
            best_match = 'color15'  # default to bright white
            best_diff = float('inf')
            
            for theme_key in [f'color{i}' for i in range(16)]:
                if theme_key in self.colors:
                    theme_color = self.colors[theme_key]
                    if theme_color == contrast_color:
                        best_match = theme_key
                        break
            
            contrast_colors[f'on_{key}'] = best_match
        
        return contrast_colors
    
    def _calculate_surface_colors(self, sig_choices):
        """Calculate harmonious surface colors using proper color science"""
        sigbg_color_ref = sig_choices['sigbg']
        sigbg_hex = self.colors.get(sigbg_color_ref, self.colors.get('background', '#000000'))
        
        # Create surface variants with different brightness levels
        sig_surface = self.adjust_color_brightness(sigbg_hex, -0.3)  # 30% darker
        sig_surface_container = self.adjust_color_brightness(sigbg_hex, -0.15)  # 15% darker
        sig_surface_high = self.adjust_color_brightness(sigbg_hex, 0.2)  # 20% lighter
        
        # Slightly desaturate surface colors for better harmony
        sig_surface = self.adjust_color_saturation(sig_surface, -0.1)
        sig_surface_container = self.adjust_color_saturation(sig_surface_container, -0.05)
        
        # Add transparency for overlay effects
        return {
            'sig-surface': f"{sig_surface}CC",  # 80% opacity
            'sig-surface-container': f"{sig_surface_container}40",  # 25% opacity
            'sig-surface-high': f"{sig_surface_high}80",  # 50% opacity
        }
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Get signature color choices from user
        sig_choices = self._get_signature_color_choice()
        if sig_choices is None:
            return None  # User cancelled
        
        # Calculate WCAG-compliant contrast colors
        contrast_colors = self._calculate_contrast_colors(sig_choices)
        
        # Calculate harmonious surface colors
        surface_colors = self._calculate_surface_colors(sig_choices)
        
        # Build extended colors section
        extended_colors = ""
        for i in range(16, 24):
            color_key = f'color{i}'
            if color_key in self.colors:
                color_names = ['orange', 'peach', 'pink', 'lavender', 'mint', 'teal', 'olive', 'brown']
                name = color_names[i-16] if i-16 < len(color_names) else 'extended'
                extended_colors += f"    {color_key}: {self.colors[color_key]};          /* {name} */\n"
        
        # Build the complete color theme (no UI styles)
        template = f"""/*
 * Rofi Color Theme
 * Generated with WCAG-compliant color science
 */

* {{
    /* Base colors */
    background: {self.colors['background']};      /* background */
    foreground: {self.colors['foreground']};      /* foreground */
    selection-background: {self.colors['selection_background']};  /* selection bg */
    selection-foreground: {self.colors['selection_foreground']};  /* selection fg */
    border-color: {self.colors['selection_background']};    /* border */
    
    /* Signature colors - interactive selection */
    sigbg: @{sig_choices['sigbg']};           /* signature background */
    sig1: @{sig_choices['sig1']};            /* signature color 1 */
    sig2: @{sig_choices['sig2']};            /* signature color 2 */
    sig3: @{sig_choices['sig3']};            /* signature color 3 */

    /* WCAG-compliant contrast colors */
    on-sigbg: @{contrast_colors.get('on_sigbg', 'color15')};    /* text on signature background */
    on-sig1: @{contrast_colors.get('on_sig1', 'color0')};      /* text on signature color 1 */
    on-sig2: @{contrast_colors.get('on_sig2', 'color0')};      /* text on signature color 2 */
    on-sig3: @{contrast_colors.get('on_sig3', 'color0')};      /* text on signature color 3 */

    /* Harmonious surface colors with transparency */
    sig-surface: {surface_colors['sig-surface']};        /* surface with 80% opacity */
    sig-surface-container: {surface_colors['sig-surface-container']};  /* surface container 25% */
    sig-surface-high: {surface_colors['sig-surface-high']};       /* high surface 50% */

    /* Text color reference */
    text-color: @on-sigbg;

    /* Standard 16-color palette */
    color0: {self.colors['color0']};          /* black */
    color1: {self.colors['color1']};          /* red */
    color2: {self.colors['color2']};          /* green */
    color3: {self.colors['color3']};          /* yellow */
    color4: {self.colors['color4']};          /* blue */
    color5: {self.colors['color5']};          /* magenta */
    color6: {self.colors['color6']};          /* cyan */
    color7: {self.colors['color7']};          /* white */

    color8: {self.colors['color8']};          /* bright black */
    color9: {self.colors['color9']};          /* bright red */
    color10: {self.colors['color10']};         /* bright green */
    color11: {self.colors['color11']};         /* bright yellow */
    color12: {self.colors['color12']};         /* bright blue */
    color13: {self.colors['color13']};         /* bright magenta */
    color14: {self.colors['color14']};         /* bright cyan */
    color15: {self.colors['color15']};         /* bright white */

    /* Extended colors (if present in theme) */
{extended_colors}}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        
        print(f"\n{'='*60}")
        print(f"✅ Rofi color theme generated successfully: {output_file}")
        print(f"{'='*60}")
        
        # Show summary
        print("\n🎨 Color Scheme Summary:")
        print("-" * 40)
        print(f"  Background: @{sig_choices['sigbg']}")
        print(f"  Primary: @{sig_choices['sig1']}")
        print(f"  Secondary: @{sig_choices['sig2']}")
        print(f"  Accent: @{sig_choices['sig3']}")
        
        # Check contrast ratios
        bg_color = self.colors.get(sig_choices['sigbg'], self.colors.get('background', '#000000'))
        sig1_color = self.colors.get(sig_choices['sig1'], '#000000')
        contrast = self.get_contrast_ratio(bg_color, sig1_color)
        
        print(f"\n📊 Contrast Check:")
        print(f"  Background ↔ Primary: {contrast:.1f}:1")
        
        if contrast >= 4.5:
            print("  ✅ WCAG AA compliant (good contrast)")
        elif contrast >= 3:
            print("  ⚠️  Minimum contrast (acceptable)")
        else:
            print("  ❌ Low contrast (consider different colors)")
        
        print("\n💡 Tip: Import this file into your existing rofi config using '@import'")
        print("   Example: @import \"rofi.rasi\"")
        
        return output_file
