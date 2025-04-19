{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  name = "i3";
  category = "wm";
  cfg = config.${category}.${name};
	i3blocksConf = pkgs.callPackage ./i3blocks.nix {};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
  home.packages = with pkgs; [
    xautolock
    i3lock
    autotiling
    libnotify
    arandr
    xorg.xrandr
    redshift
    feh
    pavucontrol
    playerctl
    brightnessctl
    scrot
  ];

  xsession.windowManager.i3 = let
    mod = "Mod4";
  in {
    enable = true;
    package = pkgs.i3-gaps;

    extraConfig = ''
      # Window opacity (requires compositor like picom)
      for_window [class="alacritty"] opacity 0.9

      set $term alacritty
      set $launcher rofi -show drun
      set $browser qutebrowser
      set $fileManager thunar
      set $TfileManager $term -e yazi
      set $editor $term -e nvim
    '';

    config = {
      defaultWorkspace = "workspace number 1";
      focus.newWindow = "smart";

      startup = [
        {command = "autotiling";}
        {command = "feh --bg-scale ~/Pictures/wallpapers/Dune3.png";}
        {command = "picom";}
				#{command = "picom --config /dev/null --backend glx --blur-method dual_kawase";}
        {
          command = ''
            xautolock -time 10 -locker "i3lock" -detectsleep \
              -notify 30 \
              -notifier "notify-send 'Locking in 30 seconds"'
          '';
        }
      ];

      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            command = "floating enable";
            criteria = {class = "floating";};
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

        mod4_keybinds = {
          "${mod}+Shift+r" = "reload";
          "${mod}+q" = "kill";
          "${mod}+i" = "mode \"vm_mode\"";
          "${mod}+Ctrl+q" = "exit";
          "${mod}+Return" = "exec $term";
          "${mod}+d" = "exec $launcher";
          "${mod}+b" = "exec $browser";
          "${mod}+e" = "exec $TfileManager";
          "${mod}+s" = "exec scrot -s";
          "${mod}+Shift+s" = "exec scrot -u";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+f" = "floating toggle";
          "${mod}+space" = "scratchpad show";
          "${mod}+Shift+space" = "move scratchpad";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
        };

        general_keybinds = {
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        workspace_bindings = lib.listToAttrs (
          lib.concatMap (i: [
            {
              name = "${mod}+${toString i}";
              value = "workspace number ${toString i}";
            }
            {
              name = "${mod}+Shift+${toString i}";
              value = "move container to workspace number ${toString i}";
            }
          ]) (lib.range 1 9) ++ [
            {
              name = "${mod}+0";
              value = "workspace number 10";
            }
            {
              name = "${mod}+Shift+0";
              value = "move container to workspace number 10";
            }
          ]
        );
      in
        workspace_bindings // mod4_keybinds // general_keybinds;

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${i3blocksConf}";
          fonts = {
            names = ["DroidSansM Nerd Font"];
            size = 10.0;
          };
          colors = {
            background = "#1e1e2e";
            statusline = "#cdd6f4";
            focusedWorkspace = {
              border = "#fab387";
              background = "#fab387";
              text = "#1e1e2e";
            };
          };
        }
      ];
    };
  };
};
}
