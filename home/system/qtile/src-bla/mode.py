class Mode:
    def __init__(self):
        self.current = {
            "border_width": 2,
            "margin": 8,
            "border_focus": "#81A1C1",
            "border_normal": "#4C566A"
        }

    def toggle(self, qtile):
        if self.current["border_width"] == 2:
            self.current.update({
                "border_width": 0,
                "margin": 0
            })
        else:
            self.current.update({
                "border_width": 2,
                "margin": 8
            })
        qtile.reload_config()
