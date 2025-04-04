{pkgs, ...}: {
  # ------------------------------------------------
  # Needed Packages
  # ------------------------------------------------
  
    home.sessionVariables = {
      EDITOR = "nvim";
      #QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      TERMINAL = "foot";
      TERM = "foot";
    };
  
  home.packages = with pkgs; [
    hyprshot
    wev
    wlr-randr
    wdisplays
    gpu-screen-recorder-gtk
    playerctl
    brightnessctl
  ];

  # ------------------------------------------------
  # Hyprland Config
  # ------------------------------------------------

  wayland.windowManager.hyprland = {
    enable = true;
    #xwayland.enable = true;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    systemd = {
      enable = false;
    };

    # ------------------------------------------------
    # Configuration
    # ------------------------------------------------

    settings = {
      "$mod" = "SUPER";
      "$Alt_L" = "ALT";
      "$shiftMod" = "SUPER_SHIFT";

      # App
      "$terminal" = "foot";
      "$browser" = "brave";
      "$browser-light" = "qutebrowser";
      "$launcher" = "wofi -S drun -I";
      "$file-manager" = "thunar";
      "$Tfile-manager" = "$terminal -e yazi";
      "$audio-manager" = "com.saivert.pwvucontrol";
      "$password-manager" = "org.keepassxc.KeePassXC";
      "$bluetooth-manager" = "io.github.kaii_lb.Overskride";

      # ------------------------------------------------
      # Startup
      # ------------------------------------------------

      exec-once = [
        "uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "uwsm app -- xwaylandvideobridge &"
        "systemctl --user enable --now hyprpolkitagent.service"
        "uwsm app -- dunst"
        "uwsm app -- waybar"
        #"uwsm app -- wl-paste --watch cliphist store"
        #"uwsm app -- nm-applet --indicator &"
        #"uwsm app -- blueman-applet"
        "uwsm app -- udiskie &"
        "monitor=,preferred,auto,1"
        "swww init && sleep 0.5 && swww img ~/Pictures/wallpapers/Dune3.png"
      ];

      # ------------------------------------------------
      # Monitors
      # ------------------------------------------------

      # monitor = [
      # "eDP-1, 1920x1080, 0x0, 1"
      # "HDMI-1-A, 1920x1080, 1920x0, 1"
      # ];
      # ------------------------------------------------
      # Window Rules
      # ------------------------------------------------

      windowrule = [
       "opacity 0.85, class:^(foot|kitty|nautilus)$"
      ];

      windowrulev2 = [
        "workspace 1,       class:($browser)"
        "workspace 4,       class:(org.pwmt.zathura)"
        "workspace special, class:(spotify)"
      ];

      # ------------------------------------------------
      # Workspace Rules
      # ------------------------------------------------

      workspace = [
      ];

      # ------------------------------------------------
      # Keybidings
      # ------------------------------------------------

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
        "SUPER_SHIFT, BACKSPACE, exec, power-menu-hypr"

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

      # ------------------------------------------------
      # Sections
      # ------------------------------------------------

      debug = {watchdog_timeout = 0;};

      xwayland = {enabled = true;};
      # opengl = { force_introspection = 1; };

      animations = {enabled = false;};
      #  decoration = { shadow = { enabled = false; }; blur = { enabled = false; }; };

      # Opacity settings for all windows
      decoration = {
        rounding = 10;
        active_opacity = 0.8; # Opacity for active windows
        inactive_opacity = 0.6; # Opacity for inactive windows
        blur = {
          enabled = true; # Enable blur for transparent windows
          size = 8; # Blur strength
          passes = 2; # Blur passes
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

  #################################
  # Hypridle
  #################################
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "brightnessctl -s set 0";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  #################################
  # Hyprlock
  #################################
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = 60;
        no_fade_in = true;
        no_fade_out = true;
        disable_loading_bar = false;
      };

      input-field = {
        size = "100%, 100%";
        outline_thickness = 3;

        fade_on_empty = false;
        rounding = 15;

        position = "0, -40";
        halign = "center";
        valign = "center";
      };
    };
  };
}
