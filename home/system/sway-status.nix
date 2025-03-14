{ lib, pkgs, ... }: let
  statusScript = pkgs.writeShellScriptBin "sway-status" ''
    # Custom status script using basic utilities
    while true; do
      # Date and time
      date=$(date "+%a %d %b %H:%M")
      
      # CPU usage
      cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
      
      # Memory usage
      mem=$(free -m | awk '/Mem/ {printf "%.1fG/%.1fG\n", $3/1024, $2/1024}')
      
      # Volume
      vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100"%"}')
      
      # Battery (if available)
      if [ -d /sys/class/power_supply/BAT0 ]; then
        bat=$(cat /sys/class/power_supply/BAT0/capacity)
        battery="🔋 $bat%"
      else
        battery=""
      fi
      
      # JSON output
      echo '{ "version": 1, "click_events": true }'
      echo '[[]'
      echo ',[{"full_text":" '$cpu'","min_width":"85px","align":"center"},'\
           '{"full_text":" '$mem'","min_width":"110px","align":"center"},'\
           '{"full_text":" '$vol'","min_width":"75px","align":"center"},'\
           '{"full_text":"'$battery'","min_width":"75px","align":"center"},'\
           '{"full_text":" '$date'","min_width":"140px","align":"center"}]'
      sleep 1
    done
  '';
in {
  wayland.windowManager.sway.config.bars = [{
    position = "top";
    statusCommand = "${statusScript}/bin/sway-status";
    colors = {
      background = "#1e1e2e";
      statusline = "#cdd6f4";
      separator = "#45475a";
      
      focusedWorkspace = {
        border = "#fab387";
        background = "#fab387";
        text = "#1e1e2e";
      };
      
      activeWorkspace = {
        border = "#eba0ac";
        background = "#eba0ac";
        text = "#1e1e2e";
      };
      
      urgentWorkspace = {
        border = "#74c7ec";
        background = "#74c7ec";
        text = "#1e1e2e";
      };
    };
    fonts = {
      names = ["DroidSansM Nerd Font"];
      size = 10.0;
    };
    trayPadding = 0;
    extraConfig = ''
      strip_workspace_numbers yes
      workspace_buttons yes
      binding_mode_indicator no
    '';
  }];
}
