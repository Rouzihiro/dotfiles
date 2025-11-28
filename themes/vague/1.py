#!/usr/bin/env python3
"""
Convert rofi.rasi color scheme to improved version with proper contrast
"""

import re
import os
import math

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple"""
    hex_color = hex_color.lstrip('#')
    if len(hex_color) == 8:  # Handle alpha channel
        hex_color = hex_color[:6]
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb):
    """Convert RGB tuple to hex color"""
    return '#{:02x}{:02x}{:02x}'.format(*rgb)

def get_luminance(rgb):
    """Calculate relative luminance (WCAG formula)"""
    r, g, b = [x / 255.0 for x in rgb]
    
    r = r / 12.92 if r <= 0.03928 else ((r + 0.055) / 1.055) ** 2.4
    g = g / 12.92 if g <= 0.03928 else ((g + 0.055) / 1.055) ** 2.4
    b = b / 12.92 if b <= 0.03928 else ((b + 0.055) / 1.055) ** 2.4
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def get_contrast_color(hex_color):
    """Determine best contrast color (light or dark text)"""
    if not hex_color or hex_color == 'transparent':
        return '#fbf1c7'  # Default to light text
    
    rgb = hex_to_rgb(hex_color)
    luminance = get_luminance(rgb)
    
    # Use luminance threshold to determine contrast color
    return '#282828' if luminance > 0.179 else '#fbf1c7'

def darken_color(hex_color, factor=0.2):
    """Darken a color by given factor"""
    rgb = hex_to_rgb(hex_color)
    darkened = tuple(max(0, int(x * (1 - factor))) for x in rgb)
    return rgb_to_hex(darkened)

def lighten_color(hex_color, factor=0.15):
    """Lighten a color by given factor"""
    rgb = hex_to_rgb(hex_color)
    lightened = tuple(min(255, int(x + (255 - x) * factor)) for x in rgb)
    return rgb_to_hex(lightened)

def parse_rofi_colors(filename):
    """Parse color definitions from rofi.rasi file"""
    colors = {}
    
    with open(filename, 'r') as f:
        content = f.read()
    
    # Find all color definitions in the * { } section
    color_pattern = r'(\w+):\s*([^;]+);'
    matches = re.findall(color_pattern, content)
    
    for key, value in matches:
        value = value.strip()
        # Handle color values (hex, @variables, etc.)
        if value.startswith('#') or value.startswith('@'):
            colors[key] = value
    
    return colors

def generate_improved_colors(original_colors):
    """Generate improved color scheme with proper contrast"""
    improved = original_colors.copy()
    
    # Extract signature colors
    sig_colors = {}
    for key in ['sigbg', 'sig1', 'sig2', 'sig3']:
        if key in original_colors:
            sig_colors[key] = original_colors[key]
    
    # Resolve @variables to actual hex values
    resolved_colors = {}
    for key, value in sig_colors.items():
        if value.startswith('@'):
            ref_key = value[1:]
            if ref_key in original_colors and original_colors[ref_key].startswith('#'):
                resolved_colors[key] = original_colors[ref_key]
            else:
                resolved_colors[key] = '#3c3836'  # fallback
        else:
            resolved_colors[key] = value
    
    # Generate on-colors
    for sig_key in ['sigbg', 'sig1', 'sig2', 'sig3']:
        if sig_key in resolved_colors:
            on_key = f'on-{sig_key}'
            improved[on_key] = get_contrast_color(resolved_colors[sig_key])
    
    # Generate surface variants based on sigbg
    if 'sigbg' in resolved_colors:
        sigbg = resolved_colors['sigbg']
        improved['sig-surface'] = darken_color(sigbg, 0.3)
        improved['sig-surface-container'] = darken_color(sigbg, 0.1)
        improved['sig-surface-high'] = lighten_color(sigbg, 0.2)
    
    return improved

def create_improved_rofi_file(input_file, output_file):
    """Create improved rofi.rasi file"""
    
    # Read original file
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Parse original colors
    original_colors = parse_rofi_colors(input_file)
    
    # Generate improved colors
    improved_colors = generate_improved_colors(original_colors)
    
    # Replace or add color definitions
    new_content = content
    
    # Find the * { section and add new color definitions
    star_section_pattern = r'(\*\s*\{[^}]*)'
    
    # Create new color definitions string
    new_color_defs = []
    for key in ['on-sigbg', 'on-sig1', 'on-sig2', 'on-sig3', 
                'sig-surface', 'sig-surface-container', 'sig-surface-high']:
        if key in improved_colors:
            new_color_defs.append(f'    {key}: {improved_colors[key]};')
    
    new_colors_str = '\n'.join(new_color_defs)
    
    # Insert new color definitions before the closing } of * {
    if new_colors_str:
        new_content = re.sub(
            r'(\*\s*\{[^}]*)(\})',
            r'\1\n' + new_colors_str + r'\n\2',
            new_content
        )
    
    # Update element styles to use new colors
    style_updates = {
        'element selected': {
            'background-color': '@sig1',
            'text-color': '@on-sig1'
        },
        'element selected.active': {
            'background-color': '@sig2', 
            'text-color': '@on-sig2'
        },
        'element': {
            'background-color': '@sig-surface-high',
            'text-color': '@on-sigbg'
        },
        'window': {
            'background-color': '@sigbg',
            'border-color': '@sig1'
        },
        '*': {
            'text-color': '@on-sigbg'
        }
    }
    
    for selector, properties in style_updates.items():
        for prop, value in properties.items():
            pattern = rf'({re.escape(selector)}\s*{{[^}}]*){re.escape(prop)}:\s*[^;]+;'
            replacement = rf'\1{prop}: {value};'
            
            if re.search(pattern, new_content):
                new_content = re.sub(pattern, replacement, new_content)
            else:
                # Add the property if it doesn't exist
                new_content = re.sub(
                    rf'({re.escape(selector)}\s*{{)([^}}]*)(}})',
                    rf'\1\2    {prop}: {value};\n\3',
                    new_content
                )
    
    # Write improved file
    with open(output_file, 'w') as f:
        f.write(new_content)
    
    print(f"✅ Improved rofi theme generated: {output_file}")
    print("🎨 New colors added:")
    for key in ['on-sigbg', 'on-sig1', 'on-sig2', 'on-sig3']:
        if key in improved_colors:
            print(f"   {key}: {improved_colors[key]}")

if __name__ == "__main__":
    input_file = "rofi.rasi"
    output_file = "rofi2.rasi"
    
    if not os.path.exists(input_file):
        print(f"❌ {input_file} not found in current directory")
        exit(1)
    
    try:
        create_improved_rofi_file(input_file, output_file)
        print(f"\n🎉 Success! Open {output_file} to see your improved theme.")
    except Exception as e:
        print(f"❌ Error: {e}")
