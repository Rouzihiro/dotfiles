{ pkgs, username, ... }:
let

  inherit (import ./variables.nix) shell;
in
{
  users.users.${username} = {
    shell = pkgs.${shell};
  };

  #programs.${shell} = {
  #  enable = true;
  #};
}
