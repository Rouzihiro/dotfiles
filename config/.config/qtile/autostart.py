import os
import subprocess


def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")

    if not os.path.exists(script):
        return

    if not os.access(script, os.X_OK):
        return

    subprocess.Popen(
        [script],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
