from libqtile.config import Group, ScratchPad, DropDown, Match

# Groups configuration
def create_groups() -> list:
    """Create and return workspace groups."""

    from config import APPS

    scratchpad = ScratchPad(
        "scratchpad",
        [
            DropDown(
                "Music",
                f"{APPS['terminal'].split('client')[0]} -e rmpc",
                opacity=1,
                height=0.5,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "Term", 
                APPS['terminal'].split('client')[0],
                opacity=1,
                height=0.5,
                on_focus_lost_hide=False,
            ),
        ],
    )
    
    # Define group matches
    group_matches = {
        "2": [
            Match(wm_class="firefox"),
            Match(wm_class="vivaldi-stable"), 
            Match(wm_class="librewolf"),
            Match(wm_class="brave-browser"),
        ],
        "4": [Match(wm_class="obsidian")],
        "9": [Match(wm_class="discord")],
        "0": [Match(wm_class="steam")],
    }
    
    # Create numbered groups
    numbered_groups = []
    for i in range(1, 10):
        group_id = str(i)
        label = "" if group_id != "0" else ""
        matches = group_matches.get(group_id, [])
        numbered_groups.append(Group(group_id, label=label, matches=matches))
    
    # Add group 0 (steam)
    numbered_groups.append(Group("0", label="", matches=group_matches["0"]))
    
    return [scratchpad] + numbered_groups
