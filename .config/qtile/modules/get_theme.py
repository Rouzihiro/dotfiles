import os
import json

# Gets colors from wallust wallpaper
def get_colors():
    with open(f"{os.path.expanduser('~')}/.cache/qtile/colors.json") as f:
        colors = json.load(f)
    
    return colors['colors']

colors = get_colors()
