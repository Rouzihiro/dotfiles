{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      height = 30;
      margin-top = 5;
      margin-left = 10;
      margin-right = 10;
      modules-left = [ "hyprland/window" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ 
        "pulseaudio" 
        "network" 
        "temperature" 
        "memory" 
        "battery" 
        "clock" 
      ];

      "hyprland/window" = {
        format = "{}";
        "max-length" = 35;
        rewrite = { "" = "Harsh"; };
        "separate-outputs" = true;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        "on-click" = "activate";
        "format-icons" = { "active" = " "; };
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
        "format-icons" = [ "" "" "" ];
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
        "format-icons" = [ "" "" "" "" "" ];
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
          default = [ "" "" "" ];
        };
        "on-click" = "pavucontrol";
      };
    }];

 style = ''
      /* Nord color scheme */
      @define-color nord0 #2E3440;
      @define-color nord1 #3B4252;
      @define-color nord2 #434C5E;
      @define-color nord3 #4C566A;
      @define-color nord4 #D8DEE9;
      @define-color nord5 #E5E9F0;
      @define-color nord6 #ECEFF4;
      @define-color nord7 #8FBCBB;
      @define-color nord8 #88C0D0;
      @define-color nord9 #81A1C1;
      @define-color nord10 #5E81AC;
      @define-color nord11 #BF616A;
      @define-color nord12 #D08770;
      @define-color nord13 #EBCB8B;
      @define-color nord14 #A3BE8C;
      @define-color nord15 #B48EAD;

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
        box-shadow: inset 0 -3px @nord4;
      }

      #pulseaudio:hover {
        background-color: @nord2;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: @nord4;
      }

      #workspaces button:hover {
        background: @nord1;
      }

      #workspaces button.focused {
        background-color: @nord10;
        box-shadow: inset 0 -3px @nord6;
      }

      #workspaces button.urgent {
        background-color: @nord11;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio {
        padding: 0 10px;
        color: @nord4;
      }

      #pulseaudio {
        color: @nord8;
      }

      #network {
        color: @nord14;
      }

      #temperature {
        color: @nord7;
      }

      #battery {
        color: @nord9;
      }

      #clock {
        color: @nord12;
      }

      #window {
        color: @nord6;
      }

      .modules-right,
      .modules-left,
      .modules-center {
        background-color: @nord0;
        border: 1px solid @nord1;
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
        color: @nord14;
      }

      @keyframes blink {
        to {
          color: @nord0;
        }
      }

      #battery.critical:not(.charging) {
        background-color: @nord11;
        color: @nord6;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #pulseaudio.muted {
        color: @nord3;
      }
    '';
  };
}











