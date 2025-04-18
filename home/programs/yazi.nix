{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "yazi";
  category = "fileManager";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  imports = [ ./yazi-keymaps.nix ];

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      enableFishIntegration = false;
      enableZshIntegration = false;
      enableBashIntegration = true;

      settings = {
        log.enabled = false;

        manager = {
          ratio = [2 4 3];
          show_hidden = true;
          show_symlink = true;
          sort_by = "extension";
        };

        opener = {
          pdf = [
            {
              run = ''zathura "$@" '';
              orphan = true;
              for = "unix";
            }
          ];
          imv = [
            {
              run = ''imv-wayland "$@" '';
              orphan = true;
              for = "unix";
            }
          ];
        };

        open = {
          prepend_rules = [
            {
              name = "*.pdf";
              use = "pdf";
            }
            {
              name = "*.jpg";
              use = "imv";
            }
            {
              name = "*.png";
              use = "imv";
            }
            {
              name = "*.gif";
              use = "imv";
            }
            {
              name = "*.bmp";
              use = "imv";
            }
            {
              name = "*.svg";
              use = "imv";
            }
            {
              name = "*.ico";
              use = "imv";
            }
            {
              name = "*.heic";
              use = "imv";
            }
            {
              name = "*.jpeg";
              use = "imv";
            }
            {
              name = "*.tiff";
              use = "imv";
            }
            {
              name = "*.webp";
              use = "imv";
            }
          ];
        };
      };
    };
  };
}
