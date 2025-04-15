{ pkgs, ... }:
let
  bashFunctions = builtins.readFile ./functions.sh;

  nixBashFunctions = pkgs.writeText "bash-functions" ''
    [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"

    ${bashFunctions}

    export -f $(grep -E '^[a-zA-Z0-9_]+\(\)' ${pkgs.writeText "temp" bashFunctions} |
                cut -d'(' -f1 | tr '\n' ' ')
  '';

  aliases = import ./aliases.nix;
  keybindings = builtins.readFile ./keybindings.sh;
  history = builtins.readFile ./history.sh;

  extra = ''
    # Direnv
    eval "$(${pkgs.direnv}/bin/direnv hook bash)"

    # Zoxide
    eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

    # FZF
    source ${pkgs.fzf}/share/fzf/key-bindings.bash
  '';
in {
  home.file.".bash_functions".text = bashFunctions;

  programs.bash = {
    shellAliases = aliases;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      export PATH="$HOME/dotfiles/home/scripts:$PATH"
      source ${nixBashFunctions}

      # Key bindings
      ${keybindings}

      # History
      ${history}

      # Extra config
      ${extra}
    '';
  };
}

