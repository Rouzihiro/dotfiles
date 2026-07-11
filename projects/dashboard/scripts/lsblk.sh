#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

mkdir -p "$DASHBOARD_DIR/data"


lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS \
    | sed 's/$/<br>/' \
    > "$DASHBOARD_DIR/data/lsblk.txt"


cat > "$DASHBOARD_DIR/data/lsblk.json" <<EOF
{
    "lsblk-output": "$(sed ':a;N;$!ba;s/\n/\\n/g;s/"/\\"/g' "$DASHBOARD_DIR/data/lsblk.txt")"
}
EOF
