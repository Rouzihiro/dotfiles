from .widgets import init_widgets

from libqtile import bar
from libqtile.config import Screen

screens = [
    Screen(
        top=bar.Bar(
            widgets=init_widgets(1),
            background='#0000003f',
            margin=0,
            size=30,
            opacity=0.9
        ),
        wallpaper='~/Pictures/current_wallpaper.jpg',
        wallpaper_mode="fill"
    ),
    Screen(
        # top=bar.Bar(
        #     widgets=init_widgets(1),
        #     background='#0000003f',
        #     margin=0,
        #     size=30,
        #     opacity=0.9
        # ),
        wallpaper='~/Pictures/current_wallpaper.jpg',
        wallpaper_mode="fill"
    ),
    Screen(
        top=bar.Bar(
            widgets=init_widgets(1),
            background='#0000003f',
            margin=0,
            size=30,
            opacity=0.9
        ),
        wallpaper='~/Pictures/current_wallpaper.jpg',
        wallpaper_mode="fill"
    ),
]
