#!/usr/bin/env python3

import subprocess
import time
from pathlib import Path


# ==========================================================
# Configuration
# ==========================================================

NOTIFY_LEVELS = [90, 80, 70, 60, 50, 40, 30, 20, 10]

SOUND_LEVELS = [40, 30, 20, 10]

CHARGE_NOTIFY_LEVEL = 80

CRITICAL_LEVEL = 20

REPEAT_LEVEL = 10
REPEAT_INTERVAL = 300

SOUND_DIR = Path.home() / "assets" / "sounds"


# ==========================================================


def notify(title, message, critical=False):
    subprocess.run(
        [
            "notify-send",
            "-u",
            "critical" if critical else "normal",
            title,
            message,
        ]
    )


def play_sound(path):
    if not path.exists():
        return

    players = [
        ["pw-play", str(path)],
        ["paplay", str(path)],
        ["ffplay", "-nodisp", "-autoexit", "-loglevel", "quiet", str(path)],
        ["mpg123", "-q", str(path)],
    ]

    for cmd in players:
        try:
            subprocess.Popen(
                cmd,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            return
        except FileNotFoundError:
            pass


def battery_sound(level):
    for ext in ("oga", "wav", "mp3"):
        sound = SOUND_DIR / f"battery{level}.{ext}"
        if sound.exists():
            play_sound(sound)
            return

    fallback = SOUND_DIR / "battery-low.oga"

    if fallback.exists():
        play_sound(fallback)


def charge_sound():
    for name in [
        "charge80.oga",
        "charge80.wav",
        "charge80.mp3",
    ]:
        sound = SOUND_DIR / name
        if sound.exists():
            play_sound(sound)
            return


def get_battery():
    result = subprocess.check_output(
        [
            "upower",
            "-e",
        ],
        text=True,
    )

    for line in result.splitlines():
        if "battery" in line.lower():
            return line.strip()

    raise RuntimeError("No battery found")


BATTERY = get_battery()


def read_battery():
    output = subprocess.check_output(
        [
            "upower",
            "-i",
            BATTERY,
        ],
        text=True,
    )

    data = {}

    for line in output.splitlines():

        if ":" not in line:
            continue

        key, value = line.strip().split(":", 1)

        data[key.strip()] = value.strip()

    return data


# ==========================================================
# Main
# ==========================================================


announced = set()
charge80_done = False
last_repeat = 0


def process():

    global charge80_done
    global last_repeat

    battery = read_battery()

    state = battery.get("state", "")
    percentage = battery.get("percentage", "0")

    level = int(percentage.replace("%", ""))


    # -------------------------
    # Charging
    # -------------------------

    if "charging" in state:

        announced.clear()
        last_repeat = 0

        if level >= CHARGE_NOTIFY_LEVEL and not charge80_done:

            notify(
                "Battery",
                "🔌 Battery reached 80%.\nConsider unplugging the charger.",
            )

            charge_sound()

            charge80_done = True


        if level < CHARGE_NOTIFY_LEVEL:
            charge80_done = False


    # -------------------------
    # Discharging
    # -------------------------

    elif "discharging" in state:

        charge80_done = False

        bucket = (level // 10) * 10


        if bucket in NOTIFY_LEVELS and bucket not in announced:

            emoji = (
                "🟢" if bucket >= 50 else
                "🟡" if bucket >= 40 else
                "🟠" if bucket >= 20 else
                "🔴"
            )

            notify(
                "Battery",
                f"{emoji} Battery at {bucket}%",
                critical=(bucket <= CRITICAL_LEVEL),
            )

            announced.add(bucket)

            if bucket in SOUND_LEVELS:
                battery_sound(bucket)


        if level <= REPEAT_LEVEL:

            now = time.time()

            if now - last_repeat >= REPEAT_INTERVAL:

                notify(
                    "Battery Critical",
                    f"🔴 Battery at {level}% — plug in charger!",
                    critical=True,
                )

                battery_sound(10)

                last_repeat = now



# Initial check
process()


# Listen for changes forever
monitor = subprocess.Popen(
    [
        "upower",
        "--monitor-detail",
    ],
    stdout=subprocess.PIPE,
    text=True,
)


for _ in monitor.stdout:

    try:
        process()

    except Exception as e:
        print("battery-notify:", e)
