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
  };
}
