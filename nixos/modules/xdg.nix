{ pkgs, ... }:
let

  inherit (import ./variables.nix) xdg;
in
{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    (builtins.getAttr xdg pkgs)
    polkit
    dbus
  ];

  services.dbus.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      (builtins.getAttr xdg pkgs)
      xdg-desktop-portal-gtk
    ];
  };

}
