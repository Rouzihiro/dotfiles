
set -euo pipefail

DRY_RUN="${1:-yes}"

find ~/.config -maxdepth 4 -type l | while read -r link; do
  target=$(readlink -f "$link")
  case "$target" in
    "$HOME/dotfiles/.config"/*)
      if [[ "$DRY_RUN" == "yes" ]]; then
        echo "WOULD CONVERT: $link -> $target"
      else
        echo "Converting: $link"
        tmp="${link}.new_$$"
        cp -rL "$target" "$tmp"
        rm "$link"
        mv "$tmp" "$link"
      fi
      ;;
    *)
      echo "SKIP (not dotfiles): $link -> $target"
      ;;
  esac
done
