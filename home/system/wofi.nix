let
  variables = import ../../hosts/modules/variables.nix; 
  theme = variables.currentTheme;    
in
{
  programs.wofi = {
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
          background: ${theme.background};
          color: ${theme.foreground};
        }
        #entry {
          padding: 5px;
        }
        #entry:selected {
          background: ${theme.primary};
        }
      '';
    };

     };
}
