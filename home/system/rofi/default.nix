{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  name = "rofi";
  category = "launcher";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ./mocha.rasi;
      terminal = "footclient";
    };
  };
}
