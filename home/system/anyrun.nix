{ inputs, pkgs, ... }:
let
  variables = import ../../hosts/modules/variables.nix; 
  theme = variables.currentTheme;    
in
{
  imports = [ inputs.anyrun.homeManagerModules.anyrun ];

  programs.anyrun = {
    enable = true;
    package = pkgs.anyrun;

    config = {
      x.fraction = 0.5;
      y.fraction = 0.0;
      width.fraction = 0.3;

      layer = "overlay";
      closeOnClick = true;
      hidePluginInfo = true;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [ applications ];
    };

    extraCss =
      ''
        window { background: transparent; }
        #entry {
          border: 2px solid #${theme.base0D}; 
          background: #${theme.base00};
          border-radius: 0px;
        }
      '';
  };
}
