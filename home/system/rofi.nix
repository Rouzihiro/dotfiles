{
  pkgs,
  config,
  ...
}: let
  inherit (import ../../hosts/modules/variables.nix) currentTheme;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Roboto Medium 14";

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;

      # Define colors using `currentTheme`
      colors = {
        background = mkLiteral currentTheme.base00;
        background-alt = mkLiteral currentTheme.base01;
        foreground = mkLiteral currentTheme.base05;
        foreground-alt = mkLiteral currentTheme.base06;
        primary = mkLiteral currentTheme.base0D;
        secondary = mkLiteral currentTheme.base0E;
        accent = mkLiteral currentTheme.base0A;
        warning = mkLiteral currentTheme.base09;
        error = mkLiteral currentTheme.base08;
        success = mkLiteral currentTheme.base0B;
        transparent = mkLiteral "rgba(0, 0, 0, 0)";
      };
    in {
      "*" = colors;

      window = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "screenshot";
        padding = mkLiteral "10px";
        border = mkLiteral "0px";
        border-radius = mkLiteral "6px";
        background-color = mkLiteral "@transparent";
        spacing = 0;
        children = mkLiteral "[mainbox]";
        orientation = mkLiteral "horizontal";
      };

      mainbox = {
        spacing = 0;
        children = mkLiteral "[inputbar, message, listview]";
      };

      message = {
        color = mkLiteral "@background";
        padding = 5;
        border-color = mkLiteral "@primary";
        border = mkLiteral "0px 2px 2px 2px";
        background-color = mkLiteral "@secondary";
      };

      inputbar = {
        color = mkLiteral "@foreground";
        padding = mkLiteral "11px";
        background-color = mkLiteral "@background-alt";
        border = mkLiteral "1px";
        border-radius = mkLiteral "6px 6px 0px 0px";
        border-color = mkLiteral "@primary";
      };

      "entry, prompt, case-indicator" = {
        text-font = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      prompt = {
        margin = mkLiteral "0px 0.3em 0em 0em";
      };

      listview = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "0px 0px 6px 6px";
        border-color = mkLiteral "@primary";
        border = mkLiteral "0px 1px 1px 1px";
        background-color = mkLiteral "@background";
        dynamic = mkLiteral "false";
      };

      element = {
        padding = mkLiteral "3px";
        vertical-align = mkLiteral "0.5";
        border-radius = mkLiteral "4px";
        background-color = mkLiteral "transparent";
        color = mkLiteral "@foreground";
        text-color = mkLiteral "@foreground";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@primary";
        text-color = mkLiteral "@background";
      };

      "element-text, element-icon" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      button = {
        padding = mkLiteral "6px";
        color = mkLiteral "@foreground";
        horizontal-align = mkLiteral "0.5";
        border = mkLiteral "2px 0px 2px 2px";
        border-radius = mkLiteral "4px 0px 0px 4px";
        border-color = mkLiteral "@primary";
      };

      "button selected normal" = {
        border = mkLiteral "2px 0px 2px 2px";
        border-color = mkLiteral "@primary";
      };
    };

    extraConfig = {
      modi = "run,ssh,drun";
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-combi = "";
      show-icons = true;
      line-margin = 10;
      columns = 2;
    };
  };
}
