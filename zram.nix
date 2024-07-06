{ config, pkgs, lib, input,... }:

{
#==> Drives <==#

 #= Enable Trim Needed for SSD's
  services.fstrim.enable = true;
  services.fstrim.interval = "weekly";

 #= Swap
  zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 50;
      algorithm = "zstd";
      swapDevices = 2;
  };

}
