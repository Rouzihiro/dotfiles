{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  name = "qtile";
  category = "wm";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
  home.file.qtile_configs = {
    source = ./src;
    target = ".config/qtile";
    recursive = true;
  };
};
}
