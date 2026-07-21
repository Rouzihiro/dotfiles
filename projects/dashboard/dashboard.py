#!/usr/bin/env python3

import os
import subprocess
import sys
import threading
import time

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("WebKit2", "4.1")

from gi.repository import Gtk, WebKit2
from libqtile.command.client import InteractiveCommandClient


DASHBOARD_DIR = os.path.dirname(os.path.abspath(__file__))
URL = "http://localhost:8080"

QTILE_CONFIG_DIR = os.path.expanduser("~/.config/qtile")
sys.path.insert(0, QTILE_CONFIG_DIR)
from settings import browser  # e.g. "firefox"


def find_browser_group():
    """
    Look through currently open windows for one matching `browser`'s
    wm_class, and return the name of the group it's on (or None if
    the browser isn't open anywhere).
    """
    try:
        client = InteractiveCommandClient()
        for win in client.windows():
            wm_class = win.get("wm_class") or []
            if any(browser.lower() in c.lower() for c in wm_class):
                return win.get("group")
    except Exception:
        pass
    return None


def open_in_browser(uri):
    group = find_browser_group()

    subprocess.Popen([browser, uri])

    if group:
        try:
            InteractiveCommandClient().group[group].toscreen()
        except Exception:
            pass


class Dashboard(Gtk.Window):
    def __init__(self):
        super().__init__()

        self.set_title("dashboard")
        self.set_default_size(1200, 800)
        self.set_position(Gtk.WindowPosition.CENTER)

        self.webview = WebKit2.WebView()
        self.webview.connect("decide-policy", self.on_decide_policy)
        self.webview.load_uri(URL)

        self.add(self.webview)

        self.connect("destroy", Gtk.main_quit)

    def on_decide_policy(self, webview, decision, decision_type):
        if decision_type == WebKit2.PolicyDecisionType.NEW_WINDOW_ACTION:
            uri = decision.get_navigation_action().get_request().get_uri()
            decision.ignore()
            open_in_browser(uri)
            return True
        return False


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
