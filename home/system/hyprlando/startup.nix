{
  exec-once = [
    "foot --server"
    "dbus-update-activation-environment --systemd --all"
    "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "waybar"
    #"exec-once = nm-applet --indicator"
    "systemctl --user start lxqt-policykit-agent"
    "monitor=,preferred,auto,1"
    "swww init && sleep 0.5 && swww img ~/Pictures/wallpapers/Dune3.png"
  ];
}
