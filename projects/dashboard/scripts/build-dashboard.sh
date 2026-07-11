#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

TEMPLATE="$DASHBOARD_DIR/template.html"
OUTPUT="$DASHBOARD_DIR/index.html"


cp "$TEMPLATE" "$OUTPUT"


TMP=$(mktemp)


for card in "$DASHBOARD_DIR"/cards/*.html; do

    [ -f "$card" ] || continue

    cat "$card" >> "$TMP"

done


python3 - "$OUTPUT" "$TMP" <<'PY'

import sys

output=sys.argv[1]
cards=sys.argv[2]


with open(output) as f:
    html=f.read()


with open(cards) as f:
    content=f.read()


html=html.replace(
    "<!-- CARDS -->",
    content
)


with open(output,"w") as f:
    f.write(html)

PY


rm "$TMP"


echo "Dashboard rebuilt."
