# ~/.config/qtile/keybinds.py
import os
from yaml import safe_load
from libqtile.config import Key, KeyChord
from libqtile.lazy import lazy
from libqtile.config import ScratchPad

def load_keybinds(groups):
    # Expand the path to your YAML file
    keybindings_file = os.path.expanduser("~/.config/qtile/keybindings.yaml")
    
    with open(keybindings_file, 'r') as file:
        keybindings = safe_load(file)

    # Get the mod key from YAML
    dmod = keybindings['dmod']
    variables = keybindings.get('variables', {})
    num_keys = variables.get('num_keys', [str(i) for i in range(1, 10)] + ["0"])

    keys = [
        # Group switching keys
        *[Key([dmod], num_keys[index], lazy.group[group.name].toscreen())
          for index, group in enumerate(groups) if not isinstance(group, ScratchPad)],
        *[Key([dmod, "shift"], num_keys[index], lazy.window.togroup(group.name, switch_group=True))
          for index, group in enumerate(groups) if not isinstance(group, ScratchPad)],
    ]

    # Safe command evaluation function
    def safe_eval(command):
        allowed_objects = {'lazy': lazy}
        try:
            return eval(command, {"__builtins__": None}, allowed_objects)
        except Exception as e:
            print(f"Error evaluating command: {command}")
            raise e

    # Process regular keybinds
    for keybind in keybindings.get('Keys', []):
        command = keybind['command'].format(**variables)
        keys.append(Key(
            [mod.replace('mod', 'mod') for mod in keybind['mods']],  # Normalize mod names
            keybind['key'],
            safe_eval(command)
        ))

    # Process keychords
    for keychord in keybindings.get('Keychords', []):
        submappings = [
            Key(
                [mod.replace('mod', 'mod') for mod in k['mods']],
                k['key'],
                safe_eval(k['command'].format(**variables))
            ) for k in keychord['submappings']
        ]
        keys.append(KeyChord(
            [mod.replace('mod', 'mod') for mod in keychord['mods']],
            keychord['key'],
            submappings
        ))

    return keys
