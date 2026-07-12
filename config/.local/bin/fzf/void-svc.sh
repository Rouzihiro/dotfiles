#!/bin/bash
# void-svc: activate/deactivate runit services via fzf multi-select
set -euo pipefail

SV_DIR="/etc/sv"
SERVICE_DIR="/var/service"

mode=$(printf "activate\ndeactivate" | fzf --prompt="Action> " --height=10 --header="What do you want to do?")
[ -z "${mode:-}" ] && exit 0

if [ "$mode" = "activate" ]; then
    mapfile -t choices < <(
        comm -23 <(ls "$SV_DIR" | sort) <(ls "$SERVICE_DIR" | sort) \
        | fzf --multi --prompt="Activate> " --header="TAB to multi-select, ENTER to confirm"
    )
    [ "${#choices[@]}" -eq 0 ] && { echo "nothing selected"; exit 0; }
    for svc in "${choices[@]}"; do
        sudo ln -sf "$SV_DIR/$svc" "$SERVICE_DIR/$svc"
        echo "activated: $svc"
    done

elif [ "$mode" = "deactivate" ]; then
    mapfile -t choices < <(
        ls "$SERVICE_DIR" | sort \
        | fzf --multi --prompt="Deactivate> " --header="TAB to multi-select, ENTER to confirm"
    )
    [ "${#choices[@]}" -eq 0 ] && { echo "nothing selected"; exit 0; }
    for svc in "${choices[@]}"; do
        sudo sv down "$svc" 2>/dev/null || true
        sudo rm -f "$SERVICE_DIR/$svc"
        echo "deactivated: $svc"
    done
fi
