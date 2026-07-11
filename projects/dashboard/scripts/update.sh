#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

cd "$DASHBOARD_DIR" || exit 1

mkdir -p data

while true; do

    ./scripts/system.sh
    ./scripts/network.sh
    ./scripts/git.sh
    ./scripts/hardware.sh
    ./scripts/services.sh
 		./scripts/git-tree.sh

    sleep 5

done
