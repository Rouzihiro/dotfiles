{ config, lib, wm, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (import ../../nixos/modules/variables.nix) currentTheme;

  name = "waybar";
  category = "statusBar";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
    settings = [
      {
        height = 30;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        modules-left = ["${wm}/window"];
        modules-center = ["${wm}/workspaces"];
        modules-right = [
          "pulseaudio"
          "network"
          "temperature"
          "memory"
          "battery"
          "clock"
        ];

        "${wm}/window" = {
          format = "{}";
          "max-length" = 35;
          rewrite = {"" = "Harsh";};
          "separate-outputs" = true;
        };

        "${wm}/workspaces" = {
          format = "{icon}";
          "on-click" = "activate";
          "format-icons" = {"active" = " ";};
          "sort-by-number" = true;
        };

        clock = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };

        memory = {
          format = "  {used:.1f}GB / {total:.1f}GB";
        };

        temperature = {
          "critical-threshold" = 80;
          format = "{icon} {temperatureC}°C";
          "format-icons" = ["" "" ""];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          "format-full" = "{icon}  {capacity}%";
          "format-charging" = "  {capacity}%";
          "format-plugged" = "  {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" ""];
        };

        network = {
          "format-wifi" = "  {signalStrength}%";
          "format-ethernet" = "{cidr} 🌐";
          "tooltip-format" = "🌍 {ifname} via {gwaddr}";
          "format-linked" = "🚫 {ifname} (No IP)";
          "format-disconnected" = "⚠ ";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = "";
          "format-icons" = {
            headphone = "";
            "hands-free" = "🎙";
            headset = "🎧";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };
      }
    ];

    style = ''
      /* Dynamic color scheme */
      @define-color base00 ${currentTheme.base00};
      @define-color base01 ${currentTheme.base01};
      @define-color base02 ${currentTheme.base02};
      @define-color base03 ${currentTheme.base03};
      @define-color base04 ${currentTheme.base04};
      @define-color base05 ${currentTheme.base05};
      @define-color base06 ${currentTheme.base06};
      @define-color base07 ${currentTheme.base07};
      @define-color base08 ${currentTheme.base08};
      @define-color base09 ${currentTheme.base09};
      @define-color base0A ${currentTheme.base0A};
      @define-color base0B ${currentTheme.base0B};
      @define-color base0C ${currentTheme.base0C};
      @define-color base0D ${currentTheme.base0D};
      @define-color base0E ${currentTheme.base0E};
      @define-color base0F ${currentTheme.base0F};

      * {
        font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0);
        border-radius: 13px;
        transition-property: background-color;
        transition-duration: .5s;
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      button:hover {
        background: inherit;
        box-shadow: inset 0 -3px @base04;
      }

      #pulseaudio:hover {
        background-color: @base02;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: @base04;
      }

      #workspaces button:hover {
        background: @base01;
      }

      #workspaces button.focused {
        background-color: @base0D;
        box-shadow: inset 0 -3px @base06;
      }

      #workspaces button.urgent {
        background-color: @base08;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio {
        padding: 0 10px;
        color: @base04;
      }

      #pulseaudio {
        color: @base0D;
      }

      #network {
        color: @base0B;
      }

      #temperature {
        color: @base0C;
      }

      #memory {
        padding: 0 10px;
        color: @base0A;
      }

      #battery {
        color: @base09;
      }

      #clock {
        color: @base0E;
      }

      #window {
        color: @base06;
      }

      .modules-right,
      .modules-left,
      .modules-center {
        background-color: @base00;
        border: 1px solid @base01;
        border-radius: 15px;
      }

      .modules-right {
        padding: 0 10px;
      }

      .modules-left {
        padding: 0 20px;
      }

      .modules-center {
        padding: 0 10px;
      }

      #battery.charging,
      #battery.plugged {
        color: @base0B;
      }

      @keyframes blink {
        to {
          color: @base00;
        }
      }

      #battery.critical:not(.charging) {
        background-color: @base08;
        color: @base06;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #pulseaudio.muted {
        color: @base03;
      }
    '';
  };
};
}
