"""
groups.py — workspaces + the ScratchPad group used by $mod+p / $mod+alt+p.
Add your real groups below; only the scratchpad is wired up to match your
sway keybinds.
"""

from libqtile.config import Group, ScratchPad, DropDown

from settings import terminal

groups = [
    Group(str(i)) for i in range(1, 10)
] + [
    ScratchPad("scratchpad", [
        DropDown(
            "term",
            terminal,
            width=0.5, height=0.6,
            x=0.25, y=0.1,
            opacity=1.0,
        ),
    ]),
]
