#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT="$DASHBOARD_DIR/data/lsblk.json"


CONTENT=$(lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS)


python3 - "$OUTPUT" "$CONTENT" <<'PY'

import json
import sys

output = sys.argv[1]
content = sys.argv[2]


with open(output, "w") as f:
    json.dump(
        {
            "lsblk-output": content
        },
        f,
        indent=4
    )

PY
