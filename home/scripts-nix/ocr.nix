{ pkgs }:

pkgs.writeShellScriptBin "ocr" ''
  timestamp=$(date +%Y%m%d%H%M%S)
  imgname="/tmp/screenshot-ocr-''${timestamp}.png"
  txtname="/tmp/screenshot-ocr-''${timestamp}.txt"

# Capture screenshot and extract text
if ! grim -g "$(slurp)" "$imgname"; then
    notify-send -t 2000 "OCR Screenshot" "Failed to capture screenshot."
    exit 1
fi

if ! tesseract "$imgname" "''${txtname%.txt}"; then
    notify-send -t 2000 "OCR Screenshot" "OCR failed."
    rm -f "$imgname"
    exit 1
fi

wl-copy -n < "$txtname"

# Store the extracted text for notification preview
ocr_text=$(head -n 1 "$txtname")

# Handle empty OCR results
if [ -z "$ocr_text" ]; then
    ocr_text="[No text found]"
fi

# Send notification via notify-send
notify-send -t 2000 "OCR Screenshot" "Copied: $ocr_text"

# Cleanup
rm -f "$imgname" "$txtname"
''

