{
  lib,
  pkgs,
  inputs,
  ...
}: let
  i3blocksConf = pkgs.callPackage ./i3blocks.nix {};
in {
  #imports = [ ];
  home.packages = with pkgs; [
    swayidle
    swaylock
    autotiling-rs
    libnotify

    wdisplays
    wlr-randr
    wlsunset
    #wl-gammactl

    pavucontrol
    playerctl
    brightnessctl
  ];
  wayland.windowManager.sway = let
    mod = "mod4";
  in {
    enable = true;
    #wrapperFeatures.gtk = true;
    #xwayland = true;
    #systemd.enable = false;
    extraConfig = ''
       set $opacity 0.9
       for_window [app_id="foot"] opacity $opacity
      for_window [title="^JDownloader.*"] opacity 0.8

       set $term footclient
       set $launcher2 anyrun
       set $launcher rofi -show drun
       set $browser qutebrowser
       set $browser2  brave
       set $fileManager thunar
       set $TfileManager $term -e yazi
       set $editor $term -e nvim
    '';
    config = {
      defaultWorkspace = "workspace number 1";
      focus.newWindow = "focus";
      startup = [
        {command = "foot --server";}
        {command = "autotiling-rs";}
        #{command = "udiskie";}
        {command = "swww init && sleep 0.5 && swww img ~/Pictures/wallpapers/Dune3.png";}
        {
          command = ''
            swayidle -w \
              before-sleep "swaylock -fF" \
              timeout 90 'if ! pgrep -x "motrix"; then brightnessctl -s set 0; fi' \
                resume 'brightnessctl -r' \
              timeout 900 'if ! pgrep -x "motrix"; then systemctl suspend; fi' \
              timeout 1800 'if ! pgrep -x "motrix"; then systemctl poweroff; fi'
          '';
        }
      ];
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

      window = {
        border = 2;
        titlebar = false;

        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {app_id = ".*";};
          }
        ];
      };
      gaps = {
        inner = 5;
        outer = 2;
      };
      floating = {
        border = 2;
        titlebar = false;
        modifier = mod;
      };

      modes = {
        vm_mode = {
          "${mod}+i" = "mode \"default\"";
        };
      };
      keybindings = let
        unpack = set: lib.lists.foldr (a: b: a // b) {} (builtins.attrValues set);

        mod4_keybinds = unpack (builtins.mapAttrs (key: cmd: {"${mod}+${key}" = "${cmd}";}) {
          # General Keybinds
          "Shift+r" = "reload";
          "q" = "kill";
          "i" = "mode \"vm_mode\"";

          # Executables
          "Ctrl+q" = "exec swaymsg exit";
          "Return" = "exec $term";
          "Shift+c" = "exec swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .app_id'";

          "s" = "exec screenshot sc";
          "Shift+s" = "exec screenshot pc";
          "Print" = "exec screenshot p";
          "d" = "exec $launcher";
          "n" = "exec $editor";
          "b" = "exec $browser";
          "e" = "exec $TfileManager";

          "space" = "scratchpad show";
          "Shift+space" = "floating enable, resize set width 1800 height 1000, move scratchpad";
          "Backspace" = "exec $term -e btop";

          # Personal Scripts
          "Shift+m" = "exec monitor-multi";
          "Shift+Backspace" = "exec power-menu-sway";
          "Shift+v" = "exec video-tool";
          "v" = "exec browse-video";
          "Shift+x" = "exec $term -e ~/dotfiles/home/scripts/executer";
          "x" = "exec script-launcher";
          "o" = "exec ocr";
          "Shift+t" = "exec ocr-prompt";
          "t" = "exec ocr-translate";
          "Shift+w" = "exec wallpaper";
          "w" = "exec wallpaper-random";
          "Shift+b" = "exec browse-web";
          "z" = "exec keybinds-list-shell";
          "Shift+z" = "exec keybinds-list-sway";

          # Layout stuff
          "f" = "fullscreen";
          "Shift+f" = "floating toggle";
          "a" = "focus parent";

          # Navigation keybinds
          "h" = "focus left";
          "j" = "focus down";
          "k" = "focus up";
          "l" = "focus right";

          "Shift+h" = "move left";
          "Shift+j" = "move down";
          "Shift+k" = "move up";
          "Shift+l" = "move right";

          # Resizing keybinds
          "Ctrl+h" = "resize shrink width 50px";
          "Ctrl+k" = "resize grow height 50px";
          "Ctrl+j" = "resize shrink height 50px";
          "Ctrl+l" = "resize grow width 50px";
        });

        general_keybinds = unpack (builtins.mapAttrs (key: cmd: {"${key}" = "exec ${cmd}";}) {
          "mod1+Return" = "exec $launcher";
          "mod1+d" = "exec $launcher2";
          "Print" = "exec screenshot s";
          "mod1+space" = "[con_mark=scratch] scratchpad show";
          "mod1+Shift+Space" = "mark scratch; floating enable, resize set width 1800 height 1000, move scratchpad";

          # Brightness controls
          "XF86MonBrightnessDown" = "brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "brightnessctl set +5%";

          # Audio controls
          "XF86AudioLowerVolume" = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioRaiseVolume" = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioMute" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # Playerctl
          "XF86AudioPlay" = "playerctl play-pause";
          "XF86AudioPrev" = "playerctl previous";
          "XF86AudioNext" = "playerctl next";
        });

        keybinds = mod4_keybinds // general_keybinds;

        # Workspaces
        ws = map toString (lib.range 1 9);
        workspaceBindings =
          lib.concatMap (i: [
            {
              name = "${mod}+${i}";
              value = "workspace number ${i}";
            }
            {
              name = "${mod}+Shift+${i}";
              value = "move container to workspace number ${i}";
            }
          ])
          ws;

        workspaces =
          {
            "${mod}+0" = "workspace number 10";
            "${mod}+Shift+0" = "move container to workspace number 10";
          }
          // builtins.listToAttrs workspaceBindings;
      in
        workspaces // keybinds;
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
