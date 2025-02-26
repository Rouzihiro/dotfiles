{ pkgs, ... }:

pkgs.writeShellScriptBin "keybinds-sway" ''
  yad --width=800 --height=650 \
  --center \
  --fixed \
  --title="Sway Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --timeout=90 \
  --timeout-indicator=right \
  "Mod1+1" "Librewolf" \
  "Mod1+2" "Yazi" \
  "Mod1+3" "Nautilus" \
  "Mod4+SPACE" "Wofi" \
  "Mod4+Return" "Foot" \
  "Mod4+Shift+B" "Brave Browser" \
  "Mod4+Shift+m" "Monitor Switch" \
  "Mod4+Shift+Backspace" \
  "Mod4+Shift+v" "Video Tool Wofi" \
  "Mod4+v" "Browse Videos" \
  "Mod4+Shift+x" "Executer" \
  "Mod4+x" "Browse Scripts" \
  "Mod4+Shift+w" "Wallpaper" \
  "Mod4+w" "Random Wallpaper" \
  "Mod4+b" "Browse Web" \
  "Mod4+k" "Keybinds Shell" \
  "Mod4+Shift+k" "Keybinds Sway" \
  "Mod4+o" "Screenshot OCR" \
  "Mod4+Shift+o" "Screenshot OCR - promt language" \
  "Mod4+i" "Screenshot OCR + translate (eng)" \
  "Mod4+s" "Screenshot Region - clipboard" \
  "Print" "Screenshot Region" \
  "Mod4+Print" "Screenshot Screen" \
  "XF86MonBrightnessUp" "Increase Brightness" \
  "XF86MonBrightnessDown" "Decrease Brightness" \
  "XF86AudioMute" "Mute Audio" \
  "XF86AudioLowerVolume" "Lower Volume" \
  "XF86AudioRaiseVolume" "Raise Volume" \
  "Mod4+q" "Kill Window" "kill" \
  "Mod1+q" "Kill Window" "kill" \
  "Mod4+t" "Floating Toggle" \
  "Mod4+f" "Fullscreen Toggle" \
  "Mod4+Shift+r" "Sway Restart" \
  "Mod4+Shift+e" "Exit Sway" \
  "Mod4+Tab" "Move Right" \
  "Mod1+Tab" "Move Left" \
  "Mod4+left" "Focus Left" \
  "Mod4+right" "Focus Right" \
  "Mod4+up" "Focus Up" \
  "Mod4+down" "Focus Down" \
  "Mod4+Control+h" "Resize Shrink Width" \
  "Mod4+Control+l" "Resize Grow Width" \
  "Mod4+Control+k" "Resize Shrink Height" \
  "Mod4+Control+j" "Resize Grow Height"  \
  ''

