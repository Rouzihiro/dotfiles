from libqtile.config import Group, ScratchPad, DropDown, Match

def get_groups():
    return [
        ScratchPad("scratchpad", [
            DropDown("Music", "youtube-music --ozone-platform=x11", 
                    opacity=1, height=0.5, on_focus_lost_hide=False),
            DropDown("Term", "foot",
                    opacity=1, height=0.5, on_focus_lost_hide=False),
        ]),
        *[Group(f"{i}", label="") for i in range(1, 10)],
        Group("2", matches=[Match(wm_class=["Navigator", "librewolf", "brave-browser"])]),
        Group("4", matches=[Match(wm_class="obsidian")]),
        Group("9", matches=[Match(wm_class="discord")]),
        Group("0", label="", matches=[Match(wm_class="steam")]),
    ]
