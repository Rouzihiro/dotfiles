#!/usr/bin/env python3

import os
import subprocess
import threading
import time

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("WebKit2", "4.1")

from gi.repository import Gtk, WebKit2


DASHBOARD_DIR = os.path.dirname(os.path.abspath(__file__))
URL = "http://localhost:8080"


class Dashboard(Gtk.Window):

    def __init__(self):
        super().__init__()

        self.set_title("dashboard")

        # Default dashboard size
        self.set_default_size(1200, 800)

        # Center window
        self.set_position(Gtk.WindowPosition.CENTER)

        # Web view
        self.webview = WebKit2.WebView()

        self.webview.load_uri(URL)

        self.add(self.webview)

        self.connect(
            "destroy",
            Gtk.main_quit,
        )


def start_server():
    """
    Start dashboard HTTP server.
    """

    subprocess.Popen(
        [
            "python3",
            "-m",
            "http.server",
            "8080",
        ],
        cwd=DASHBOARD_DIR,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def start_updates():
    """
    Start dashboard data updater.
    """

    update_script = os.path.join(
        DASHBOARD_DIR,
        "scripts",
        "update.sh",
    )

    if os.path.exists(update_script):

        subprocess.Popen(
            [update_script],
            cwd=DASHBOARD_DIR,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def main():

    # Start backend services
    threading.Thread(
        target=start_server,
        daemon=True,
    ).start()

    threading.Thread(
        target=start_updates,
        daemon=True,
    ).start()

    # Give server time to start
    time.sleep(1)

    Gtk.init([])

    window = Dashboard()

    window.show_all()

    Gtk.main()


if __name__ == "__main__":
    main()
