{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    swayrbar
    jq # Required for workspace module
  ];

  wayland.windowManager.sway.config.bars = let
    swayrbarConf = pkgs.writeText "swayrbar.toml" ''
      [icons]
      workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
      focused = ""
      unfocused = ""
      urgent = ""

      [bar]
      height = 24
      font = "DroidSansM Nerd Font 10"
      separator = " "

      [[modules]]
      type = "workspaces"
      format = "{icon}"
      tooltip = true

      [[modules]]
      type = "focused_window"
      max_length = 60
      shorten = "middle"

      [[modules]]
      type = "sys_info"
      format = " {cpu_usage}%  {mem_usage}%"
      interval = 2
      [modules.actions]
      left-click = "foot -e btop"

      [[modules]]
      type = "volume"
      format = " {level}%"
      [modules.actions]
      left-click = "pavucontrol"
      scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      scroll-down = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"

      [[modules]]
      type = "battery"
      format = "{icon} {percentage}%"
      interval = 10
      icons = ["", "", "", "", ""]
      thresholds = [10, 25, 50, 75]

      [[modules]]
      type = "clock"
      format = " %H:%M  %a %d/%m"
      interval = 30

      [[modules]]
      type = "custom"
      command = "checkupdates | wc -l"
      interval = 3600
      format = " {output}"
      [modules.actions]
      left-click = "foot -e sudo nixos-rebuild switch"
    '';
  in [
    {
      position = "top";
      statusCommand = "${pkgs.swayrbar}/bin/swayrbar -c ${swayrbarConf}";
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
    }
  ];
}
