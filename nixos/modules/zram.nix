{
# Enable Trim Needed for SSD's
 services.fstrim.enable = true;
# services.fstrim.interval = "weekly";
 services.fstrim.interval = "daily";
 
 # Swap
  zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 50;
      algorithm = "zstd";
      swapDevices = 2;
  };

}
