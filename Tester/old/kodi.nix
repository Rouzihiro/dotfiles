#https://nixos.wiki/wiki/Kodi
{ pkgs, lib, config, ... }:
{
  # Configure the Cage service to run Kodi for user rey
  services.cage = {
    enable = true;
    user = "rey";
    program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  };

  # Configure the firewall to allow ports 8080 for both TCP and UDP
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

#nixpkgs.config.kodi.enableAdvancedLauncher = true;

  # Install Kodi with the Jellyfin plugin
  environment.systemPackages = [
    (pkgs.kodi.passthru.withPackages (kodiPkgs: with kodiPkgs; [
      jellyfin
    ]))
  ];
}
