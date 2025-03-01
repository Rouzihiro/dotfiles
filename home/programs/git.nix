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
      #signing = {
      #key = "$(cat ~/.ssh/HP.Nixo.pub)";
      #signByDefault = true;
    #};
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
      
      };

      extraConfig = {
        #color.ui = "1";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
