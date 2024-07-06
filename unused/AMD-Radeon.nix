#AMD-Radeon.nix
{ config, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    #driSupport = true;
    extraPackages = with pkgs; [
      mesa_drivers
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" "ati" ];

  #boot.kernelPackages = pkgs.linuxPackages_5_15;
}

