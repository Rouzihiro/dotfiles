#!/bin/sh

DATA="$HOME/dashboard/data/services.json"


check_service() {

    if sv status "$1" >/dev/null 2>&1; then
        echo "running"
    else
        echo "stopped"
    fi

}



SSH=$(check_service sshd)

PIPEWIRE=$(pgrep -x pipewire >/dev/null && echo running || echo stopped)

WIREPLUMBER=$(pgrep -x wireplumber >/dev/null && echo running || echo stopped)

SWAY=$(pgrep -x sway >/dev/null && echo running || echo stopped)



cat > "$DATA" <<EOF
{
    "ssh": "$SSH",
    "pipewire": "$PIPEWIRE",
    "wireplumber": "$WIREPLUMBER",
    "sway": "$SWAY"
}
EOF
