{pkgs, ... }:

let
  inherit (import ../../hosts/modules/variables.nix) gitUsername gitEmail;
in
  {
  programs = {
    lazygit.enable = true;
    git = {
      enable = true;
      userName = "${gitUsername}";
      userEmail = "${gitEmail}";
      ignores = [
        ".cache/"
        ".DS_Store"
        ".idea/"
        "*.swp"
        "*.elc"
        ".zip"
        "auto-save-list"
        ".direnv/"
        "node_modules"
        "result"
        "result-*"
      ];

      aliases = {
      
      };

      extraConfig = {
          core = {
          #abbrev = "8";
          #editor = "nvim";
          whitespace = "fix,trailing-space,cr-at-eol,-space-before-tab,indent-with-non-tab";
        };
        color.ui = "auto";
        init.defaultBranch = "current";
        push.autoSetupRemote = true;

        commit = {
        verbose = true;
        template = "${pkgs.writeText "git-commit-template" ''

          #Fix: Resolve

          # - Fixed 
          # - Added error handling for invalid input.
          # -----------------
        ''}";
      };
      };
    };
  };
}
