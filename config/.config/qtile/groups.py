from libqtile.config import Group, ScratchPad, DropDown
from settings import terminal

groups = [
    Group(str(i)) for i in range(1, 6)
] + [
    Group(
        "B",
        label="󰖟",  # Browser icon
    ),

    Group(
        "D",
        label="󰕮",
    ),

    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                terminal,
                width=0.5,
                height=0.6,
                x=0.25,
                y=0.1,
                opacity=1.0,
            ),
        ],
    ),
]
