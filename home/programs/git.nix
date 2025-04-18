{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (import ../../nixos/modules/variables.nix) gitUsername gitEmail; 

  name = "lazygit";
  category = "dev";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs = {
      ${name}.enable = true;
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

        extraConfig = {
          core = {
            whitespace = "fix,trailing-space,cr-at-eol,-space-before-tab,indent-with-non-tab";
          };
          url = {
            "ssh://git@github.com/".insteadOf = "https://github.com/";
          };
          color.ui = "auto";
          init.defaultBranch = "current";
          push.autoSetupRemote = true;

          commit = {
            verbose = true;
            template = builtins.toString (pkgs.writeText "git-commit-template" ''
              # Fix: Resolve

              # - Fixed
              # - Added error handling for invalid input.
              # -----------------
            '');
          };
        };
      };
    };
  };
}
