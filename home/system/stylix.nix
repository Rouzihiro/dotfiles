{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  name = "stylix";
  category = "theme";
  cfg = config.${category}.${name};
in {
  imports = [inputs.stylix.homeManagerModules.stylix];
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";
  config = mkIf cfg.enable {
    ${name} = {
      enable = true;
      autoEnable = true;
      #polarity = "dark";

      targets = {
        nixvim.enable = false;
        neovim.enable = false;
        rofi.enable = false;
        #sway.enable = false;
        waybar.enable = false;
        hyprland.enable = false;
        librewolf.enable = false;
      };

      # nix build nixpkgs#base16-schemes
      # nix build nixpkgs#bibata-cursors

      # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      #  for custom themes;
      #  base16Scheme = builtins.path {
      #  path = ../themes/moonfly.yaml;
      #  name = "moonfly";
      # };

      iconTheme = {
        enable = true;
        dark = "Nordzy";
        light = "Nordzy";
        package = pkgs.nordzy-icon-theme;
      };

     # cursor = {
     #   package = pkgs.rose-pine-cursor;
     #   name = "rose-pine-cursor";
     #   size = 24;
     # };

       cursor = {
         package = pkgs.bibata-cursors;
         name = "Bibata-Modern-Ice";
         size = 20;
       };

      fonts = {
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "noto-fonts-color-emoji";
        };

        monospace = {
          package = pkgs.nerd-fonts.droid-sans-mono;
          name = "DroidSansM Nerd Font";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sizes = {
          applications = 14;
          terminal = 14;
          desktop = 15;
          popups = 15;
        };

        #   sizes = {
        #     applications = 12;
        #     terminal = 12;
        #     desktop = 10;
        #     popups = 10;
        #   };
        #
        # opacity = {
        #   applications = 1.0;
        #   terminal = 0.8;
        #   desktop = 1.0;
        #   popups = 0.8;
        # };
      };
    };
  };
}
