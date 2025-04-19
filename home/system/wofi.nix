{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (import ../../nixos/modules/variables.nix) currentTheme;

  name = "wofi";
  category = "launcher";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      settings = {
        allow_markup = true;
        width = 450;
        height = "305px";
        orientation = "vertical";
        halign = "fill";
        show = "drun";
        normal_window = true;
        layer = "top";
        gtk_dark = true;
        line_wrap = "off";
        dynamic_lines = false;
        allow_images = true;
        image_size = 24;
        exec_search = false;
        hide_search = false;
        parse_search = false;
        insensitive = true;
        hide_scroll = true;
        no_actions = true;
        sort_order = "default";
        filter_rate = 100;
        key_expand = "Tab";
        key_exit = "Escape";
        style = ''
          * {
            background: #${currentTheme.base00};
            color: #${currentTheme.base05};


          }

          #entry {
            padding: 5px;
            border: 1px solid #${currentTheme.base02};
          }

          #entry:selected {
            background: #${currentTheme.base0D};
            color: #${currentTheme.base07};
          }

          #input {
            background: #${currentTheme.base01};
            color: #${currentTheme.base05};
            border: 1px solid #${currentTheme.base02};
            padding: 5px;
          }

          #scroll {
            background: #${currentTheme.base01};
            border: 1px solid #${currentTheme.base02};
          }

          #scroll trough {
            background: #${currentTheme.base02};
          }

          #scroll slider {
            background: #${currentTheme.base0D};
          }

          #category {
            background: #${currentTheme.base01};
            color: #${currentTheme.base0A};
            padding: 5px;
            border-bottom: 1px solid #${currentTheme.base02};
          }
        '';
      };
    };
  };
}
