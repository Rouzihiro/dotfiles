{ config, ... }:
{
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = false;

      nvidiaSettings = false;
      modesetting.enable = true;
      dynamicBoost.enable = true;

      powerManagement = {
        enable = true;
        finegrained = true;
      };

      prime = {
        amdgpuBusId = "PCI:05:00:0";
        nvidiaBusId = "PCI:01:00:0";
        #sync.enable = true;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };

  specialisation = {
    Battery.configuration = {
      system.nixos.tags = [ "Battery" ];

      boot.extraModprobeConfig = ''blacklist nouveau options nouveau modeset=0'';
      boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    };
  };
}
