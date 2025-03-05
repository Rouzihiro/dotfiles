{
  pkgs,
  lib,
  ...
}: let
  i3blocksConf = pkgs.callPackage ./i3blocks.nix {};
in {
  # ================================================================================================
  # Environment config
  # ================================================================================================

  home = {
    packages = with pkgs; [
      #swaybg
      swaylock
      swayidle
      libnotify

      autotiling-rs
      #wl-color-picker
      sway-contrib.grimshot

      wdisplays
      wlr-randr
      wl-gammactl

      playerctl
      brightnessctl

      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";

      DISABLE_QT5_COMPAT = 1;
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      NIXOS_OZONE_WL = 1;
      MOZ_ENABLE_WAYLAND = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "auto"; #alternatively "x11" or "wayland" 

      GTK_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      #NIXOS_XDG_OPEN_USE_PORTAL = "1";
      #QT_QPA_PLATFORMTHEME = "qt5ct";  # If using custom themes
      #ELECTRON_OZONE_PLATFORM_HINT = "auto"; 
      #GDK_BACKEND = "wayland,x11";
      #GTK_USE_PORTAL = 1; # AI deactived this, why ?
      #GTK_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      # Multimedia/Game compatibility
      #CLUTTER_BACKEND = "wayland";
      #SDL_VIDEODRIVER = "x11"; # Fallback to XWayland
      #WLR_NO_HARDWARE_CURSORS = "1"; # If cursor issues occur

      #SDL_VIDEODRIVER=wayland
      #JAVA_AWT_WM_NONREPARENTING=1;
    };
  };

  # ================================================================================================
  # Sway
  # ================================================================================================

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;

    systemd = {
      enable = false;
      # variables = [ ]
    };

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    # ------------------------------------------------
    # Configuration
    # ------------------------------------------------

    # for_window [class=".*"] opacity $opacity
    # for_window [app_id=".*"] opacity $opacity

    extraConfig = ''
      set $opacity 0.85
      for_window [app_id="foot"] opacity $opacity

      set $terminal       footclient
      set $browser        brave
      set $browser-light  qutebrowser
      set $launcher       anyrun
      #set $launcher      wofi --menu
      set $file-manager   thunar
      set $Tfile-manager  $terminal -e yazi
      set $audio-manager  com.saivert.pwvucontrol
      set $password-manager  org.keepassxc.KeePassXC
      set $bluetooth-manager  io.github.kaii_lb.Overskride

    '';

    config = {
      #focus.newWindow = "focus";
      #floating.modifier = "mod4";
      #defaultWorkspace = "workspace number 1";

      # ------------------------------------------------
      # Startup
      # ------------------------------------------------

      startup = [
        {command = "foot --server";}
        {command = "autotiling-rs";}
        #{command = "wl-gammactl -c 1.000 -b 0.950 -g 0.825";}
        #{command = "dunst";}
        {
          command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
        }
        {
          command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
        }
        {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}
        # Until https://github.com/signalapp/Signal-Desktop/issues/6368 is fixed
        {command = "${pkgs.signal-desktop}/bin/signal-desktop";}

        {command = "swww init && sleep 0.5 && swww img ~/Pictures/wallpapers/Dune3.png";}

        {
          command = ''
            swayidle -w \
            before-sleep  "swaylock -fF" \
            timeout 60 "brightnessctl -s set 0" resume "brightnessctl -r" \
            timeout 600 "systemctl suspend" \
            timeout 1800 "systemctl poweroff" '';
        }
      ];

      # ------------------------------------------------
      # Monitors
      # ------------------------------------------------

      output = {
        eDP-1 = {
          scale = "1.0";
          scale_filter = "nearest";
          resolution = "1920x1080";

          adaptive_sync = "on";
          max_render_time = "off";

          subpixel = "rgb";
          render_bit_depth = "10";
          color_profile = "srgb";
          # color_profile = "icc MNE007ZA3_2_cal_01.icm";
        };

        HDMI-A-1 = {
          #scale = "auto";
          scale_filter = "nearest";
          position = "-1920,0";
          #resolution = "preferred";

          adaptive_sync = "off";
          max_render_time = "off";

          subpixel = "rgb";
          color_profile = "srgb";
        };
      };

      # ------------------------------------------------
      # Inputs
      # ------------------------------------------------

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
        };

        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          pointer_accel = "1";
          accel_profile = "flat";
          natural_scroll = "enabled";
        };

        "type:mouse" = {
          pointer_accel = "0.4";
          accel_profile = "flat";
        };
      };
      # ------------------------------------------------
      # Window
      # ------------------------------------------------
      window = {
        border = 2;
        titlebar = false;

        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {app_id = "^org.pwmt.zathura$";};
          }
        ];
      };

      floating = {
        border = 2;
        titlebar = false;
        modifier = "mod4";
        criteria = [
          {app_id = "^yazi$";}
          {app_id = "^com.saivert.pwvucontrol$";}
          {app_id = "^io.github.kaii_lb.Overskride$";}
        ];
      };

      # ------------------------------------------------
      # Window Rules
      # ------------------------------------------------
      defaultWorkspace = "workspace number 1";

      assigns = {
        #"1" = [{app_id = "^qutebrowser$";}];
        #"2" = [{app_id = "^org.pwmt.zathura$";}];
        #"3" = [{app_id = "^codium$";}];
        #"4" = [{ app_id = "^wasistlos$"; }];
        #"4" = [{app_id = "^com.rtosta.zapzap$";}];
        #"5" = [{app_id = "^FreeTube$";}];
      };

      # ------------------------------------------------
      # Workspace Rules
      # ------------------------------------------------

      workspaceOutputAssign = [
      ];

      # ------------------------------------------------
      # Keybindings
      # ------------------------------------------------

      keybindings = let
        ws = map toString (lib.range 1 9);
        workspaceBindings =
          lib.concatMap (i: [
            {
              name = "mod4+${i}";
              value = "workspace number ${i}";
            }
            {
              name = "mod4+Shift+${i}";
              value = "move container to workspace number ${i}";
            }
          ])
          ws;
      in
        lib.listToAttrs workspaceBindings
        // {
          "mod4+space" = "scratchpad show";
          "mod4+Shift+space" = "move container to scratchpad";
          "mod1+space" = "[con_mark=scratch] scratchpad show";
          "mod1+Shift+Space" = "mark scratch; move to scratchpad";

          "mod4+Shift+Return" = "exec $launcher";
          "mod4+Return" = "exec $terminal";
          "mod4+E" = "exec $Tfile-manager";
          "mod4+B" = "exec $browser-light";
          #"mod4+Shift+B" = "exec $browser";
          "mod4+Backspace" = "exec $terminal -e btop";

          # Personal Scripts
          "Mod4+Shift+m" = "exec monitor-multi";
          #"Mod4+Shift+j" = "exec jdownloader";
          "Mod4+Shift+Backspace" = "exec power-menu-sway";
          "Mod4+Shift+v" = "exec video-tool";
          "Mod4+v" = "exec browse-video";
          "Mod4+x" = "exec $terminal -e fish -c ~/dotfiles/home/scripts/executer";
          "Mod4+SHIFT+x" = "exec script-launcher";
          "Mod4+o" = "exec ocr";
          "Mod4+Shift+o" = "exec ocr-prompt";
          "Mod4+i" = "exec ocr-translate";
          "Mod4+Shift+w" = "exec wallpaper";
          "Mod4+w" = "exec wallpaper-random";
          "Mod4+Shift+b" = "exec browse-web";
          "Mod4+k" = "exec keybinds-list-fish";
          "Mod4+Shift+k" = "exec keybinds-list-sway";

          # Screenshot
          "mod4+s" = "exec grimshot --notify copy anything && notify-send 'copied to clipboard'";
          "Print" = "exec grimshot --notify save anything ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send 'selection saved'";
          "mod4+Print" = "exec grimshot --notify save screen ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send 'full screenshot'";

          # Multimedia
          "XF86MonBrightnessUp" = "exec brightnessctl -q s 5%+";
          "XF86MonBrightnessDown" = "exec brightnessctl -q s 5%-";

          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1";

          # System
          "mod4+q" = "kill";
          "mod4+t" = "floating toggle";
          "mod4+f" = "fullscreen toggle";
          "mod4+Shift+r" = "exec swaymsg reload";
          "mod4+Shift+e" = "exec swaymsg exit";

          #"mod4+Shift+Control+r" = "exec systemctl reboot";
          #"mod4+Shift+Control+s" = "exec systemctl suspend";
          #"mod4+Shift+Control+p" = "exec systemctl poweroff";

          # Move window
          "mod4+Tab" = "move right";
          "mod1+Tab" = "move left";

          # Window
          "mod4+left" = "focus left";
          "mod4+right" = "focus right";
          "mod4+up" = "focus up";
          "mod4+down" = "focus down";

          #"mod4+Shift+h" = "move left";
          #"mod4+Shift+l" = "move right";
          #"mod4+Shift+k" = "move up";
          #"mod4+Shift+j" = "move down";

          "mod4+Control+h" = "resize shrink width 10 px ";
          "mod4+Control+l" = "resize grow width 10 px ";
          "mod4+Control+k" = "resize shrink height 10 px ";
          "mod4+Control+j" = "resize grow height 10 px ";
        };

      # ------------------------------------------------
      # Style
      # ------------------------------------------------
      gaps = {
        inner = 5;
        outer = 2;
        # right = 0;
        # left = 0;
        # top = 0;
        # bottom = 0;
        # vertical = 0;
        # horizontal = 0;
        smartGaps = true;
        smartBorders = "on";
      };

      colors = {
        focused = {
          background = "#CAD4F5";
          border = "#CAD4F5";
          childBorder = "#CAD4F5";
          indicator = "#CAD4F5";
          text = "#CAD4F5";
        };

        unfocused = {
          background = "#1E1E2E";
          border = "#1E1E2E";
          childBorder = "#1E1E2E";
          indicator = "#1E1E2E";
          text = "#1E1E2E";
        };

        focusedInactive = {
          background = "#1E1E2E";
          border = "#1E1E2E";
          childBorder = "#1E1E2E";
          indicator = "#1E1E2E";
          text = "#1E1E2E";
        };
      };

      bars = [
        {
          position = "top";
          trayPadding = 0;
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${i3blocksConf}";

          extraConfig = ''            output *
                   separator_symbol ""
          '';

          fonts = {
            names = ["DroidSansM Nerd Font"];
            style = "Regular";
            size = 10.0;
          };

          colors = {
            separator = "#1e1e2e";
            background = "#1e1e2e";

            focusedWorkspace = {
              text = "#1e1e2e";
              border = "#fab387";
              background = "#fab387";
            };

            activeWorkspace = {
              text = "#1e1e2e";
              border = "#eba0ac";
              background = "#eba0ac";
            };

            urgentWorkspace = {
              text = "#1e1e2e";
              border = "#74c7ec";
              background = "#74c7ec";
            };
          };
        }
      ];
    };
  };
}
