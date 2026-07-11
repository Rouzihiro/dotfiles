#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT="$DASHBOARD_DIR/data/git-tree.json"
REPO="$HOME/dotfiles"

mkdir -p "$(dirname "$OUTPUT")"

cd "$REPO" || exit 1


CHANGES=$(git status --short)



if [ -z "$CHANGES" ]; then


CONTENT="󰊢 DOTFILES

✓ Working tree clean

Nothing to commit."


else


TMP=$(mktemp)


printf "%s\n" "$CHANGES" | awk '{print $2}' > "$TMP"


CONTENT=$(cat <<EOF
󰊢 DOTFILES CHANGES

$(tree --fromfile < "$TMP")

----------------

$CHANGES
EOF
)


rm "$TMP"


fi



python3 - "$OUTPUT" "$CONTENT" <<'PY'

import json
import sys

output=sys.argv[1]
content=sys.argv[2]


with open(output,"w") as f:
    json.dump(
        {
            "git-tree": content
        },
        f,
        indent=4
    )

PY
