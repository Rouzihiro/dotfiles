{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "starship";
  category = "cli";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };
}
