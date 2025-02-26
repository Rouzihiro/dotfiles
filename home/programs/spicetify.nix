{ inputs, pkgs, ... }:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
    ];
  };
}
