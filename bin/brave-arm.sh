#!/bin/bash
exec /usr/bin/brave-browser --ozone-platform=wayland --enable-features=UseOzonePlatform --disable-features=WaylandOverlayDelegation "$@"

