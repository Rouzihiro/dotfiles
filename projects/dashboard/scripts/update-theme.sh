#!/bin/sh

SOURCE="$HOME/.config/waybar/colors.css"
TARGET="$HOME/dashboard/color.css"


if [ ! -f "$SOURCE" ]; then
    echo "Waybar colors.css not found"
    exit 1
fi


cat > "$TARGET" <<EOF
:root {

    --bg: #$(grep "@define-color bg " "$SOURCE" | awk '{print $3}');

    --fg: #$(grep "@define-color fg " "$SOURCE" | awk '{print $3}');

    --border: #$(grep "@define-color bordercolor " "$SOURCE" | awk '{print $3}');

    --accent: #$(grep "@define-color highlight " "$SOURCE" | awk '{print $3}');

    --success: #$(grep "@define-color green " "$SOURCE" | awk '{print $3}');

    --warning: #$(grep "@define-color warning " "$SOURCE" | awk '{print $3}');

    --urgent: #$(grep "@define-color red " "$SOURCE" | awk '{print $3}');

    --panel: rgba(255,255,255,0.05);

}
EOF


echo "Dashboard theme updated."
