{
  config,
  lib,
  pkgs,
  hostname,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  name = "zsh";
  category = "shell";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion = {enable = true;};
      syntaxHighlighting = {enable = true;};
      sessionVariables = {
        PROMPT_EOL_MARK = "󱞥";
      };
      shellAliases = import ./shell-aliases.nix {inherit hostname pkgs;};
      initExtra = ''
            autoload -U compinit && compinit
            zstyle ':completion:*' menu select
            zstyle ':completion:*' list-rows-first true
        cc ()
        {
        	if [ -n "$1" ]; then
        		builtin cd "$@" && ls
        	else
        		builtin cd ~ && ls
        	fi
        }
              cpp() {
                set -e
                strace -q -ewrite cp -- "\''${1}" "\''${2}" 2>&1 |
                awk -v total_size="$(stat -c '%s' "\''${1}")" '
                {
                  count += $NF
                  if (count % 10 == 0) {
                    percent = count / total_size * 100
                    printf "%3d%% [", percent
                    for (i=0; i<=percent; i++) printf "="
                    printf ">"
                    for (i=percent; i<100; i++) printf " "
                    printf "]\r"
                  }
                }
                END { print "" }'
              }

              gh() {
                if [ -z "$1" ]; then
                  echo "Error: Commit message is required"
                  return 1
                fi
                git add .
                git commit -m "$1"
                git push
              }
              s() {
                grep --color=auto -rin "$1" .
                }

              ct() {
                cat "$1" | wl-copy
                }

            font() {
              fc-list | grep --color=auto -i "$@"
              }


                  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
                if command -v starship &> /dev/null; then
                  eval "$(starship init zsh)"
                fi
               export PATH="$HOME/dotfiles/home/scripts:$PATH"
               export GPG_TTY=$(tty)

            # Start SSH agent and add the private key if not already loaded
            if ! pgrep -u $USER ssh-agent > /dev/null; then
              eval "$(ssh-agent -s)"
              ssh-add ~/.ssh/HP-Nixo
            fi
      '';
      history = {size = 10000;};
    };
  };
}
