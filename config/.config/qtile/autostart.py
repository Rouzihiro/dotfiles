import os
import subprocess


def autostart():
    script = os.path.expanduser(
        "~/.config/qtile/autostart.sh"
    )

    subprocess.Popen([script])
