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
        "auto-save-list"
        ".direnv/"
        "node_modules"
        "result"
        "result-*"
      ];

      aliases = {
        check = "checkout";

        a = "add .";
        s = "status";
        c = "commit -m";
        p = "push";

        add = "remote add";
        remove = "remote remove";
      };

      extraConfig = {
        color.ui = "1";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
