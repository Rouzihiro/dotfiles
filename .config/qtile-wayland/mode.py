import subprocess


class Mode:
    """
    A class to manage and toggle between two different
    themes for window layouts in a Qtile window manager.
    """

    def __init__(self) -> None:
        """
        Initializes the theme manager with default and "Do Not Disturb" (dnd) themes.
        """
        self.default = {
            "margin": 5,
            "border_width": 2,
            "border_focus": "#5E81AC",
            "border_normal": "#4C566A",
        }

        self.dnd = {
            "margin": 0,
            "border_width": 0,
            "border_focus": "",
            "border_normal": "",
        }

        self.current = self.default

    def toggle(self, qtile) -> None:
        """
        Toggles the current theme between default and "Do Not Disturb" (dnd),
        and updates layout settings accordingly.
        """
        self.current = self.dnd if self.current == self.default else self.default

        for group in qtile.groups:
            for layout in group.layouts:
                layout.margin = self.current["margin"]
                layout.border_width = self.current["border_width"]
                layout.border_focus = self.current["border_focus"]
                layout.border_normal = self.current["border_normal"]

        qtile.current_group.layout_all()
        qtile.cmd_hide_show_bar()

        subprocess.Popen(["swaync-client", "--toggle-dnd"])
