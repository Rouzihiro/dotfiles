#!/bin/bash

file="$1"

# Width and height passed by Vifm (fallback to something minimal if unset)
w=${2:-40}
h=${3:-20}

# Get mime type
mimetype=$(file -Lb --mime-type "$file")

case "$mimetype" in
  image/*)
    if [[ "$TERM" == "xterm-kitty" ]]; then
      kitty +kitten icat --silent --stdin no --transfer-mode file \
        --place "${w}x${h}@0x0" "$file" < /dev/null > /dev/tty
    else
      chafa -f sixel -s "${w}x${h}" --polite on --animate off "$file"
    fi
    ;;
  *)
    pistol "$file"
    ;;
esac

