{ inputs, pkgs, ... }:
let
  variables = import ../../hosts/modules/variables.nix;
in
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

# nix build nixpkgs#base16-schemes
# nix build nixpkgs#bibata-cursors

  # wayland.windowManager.hyprland.settings.general."col.active_border" =
  #  lib.mkForce "rgb(${config.stylix.basel16Scheme.base0E})";
  


  stylix = {
    enable = true;
    autoEnable = true;
    #polarity = "dark";

    targets = {
      nixvim.enable = false;
      neovim.enable = false;
      sway.enable = false;
      waybar.enable = false;
      hyprland.enable = false;
    };

  #base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  
  base16Scheme = builtins.readFile (builtins.path {
      path = ../themes/io/io.yaml;
    });
    
    iconTheme = {
      enable = true;
      dark = "Infinity";
      light = "Infinity";
    };

    cursor = {
      size = 28;
      name = "catppuccin-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
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
        applications = 12;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };
     # opacity = {
     #   applications = 1.0;
     #   terminal = 1.0;
     #   desktop = 1.0;
     #   popups = 1.0;
     # }; 
   };

}
