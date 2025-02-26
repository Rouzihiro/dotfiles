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
}



