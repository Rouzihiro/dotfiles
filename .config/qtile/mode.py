from libqtile.log_utils import logger
from theme import colors
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

        logger.info("Initializing Mode theme manager with default and DND themes.")

        self.default = {
            "margin": 5,
            "border_width": 2,
            "border_focus": colors["base10"],
            "border_normal": colors["base03"],
            "single_border_width": 2,
            "single_border_margin": 5,
        }

        self.dnd = {
            "margin": 0,
            "border_width": 0,
            "border_focus": "",
            "border_normal": "",
            "single_border_width": 0,
            "single_border_margin": 0,
        }

        self.current = self.default

    def toggle(self, qtile) -> None:
        """
        Toggles the current theme between default and "Do Not Disturb" (dnd),
        and updates layout settings accordingly.
        """
        new_theme = "dnd" if self.current == self.default else "default"
        logger.info(f"Toggling theme. Switching to: {new_theme}")

        self.current = self.dnd if self.current == self.default else self.default
        logger.debug(f"New theme settings: {self.current}")

        for group in qtile.groups:
            for layout in group.layouts:
                layout.margin = self.current["margin"]
                layout.border_width = self.current["border_width"]
                layout.border_focus = self.current["border_focus"]
                layout.border_normal = self.current["border_normal"]

        qtile.current_group.layout_all()
        qtile.cmd_hide_show_bar()

        try:
            subprocess.Popen(["swaync-client", "--toggle-dnd"])
            logger.info("Toggled Do Not Disturb mode via swaync-client.")
        except Exception as e:
            logger.warning(f"Failed to toggle DND mode: {e}")

mode = Mode()
