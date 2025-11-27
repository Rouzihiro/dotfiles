from . import BaseGenerator

class HyprlandGenerator(BaseGenerator):
    @property
    def default_filename(self):
        return "hyprland.conf"
    
    def generate(self, output_file=None):
        output_file = output_file or self.default_filename
        self.backup_file(output_file)
        
        # Remove # from hex colors for rgba
        selection_fg = self.colors['selection_foreground'].lstrip('#')
        color4 = self.colors['color4'].lstrip('#')
        color0 = self.colors['color0'].lstrip('#')
        
        template = f"""# Kanagawa Dragon Theme for Hyprland
# Generated from: kitty.conf

general {{
    border_size = 2
    col.active_border = rgba({selection_fg}ff) rgba({color4}ff) 45deg
    col.inactive_border = rgba({color0}cc)
}}

decoration {{
    col.shadow = rgba({color0}ee)
    col.shadow_inactive = rgba({color0}66)
}}

# Client colors
client {{
    col.inactive = {self.colors['color0']}
    col.active = {self.colors['background']}
    col.urgent = {self.colors['color9']}
}}
"""
        
        with open(output_file, 'w') as f:
            f.write(template)
        return output_file
