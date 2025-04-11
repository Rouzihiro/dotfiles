{pkgs, ...}: let
  inherit (import ../../nixos/modules/variables.nix) gitUsername gitEmail;
in {
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
        "compile_commands.json"
        "*.gc??"
        "vgcore.*"
        "venv"
        "*~"
        ".direnv"
        ".envrc"
        ".idea"
        ".vscode"
        ".vs"
      ];

      aliases = {
      };

      extraConfig = {
        core = {
          #abbrev = "8";
          #editor = "nvim";
          whitespace = "fix,trailing-space,cr-at-eol,-space-before-tab,indent-with-non-tab";
        };
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
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
