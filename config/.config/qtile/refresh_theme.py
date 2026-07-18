import importlib

import theme


def refresh_theme(qtile):
    global theme

    theme = importlib.reload(theme)

    for screen in qtile.screens:
        bar = screen.top

        if not bar:
            continue

        # Update bar
        bar.background = theme.bar_bg

        for w in bar.widgets:

            if hasattr(w, "background"):
                w.background = theme.bar_bg

            if hasattr(w, "foreground"):
                w.foreground = theme.bar_fg

            if w.name == "groupbox":
                w.active = theme.bar_fg
                w.inactive = theme.bar_inactive
                w.this_current_screen_border = theme.bar_active
                w.this_screen_border = theme.bar_highlight
                w.urgent_border = theme.bar_urgent

            # redraw widget
            try:
                w.draw()
            except Exception:
                pass

        # force bar redraw
        try:
            bar.drawer.clear(theme.bar_bg)
            bar._draw_queued = True
            bar.draw()
            bar.drawer.draw()
            bar.window.process_window_expose()
        except Exception:
            pass
