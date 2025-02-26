{ pkgs }:

pkgs.writeShellScriptBin "ocr-translate" ''
# Temporary filenames
imgname=$(mktemp /tmp/screenshot-ocr-XXXXXX.png)
txtname=$(mktemp /tmp/screenshot-ocr-XXXXXX.txt)

# Screenshot and OCR
if ! grim -g "$(slurp)" "$imgname"; then
    notify-send -t 2000 "OCR Screenshot" "Failed to capture screenshot."
    exit 1
fi

if ! tesseract "$imgname" "''${txtname%.txt}"; then
    notify-send -t 2000 "OCR Screenshot" "OCR failed."
    rm -f "$imgname"
    exit 1
fi

# Translation
lang_target="en" # Change "en" to your preferred target language (e.g., "es" for Spanish, "fr" for French)
translated_text=$(trans -b -s auto -t "$lang_target" "$(cat "$txtname")")

# Copy to clipboard
echo "$translated_text" | wl-copy -n

# Notify user with translated text for 20 seconds
notify-send -t 20000 "Screenshot OCR & Translation" "$translated_text"

# Cleanup
rm -f "$imgname" "$txtname"
''
