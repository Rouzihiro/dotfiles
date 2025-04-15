{
  pkgs,
  colorScheme,
  inputs,
  ...
}:
{
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };
  #
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "${colorScheme.slug}";
  #     package =
  #       let
  #         nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  #       in
  #       nix-colors-lib.gtkThemeFromScheme { scheme = colorScheme; };
  #   };
  #   iconTheme = {
  #     name = "Gruvbox-Plus-Dark";
  #     package = pkgs.gruvbox-plus-icons;
  #   };
    cursorTheme = {
      name = "McMojave-cursors";
      size = 28;
    };

  #   gtk3.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  #
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #   };
  # };
}
