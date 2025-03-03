{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float       , ^($password-manager)$"
      "size 50% 40%, ^($password-manager)$"

      "float       , ^($bluetooth-manager)$"
      "size 50% 60%, ^($bluetooth-manager)$"

      "float       , ^($audio-manager)$"
      "size 50% 30%, ^($audio-manager)$"

      "noblur      , class:^(steam)"
      "forcergbx   , class:^(steam)"

      "opacity 0.85, class:^(foot|kitty|nautilus)$"

      "noborder,^(wofi)$"
      "center,^(wofi)$"
      "float,^(steam)$"
      "stayfocused, title:^()$,class:^(steam)$"
      "minsize 1 1, title:^()$,class:^(steam)$"
    ];

    windowrulev2 = [
      "workspace 1,       class:($browser)"
      "workspace 2,       class:(org.pwmt.zathura)"
      "workspace 3,       class:(codium)"
      "workspace 4,       class:(vesktop)"
      "workspace 5,       class:(FreeTube)"
      "workspace special, class:(spotify)"
    ];
  };
}
