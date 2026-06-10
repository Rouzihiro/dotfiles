#!/usr/bin/env bash
set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-chafa"
mkdir -p "$CACHE_DIR"

file="$1"

key=$(printf '%s' "$file" | sha1sum | awk '{print $1}')
cache="$CACHE_DIR/$key"

if [[ -f "$cache" ]]; then
  cat "$cache"
  exit 0
fi

chafa -s 40x20 "$file" | tee "$cache"
