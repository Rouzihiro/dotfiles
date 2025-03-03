{
  wayland.windowManager.hyprland.settings = {
    bindl = [
      ", XF86AudioMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", switch:Lid Switch, exec, loginctl lock-session && systemctl suspend"
    ];
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
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
    bind =
      [
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

        "SUPER_SHIFT, SPACE, movetoworkspace, special"
        "SUPER, SPACE, togglespecialworkspace"

        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
  };
}
