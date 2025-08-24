#!/bin/sh
xrdb -merge <<< "Xft.dpi: 192"
export XFT_DPI=192
setxkbmap -layout us,de -variant , -option grp:alt_shift_toggle
dwmblocks &
exec dwm >"$HOME/.dwm.log" 2>&1
