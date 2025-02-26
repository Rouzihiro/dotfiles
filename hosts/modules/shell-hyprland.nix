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
    loginShellInit = ''
      # Start Hyprland on TTY1
      if [ "$(tty)" = "/dev/tty1" ]
        set -x WLR_RENDERER vulkan
        exec hyprland
      end
    '';
  };
}
