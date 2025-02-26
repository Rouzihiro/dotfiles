{ config, pkgs, ... }:
let

  inherit (import ../../hosts/modules/variables.nix) xdg WM;
in
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      (builtins.getAttr xdg pkgs)
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ WM "gtk" ];
      };
    };
  };

  home.packages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];

  # Initialize user directories and DBus
  systemd.user.sessionVariables = config.home.sessionVariables;
}
