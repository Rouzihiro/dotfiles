{ config, pkgs, ... }:

{
  # Flatpak & Flatpak-Repositories
  environment.systemPackages = with pkgs; [
    flatpak
  ];

  # Enable XDG Desktop Portals for Flatpak
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

  # Specify the portal backend to use (Wayland-compatible backend for Sway)
  xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-wlr ];

  # Flatpak-Repositories
  environment.etc."flatpak/repo.d/flathub.conf".text = ''
    [remote "flathub"]
    url=https://dl.flathub.org/repo/
    gpg-verify=true
    gpg-verify-summary=true
    xa.title=Flathub
    xa.comment=Apps for all Linux devices
  '';

  services.flatpak.enable = true;

  # Flatpak-Repository
  system.activationScripts.flatpak = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  '';

  # Flatpak-Installation
  system.activationScripts.flatpakApps = ''
    ${pkgs.flatpak}/bin/flatpak install -y flathub org.jdownloader.JDownloader
  '';
}

