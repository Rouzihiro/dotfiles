{ pkgs }:

pkgs.writeShellScriptBin "ocr-prompt" ''
# Temporary filenames
timestamp=$(date +%Y%m%d%H%M%S)
imgname="/tmp/screenshot-ocr-''${timestamp}.png"
txtname="/tmp/screenshot-ocr-''${timestamp}"
txtfname="$txtname.txt"

# Define languages for Wofi menu
languages="German (de)
English (en)
French (fr)
Italian (it)
Spanish (es)
Farsi (fa)"

# Show Wofi prompt to select language
lang_choice=$(printf "%s\n" "$languages" | wofi --dmenu --width 300 --height 200 --prompt "Select Language")

# Map choice to language code
case "$lang_choice" in
  "German (de)") lang_target="de" ;;
  "English (en)") lang_target="en" ;;
  "French (fr)") lang_target="fr" ;;
  "Italian (it)") lang_target="it" ;;
  "Spanish (es)") lang_target="es" ;;
  "Farsi (fa)") lang_target="fa" ;;
  *) lang_target="en"; notify-send "Invalid selection, defaulting to English."; ;;
esac

# Capture screenshot and perform OCR
if ! grim -g "$(slurp)" "$imgname"; then
    notify-send -t 2000 "OCR Screenshot" "Failed to capture screenshot."
    exit 1
fi

if ! tesseract "$imgname" "$txtname"; then
    notify-send -t 2000 "OCR Screenshot" "OCR failed."
    rm -f "$imgname"
    exit 1
fi

# Translate the text
if [ -f "$txtfname" ]; then
  extracted_text=$(cat "$txtfname")
  translated_text=$(trans -b -s auto -t "$lang_target" "$extracted_text")

  # Copy the translated text to clipboard
  echo "$translated_text" | wl-copy -n

  # Notify user with translated text for 20 seconds
  notify-send -t 20000 "Screenshot OCR & Translation" "$translated_text"

  # Cleanup
  rm -f "$imgname" "$txtfname"

else
  notify-send "Screenshot Translation" "Failed to extract text. OCR output not found."
fi
''
