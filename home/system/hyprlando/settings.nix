{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$Alt_L" = "ALT";
      "$shiftMod" = "SUPER_SHIFT";

      # App
      "$terminal" = "foot";
      "$browser" = "brave";
      "$browser-light" = "qutebrowser";
      "$launcher" = "anyrun";
      "$file-manager" = "thunar";
      "$Tfile-manager" = "$terminal -e yazi";
      "$audio-manager" = "com.saivert.pwvucontrol";
      "$password-manager" = "org.keepassxc.KeePassXC";
      "$bluetooth-manager" = "io.github.kaii_lb.Overskride";

      debug = {watchdog_timeout = 0;};

      xwayland = {enabled = true;};

      animations = {enabled = false;};

      decoration = {
        rounding = 10;
        active_opacity = 0.8;
        inactive_opacity = 0.6;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(F5A97F) rgb(ED8796) rgb(C6A0F6) rgb(8AADF4) rgb(A6DA95) rgb(EED49F)";
        layout = "master";
      };

      dwindle = {pseudotile = true;};

      misc = {
        focus_on_activate = true;
        render_ahead_safezone = 1;
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      input = {
        kb_layout = "de";
        kb_variant = "";
        follow_mouse = 1;
        sensitivity = 0.4;
        accel_profile = "flat";
        touchpad = {
          scroll_factor = 0.5;
          natural_scroll = true;
        };
      };
    };
  };
}
