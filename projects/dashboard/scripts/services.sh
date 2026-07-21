#!/usr/bin/env bash

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$DASHBOARD_DIR/data"

cd "$DASHBOARD_DIR" || exit 1

mkdir -p "$DATA_DIR"

OUTPUT="$DATA_DIR/services.json"

# Get runit services, ignore tty consoles
SERVICES=$(sudo -n sv status /var/service/* 2>/dev/null |
    grep -v "agetty-tty" |
    sed 's#/var/service/##')

python3 - "$OUTPUT" "$SERVICES" <<'PY'
import json
import sys

output = sys.argv[1]
raw = sys.argv[2]

services = []

for line in raw.splitlines():

    parts = line.split(":", 1)

    if len(parts) != 2:
        continue

    name = parts[0].strip()
    status = parts[1].strip()

    running = status.startswith("(pid")

    services.append({
        "name": name,
        "status": "running" if running else "down"
    })


with open(output, "w") as f:
    json.dump(
        {"services": services},
        f,
        indent=2
    )
PY
