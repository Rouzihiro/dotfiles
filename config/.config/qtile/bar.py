import subprocess

from libqtile import bar, widget

import theme


SCRIPT_DIR = "/home/rey/scripts/bar"
STATUS_DIR = "/home/rey/scripts/statusbar"


def _defaults(**kwargs):
    base = {
        "font": theme.font,
        "fontsize": theme.font_size,
        "padding": 8,
        "background": theme.bar_bg,
        "foreground": theme.bar_fg,
    }

    base.update(kwargs)
    return base


def script_widget(path, interval, color=None):
    if color is None:
        color = theme.bar_fg

    return widget.GenPollText(
        func=lambda: subprocess.check_output(
            [path],
            text=True,
        ).strip(),
        update_interval=interval,
        **_defaults(
            foreground=color,
        ),
    )


def spacer(width=8):
    return widget.Sep(
        size=width,
        linewidth=0,
        padding=0,
        background=theme.bar_bg,
    )


def build_bar():

    return bar.Bar(
        [

            #
            # Workspaces
            #
            widget.GroupBox(
                **_defaults(),

                borderwidth=0,

                active=theme.bar_fg,
                inactive=theme.bar_inactive,

                this_current_screen_border=theme.bar_active,
                this_screen_border=theme.bar_highlight,

                urgent_border=theme.bar_urgent,

                highlight_method="line",

                padding_x=10,
                padding_y=4,

                margin_x=5,

                disable_drag=True,
            ),


            spacer(15),


            #
            # Active window title
            #
            widget.WindowName(
                **_defaults(
                    foreground=theme.bar_fg,
                ),
                max_chars=60,
            ),


            widget.Spacer(),


            #
            # Weather
            #
            script_widget(
                f"{SCRIPT_DIR}/weather-short",
                60,
                theme.bar_fg,
            ),


            spacer(),


            #
            # Bandwidth
            #
            script_widget(
                f"{SCRIPT_DIR}/bandwidth",
                1,
                theme.bar_highlight,
            ),


            spacer(),


            #
            # Disk
            #
            widget.GenPollText(
                func=lambda: subprocess.check_output(
                    [
                        "bash",
                        "-c",
                        "df -h / | awk 'NR==2 {print $3 \"/\" $2}'",
                    ],
                    text=True,
                ).strip(),
                update_interval=30,
                **_defaults(
                    foreground=theme.bar_active,
                ),
            ),


            spacer(),


            #
            # Memory
            #
            script_widget(
                f"{SCRIPT_DIR}/memory",
                2,
                theme.bar_active,
            ),


            spacer(),


            #
            # CPU
            #
            script_widget(
                f"{SCRIPT_DIR}/cpu-usage",
                2,
                theme.bar_highlight,
            ),


            spacer(),


            #
            # Wifi
            #
            script_widget(
                f"{SCRIPT_DIR}/wifi-status",
                30,
                theme.bar_fg,
            ),


            spacer(),


            #
            # Volume
            #
            script_widget(
                f"{STATUS_DIR}/sb-volume",
                1,
                theme.bar_active,
            ),


            spacer(),


            #
            # Power profile
            #
            script_widget(
                f"{SCRIPT_DIR}/power-wrapper",
                5,
                theme.bar_fg,
            ),


            spacer(),


            #
            # Brightness
            #
            script_widget(
                f"{STATUS_DIR}/sb-brightness",
                5,
                theme.bar_fg,
            ),


            spacer(),


            #
            # Time
            #
            script_widget(
                f"{SCRIPT_DIR}/timer",
                1,
                theme.bar_active,
            ),


            spacer(),


            #
            # Keyboard
            #
            script_widget(
                f"{SCRIPT_DIR}/kb-layout",
                2,
                theme.bar_highlight,
            ),


            spacer(),


            #
            # Battery
            #
            script_widget(
                f"{SCRIPT_DIR}/battery",
                30,
                theme.bar_highlight,
            ),

        ],

        theme.bar_size + 20,

        background=theme.bar_bg,
    )
