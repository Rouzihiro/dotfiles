#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT="$DASHBOARD_DIR/data/duf.json"

CONTENT=$(
    duf \
        --hide special \
        --output mountpoint,size,used,avail,usage \
    | perl -pe 's/\e\[[0-9;]*[A-Za-z]//g'
)

python3 - "$OUTPUT" "$CONTENT" <<'PY'
import json
import sys

output = sys.argv[1]
content = sys.argv[2]

with open(output, "w") as f:
    json.dump(
        {
            "duf-output": content
        },
        f,
        indent=4
    )
PY
