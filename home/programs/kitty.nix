{
  config,
  lib,
  ...
}: let
  inherit (import ../../nixos/modules/variables.nix) shell Editor;
in {
  options = {
    terminal.kitty.enable = lib.mkEnableOption "Enable kitty";
  };

  config = lib.mkIf config.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        #font_size = 18;
        #font_family = "Caskaydia Cove Nerd Font";
        copy_on_select = "yes";
        cursor_shape = "block";
        cursor_blink_interval = 0;
        enable_audio_bell = "no";
        shell = "${shell}";
        editor = "${Editor}";
        window_padding_width = 5;
        tab_title_template = "{index}";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
        enabled_layouts = "vertical";
      };
    };
  };
}
