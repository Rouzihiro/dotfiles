# battery-notify

A lightweight battery notification daemon for Linux desktops.

`battery-notify` listens directly to Linux kernel battery events via **netlink** (`NETLINK_KOBJECT_UEVENT`) and sends desktop notifications without polling or requiring a full desktop power manager.

It is designed for minimalist Wayland/X11 environments such as **Qtile**, **Sway**, **Hyprland**, **dwm**, **i3**, and similar window managers.

## Features

* Event-driven (no polling)
* Automatic battery detection (`BAT0`, `BAT1`, ...)
* Battery notifications every 10%

  * 90%
  * 80%
  * 70%
  * ...
  * 10%
* Charging reminder at 80%
* Critical notifications below 20%
* Optional sound alerts for low battery
* Repeat warning below 10%
* Very low CPU usage
* Tiny memory footprint
* No dependency on `upower` or desktop power managers

---

## Requirements

### Runtime

* Linux
* A notification daemon (e.g. `mako`, `dunst`)
* `notify-send` / `libnotify`

### Build

* GCC
* Make
* pkg-config
* libnotify development package

On Void Linux:

```sh
sudo xbps-install gcc make pkg-config libnotify-devel
```

---

## Building

Compile:

```sh
make
```

Install to `~/bin`:

```sh
make install
```

Run without installing:

```sh
make run
```

Remove build artifacts:

```sh
make clean
```

Uninstall:

```sh
make uninstall
```

---

## Installation

Start the daemon manually:

```sh
~/bin/battery-notify
```

Or launch it automatically from your window manager.

Example for Qtile:

```python
subprocess.Popen([
    "sh",
    "-c",
    "pgrep -f battery-notify >/dev/null || ~/bin/battery-notify",
])
```

---

## Sound files

Low battery sounds are searched in:

```text
~/assets/sounds/
```

Example layout:

```text
battery40.oga
battery30.oga
battery20.oga
battery10.oga
```

If a matching file exists, it is played when that battery level is reached.

---

## How it works

Unlike many battery monitors that periodically poll `/sys/class/power_supply`, `battery-notify` listens for Linux kernel **uevents** over a netlink socket.

When the kernel reports a battery state change:

1. Read the battery capacity and charging state.
2. Determine whether a notification should be sent.
3. Send a desktop notification.
4. Optionally play a sound.

No timers or polling loops are required.

---

## Why?

Many lightweight window managers intentionally avoid including a power management daemon.

`battery-notify` provides useful battery reminders without installing a full desktop environment or power manager.

---

## License

MIT License.
