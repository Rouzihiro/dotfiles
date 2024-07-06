{ config, pkgs, ... }:

{
  # Kernel Driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # XServer Configuration
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Southern Islands (SI) and Sea Islands (CIK) Support
  boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];  # For Southern Islands
  # Uncomment the next line if you have a Sea Islands (CIK) GPU
  # boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];

  # Vulkan and OpenCL
  hardware.opengl.driSupport32Bit = true;  # For 32-bit applications
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd  # OpenCL
    amdvlk  # AMD's Vulkan driver
  ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [
    amdvlk
  ];

  # Environment Variables for OpenCL
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # Power Management
  powerManagement.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };

  # Additional system packages for Vulkan and general graphics support
  environment.systemPackages = with pkgs; [
    amdvlk
    vulkan-extension-layer
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-utility-libraries
    vulkan-validation-layers
    vkdisplayinfo
    vkd3d
    vkd3d-proton
    vk-bootstrap
    mesa
    mesa_drivers
    libva
    libva-utils
  ];

  # General graphics hardware configuration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa_drivers ];
  };

  # CPU microcode updates for AMD processors
  hardware.cpu.amd.updateMicrocode = true;
}

