{ pkgs, ...}:
{

  programs.sway = {
    enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;
  hardware.graphics.enable = true;
}
