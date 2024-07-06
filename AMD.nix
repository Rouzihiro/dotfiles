{ config, pkgs, ... }:

{
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa_drivers ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
}

