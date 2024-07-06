{ config, pkgs, ... }:

{
  # Using AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    # Add other OpenGL related packages as needed
  ];

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
    # Add other 32-bit OpenGL related packages as needed
  ];
}
