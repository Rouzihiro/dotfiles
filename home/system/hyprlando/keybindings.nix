{
  bind = [
    # Window
    "SUPER, H, movefocus, l"
    "SUPER, L, movefocus, r"
    "SUPER, K, movefocus, u"
    "SUPER, J, movefocus, d"

    "SUPER ALT, H, resizeactive, -20 0"
    "SUPER ALT, L, resizeactive, 20 0"
    "SUPER ALT, K, resizeactive, 0 -20"
    "SUPER ALT, J, resizeactive, 0 20"

    # System
    "SUPER, Q, killactive"
    #"ALT, Q, killactive"
    "SUPER, F, fullscreen"
    "SUPER, T, togglefloating"

    "SUPER, RETURN   , exec , $terminal"
    "SUPER_SHIFT, RETURN   , exec , $launcher"
    "ALT, SPACE, exec , $launcher"
    "SUPER_SHIFT, B        , exec , $browser"
    "SUPER, B        , exec , $browser-light"
    "SUPER, Backspace, exec , footclient -e btop"
    "SUPER, E        , exec , $Tfile-manager"
    "SUPER_SHIFT, E        , exec , $file-manager"

    # Screenshot
    "SUPER                 , S , exec , hyprshot -m region --clipboard-only"
    " , PRINT, exec, hyprshot -m region -o ~/Pictures/screenshots"
    "SUPER, PRINT, exec, hyprshot -m window -o ~/Pictures/screenshots"
    "SUPER_SHIFT, PRINT, exec, hyprshot -m output -o ~/Pictures/screenshots"

    # Nix-packages
    "SUPER_SHIFT, X, exec, extract-helper"
    "SUPER_SHIFT, M, exec, monitor-multi"
    "SUPER, O, exec, ocr"
    "SUPER, X, exec, script-launcher"
    "SUPER_SHIFT, W, exec, wallpaper"
    "SUPER, W, exec, wallpaper-random"
    "SUPER, V, exec, video-tool"
    "SUPER_SHIFT, BACKSPACE, exec, power-menu"

    # Switch workspaces with mainMod + [0-9]
    "SUPER, 2, workspace, 2"
    "SUPER, 1, workspace, 1"
    "SUPER, 3, workspace, 3"
    "SUPER, 4, workspace, 4"
    "SUPER, 5, workspace, 5"
    "SUPER, 6, workspace, 6"
    "SUPER, 7, workspace, 8"
    "SUPER, 8, workspace, 8"
    "SUPER, 9, workspace, 9"

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    "SUPER SHIFT, 1, movetoworkspace,  1"
    "SUPER SHIFT, 2, movetoworkspace,  2"
    "SUPER SHIFT, 3, movetoworkspace,  3"
    "SUPER SHIFT, 4, movetoworkspace,  4"
    "SUPER SHIFT, 5, movetoworkspace,  5"
    "SUPER SHIFT, 6, movetoworkspace,  6"
    "SUPER SHIFT, 7, movetoworkspace,  7"
    "SUPER SHIFT, 8, movetoworkspace,  8"
    "SUPER SHIFT, 9, movetoworkspace,  9"

    "SUPER_SHIFT, SPACE, movetoworkspace, special"
    "SUPER, SPACE, togglespecialworkspace"

    "ALT, Tab, cyclenext"
    "ALT, Tab, bringactivetotop"
  ];

  bindm = [
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];

  bindl = [
    ", XF86AudioMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", switch:Lid Switch, exec, loginctl lock-session && systemctl suspend"
  ];

  bindle = [
    ",XF86AudioRaiseVolume, exec, (wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F': ' '{print int($2 * 100)}' && sleep 1) | wob"
    ",XF86AudioLowerVolume, exec, (wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F': ' '{print int($2 * 100)}' && sleep 1) | wob"
    ",XF86MonBrightnessUp, exec, (brightnessctl g | awk -v max=$(brightnessctl m) '{print int(($1 / max) * 100)}' && sleep 1) | wob"
    ",XF86MonBrightnessDown, exec, (brightnessctl g | awk -v max=$(brightnessctl m) '{print int(($1 / max) * 100)}' && sleep 1) | wob"

    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"

    ", XF86AudioPlay , exec , playerctl play-pause"
    ", XF86AudioStop , exec , playerctl pause"
    ", XF86AudioPrev , exec , playerctl previous"
    ", XF86AudioNext , exec , playerctl next"

    ", XF86MonBrightnessUp,   exec, brightnessctl -q s 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl -q s 5%-"
  ];
}
