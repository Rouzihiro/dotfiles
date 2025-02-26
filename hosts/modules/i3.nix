{ pkgs, ... }:

{

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    xkb.layout = "de";
    xkb.variant = "";
    # options = "grp:switch"; 
    excludePackages = [ pkgs.xterm ];
  };

   services.xserver.displayManager.startx.enable = true;

#  services.displayManager = {
 #   defaultSession = "none+i3"; };

  # videoDrivers = [ "modesetting" "displaylink" ]; 

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = [
      pkgs.dmenu
      pkgs.rofi
      # pkgs.i3status 
      pkgs.i3lock
      pkgs.i3blocks
      # pkgs.xkb-switch 
    ];
  };
}



