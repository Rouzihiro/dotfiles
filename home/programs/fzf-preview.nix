{ pkgs, inputs, lib, ... }:

let
  fzfPreview = inputs.fzf-preview;
in {
  home.packages = [
    fzfPreview.packages.${pkgs.system}.default
  ];

  home.sessionVariables.FZF_DEFAULT_OPTS = lib.mkForce ''
    --preview='${fzfPreview.packages.${pkgs.system}.default}'
  '';
}

