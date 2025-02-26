{ pkgs, username, ... }:
let

  inherit (import ../../hosts/modules/variables.nix) shell;
in
{
  users.users.${username} = {
    shell = pkgs.${shell};
  };

  programs.${shell} = {
    enable = true;
    loginShellInit = ''[ "$(tty)" = "/dev/tty1" ] && export WLR_RENDERER=vulkan && exec sway '';
    #autosuggestions.enable = true; #actrivate these two for zsh
    #syntaxHighlighting.enable = true;

      };
}

