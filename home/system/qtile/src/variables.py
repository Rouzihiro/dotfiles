terminal = "foot" # guess if None
browser = "qutebrowser" # guess if None
file_manager = "thunar" # guess if None
launcher = "rofi -show drun"
powermenu = "rofi -show menu -modi 'menu:~/.local/share/rofi/scripts/rofi-power-menu --choices=shutdown/reboot/suspend/logout' -config ~/.config/rofi/power.rasi"
screenshots_path = "~/Pictures/screenshots/" # creates if doesn't exists
layouts_saved_file = "~/.config/qtile/layouts_saved.json" # creates if doesn't exists
keybindings_file = "~/.config/qtile/keybindings.yaml"
wallpapers_path = "~/Pictures/wallpapers/" # creates if doesn't exists

# Uncomment the first line for qwerty, the second for azerty
num_keys = "123456789"
# num_keys = "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "minus", "egrave", "underscore", "ccedilla", "agrave"

groups_count = 5
# groups_labels = ['●' for _ in range(groups_count)] # How the groups are named in the top bar
# Alternatives :
# groups_labels = [str(i) for i in range(1, groups_count + 1)]
groups_labels = ['I', 'II', 'III', 'IV', 'V']
