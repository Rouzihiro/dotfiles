{
  host,
  pkgs,
  ...
}: {
  home.packages = [pkgs.conky];
  xdg.configFile."conky/conky-qtile.conf".source = ./main-right.conf;
  #xdg.configFile."conky/conky-qtile2.conf".source = ./keybindings-shell.conf;
  #xdg.configFile."conky/conky-qtile3.conf".source = ./network.conf;
}
