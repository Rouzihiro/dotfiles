#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

cd "$DASHBOARD_DIR" || exit 1

mkdir -p data


while true; do


    for script in "$SCRIPT_DIR"/*.sh; do

        name="$(basename "$script")"


        # Skip internal scripts
        case "$name" in
            update.sh|build-dashboard.sh|update-theme.sh)
                continue
                ;;
        esac


        if [ -x "$script" ]; then
            "$script"
        fi


    done

		./scripts/build-data-index.sh


    sleep 5


done
