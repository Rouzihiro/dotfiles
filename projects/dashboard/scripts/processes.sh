#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT="$DASHBOARD_DIR/data/processes.json"

CONTENT=$(
ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head -10
)

python3 - "$OUTPUT" "$CONTENT" <<'PY'
import json
import sys

output = sys.argv[1]
content = sys.argv[2]

with open(output, "w") as f:
    json.dump(
        {
            "processes-output": content
        },
        f,
        indent=4
    )
PY
