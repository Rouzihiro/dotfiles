terminal = None # guess if None
browser = None # guess if None
file_manager = None # guess if None
launcher = "rofi -show drun"
powermenu = "rofi -show menu -modi 'menu:~/.local/share/rofi/scripts/rofi-power-menu --choices=shutdown/reboot/suspend/logout' -config ~/.config/rofi/power.rasi"
screenshots_path = "~/Pictures/screenshots/" # creates if doesn't exists
layouts_saved_file = "~/.config/qtile/layouts_saved.json" # creates if doesn't exists
keybindings_file = "~/.config/qtile/keybindings.yaml"
wallpapers_path = "~/Pictures/wallpapers/" # creates if doesn't exists

autostarts = [
    "~/.config/qtile/src/autostart.sh",
    "~/.autostart.sh"
]

floating_apps = [
    #'nitrogen',
    #'loupe'
]

# Uncomment the first line for qwerty, the second for azerty
# num_keys = "123456789"
# num_keys = "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "minus", "egrave", "underscore", "ccedilla", "agrave"
