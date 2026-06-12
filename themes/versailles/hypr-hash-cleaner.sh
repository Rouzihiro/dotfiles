
set -euo pipefail

DIR="${1:-.}"

echo "Stripping '#' from Hyprland configs in: $DIR"

find "$DIR" -type f -name "hyprland.conf" -o -name "*.conf" | while read -r file; do
    echo "processing: $file"
    sed -i 's/#//g' "$file"
done

echo "Done."
