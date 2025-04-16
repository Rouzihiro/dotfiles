{
  pkgs,
  hostname,
  ...
}: let
  bashFunctions = builtins.readFile ./functions.sh;

  nixBashFunctions = pkgs.writeText "bash-functions" ''
    [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"

    ${bashFunctions}

    export -f $(grep -E '^[a-zA-Z0-9_]+\(\)' ${pkgs.writeText "temp" bashFunctions} |
                cut -d'(' -f1 | tr '\n' ' ')
  '';

  aliases = import ../shell-aliases.nix {inherit hostname;};
  keybindings = builtins.readFile ./keybindings.sh;
  history = builtins.readFile ./history.sh;

  extra = ''
       # Direnv
       eval "$(${pkgs.direnv}/bin/direnv hook bash)"

       # Zoxide
       eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

       # FZF
       source ${pkgs.fzf}/share/fzf/key-bindings.bash

       # Atuin without up arrow override
      eval "$(${pkgs.atuin}/bin/atuin init bash --disable-up-arrow)"

       # TheFuck
       eval "$(${pkgs.thefuck}/bin/thefuck --alias)"

       # Carapace completions
       source <(${pkgs.carapace}/bin/carapace _carapace bash)
    	 # Enable FFmpeg completions
			 source <(carapace gen ffmpeg)

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
