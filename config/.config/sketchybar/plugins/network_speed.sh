#!/usr/bin/env bash
set -Eeuo pipefail

NAME="${NAME:-network_speed}"
STATE_FILE="${TMPDIR:-/tmp}/sketchybar_network_speed_${NAME}"

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

is_uint() { [[ "$1" =~ ^[0-9]+$ ]]; }

set_offline() {
    rm -f "$STATE_FILE"
    sketchybar --set "$NAME" \
        label="offline" \
        label.color="$ERROR" \
        label.font="Fira Sans:Medium:12.0" \
        label.y_offset=1 \
        icon.drawing=off \
        label.padding_left=12
}

get_default_interface() {
    route get default 2>/dev/null | awk '/interface:/{print $2; exit}'
}

get_metered_interface() {
    local default_interface="$1"
    if [[ "$default_interface" != utun* ]]; then
        printf '%s\n' "$default_interface"
        return
    fi
    scutil --nwi 2>/dev/null | awk '
        /^Network interfaces:/ {
            for (i = 3; i <= NF; i++) {
                if ($i !~ /^(utun|lo|awdl|llw)/) { print $i; exit }
            }
        }'
}

interface_is_connected() {
    local interface="$1"
    ifconfig "$interface" 2>/dev/null | awk '
        $0 ~ /flags=.*<[^>]*RUNNING[^>]*>/ { is_running = 1 }
        $1 == "inet" { has_inet = 1 }
        $1 == "status:" && $2 == "active" { is_active = 1 }
        END { exit !(has_inet && (is_active || is_running)) }'
}

get_interface_counters() {
    local interface="$1"
    netstat -ibn 2>/dev/null | awk -v interface="$interface" '
        $1 == interface && $3 ~ /^<Link#/ && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
            print $7, $10; exit }'
}

read_previous_state() {
    local expected_interface="$1"
    PREV_INTERFACE="" PREV_RX="" PREV_TX="" PREV_TIME=""
    [[ -r "$STATE_FILE" ]] || return 1
    read -r PREV_INTERFACE PREV_RX PREV_TX PREV_TIME <"$STATE_FILE" || return 1
    [[ "$PREV_INTERFACE" == "$expected_interface" ]] || return 1
    is_uint "$PREV_RX" && is_uint "$PREV_TX" && is_uint "$PREV_TIME"
}

write_state() {
    local tmp_file
    tmp_file="$(mktemp "${STATE_FILE}.XXXXXX")"
    printf '%s %s %s %s\n' "$1" "$2" "$3" "$4" >"$tmp_file"
    mv "$tmp_file" "$STATE_FILE"
}

format_megabytes_per_second() {
    awk -v bps="$1" 'BEGIN {
        mbps = bps / 1048576
        if (mbps < 0.1)       printf "0.0MB/s"
        else if (mbps >= 1000) printf "%.1fGB/s", mbps / 1024
        else                   printf "%.1fMB/s", mbps
    }'
}

interface="$(get_metered_interface "$(get_default_interface)")"
if [[ -z "$interface" ]] || ! interface_is_connected "$interface"; then
    set_offline; exit 0
fi

read -r current_rx current_tx <<<"$(get_interface_counters "$interface")"
if ! is_uint "${current_rx:-}" || ! is_uint "${current_tx:-}"; then
    set_offline; exit 0
fi

current_time="$(date +%s)"
if ! read_previous_state "$interface"; then
    write_state "$interface" "$current_rx" "$current_tx" "$current_time"
    sketchybar --set "$NAME" \
        label="↓ 0.0MB/s ↑ 0.0MB/s" \
        label.color="$FG" \
        label.font="Fira Sans:Medium:12.0" \
        label.y_offset=1 \
        icon.drawing=off \
        label.padding_left=12
    exit 0
fi

time_diff=$((current_time - PREV_TIME))
((time_diff <= 0)) && time_diff=1

rx_delta=$((current_rx - PREV_RX))
tx_delta=$((current_tx - PREV_TX))
((rx_delta < 0 || tx_delta < 0)) && rx_delta=0 && tx_delta=0

rx_rate=$((rx_delta / time_diff))
tx_rate=$((tx_delta / time_diff))

download="$(format_megabytes_per_second "$rx_rate")"
upload="$(format_megabytes_per_second "$tx_rate")"
write_state "$interface" "$current_rx" "$current_tx" "$current_time"

# Active transfer gets accent, idle gets fg_dim
if ((rx_rate >= 104858 || tx_rate >= 104858)); then
    label_color="$ACCENT"
else
    label_color="$FG_DIM"
fi

sketchybar --set "$NAME" \
    label="↓ ${download} ↑ ${upload}" \
    label.color="$label_color" \
    label.font="Fira Sans:Medium:12.0" \
    label.y_offset=1 \
    icon.drawing=off \
    label.padding_left=12
