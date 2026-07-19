from libqtile.config import Group, ScratchPad, DropDown
from settings import terminal

groups = [
    Group("1", label=""),
    Group("2"),
    Group("3"),
    Group("4"),
    Group("5"),

    Group(
        "B",
        label="󰖟",
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
