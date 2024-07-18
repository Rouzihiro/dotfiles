Hey buddy,

I set up a 4060 for my laptop earlier in the year. I had issues initially with switching to the proprietary driver and offloading from the iGPU for games etc, but no flickering or performance issues since.

I don't know if there are any settings in the below you haven't tried?

# https://nixos.wiki/wiki/Nvidia
hardware.graphics = {
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [ 
    vaapiVdpau 
    libvdpau-va-gl
    intel-media-driver
    # intel-vaapi-driver
    nvidia-vaapi-driver 
  ];
};

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = true;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.beta;
  prime = {
    offload = {
	    enable = true;
	    enableOffloadCmd = true;
	  };
    # sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};

boot.blacklistedKernelModules = [ "nouveau" ];
boot.kernelPackages = pkgs.linuxPackages_latest;

services.xserver.videoDrivers = [ "nvidia" ];
services.xserver.enable = true;

boot.kernelParams = [ "i915.force_probe=7d55" "nvidia_drm.fbdev=1" ];