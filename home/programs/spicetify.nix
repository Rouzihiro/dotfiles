{ config, lib, inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "spicetify";
  category = "music";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    imports = [ inputs.spicetify-nix.homeManagerModules.default ];

    programs.${name} = {
      enable = true;
      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
      # Optional: Add themes and custom settings
      # theme = inputs.spicetify-nix.legacyPackages.${pkgs.system}.themes.dribbblish;
      # colorScheme = "dark";
    };
  };
}
