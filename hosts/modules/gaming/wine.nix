{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable #https://nixos.wiki/wiki/Wine
    winetricks
  ];
}
