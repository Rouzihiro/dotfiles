# This Nix shell environment sets up a Python environment with Qtile and its extras
# to help fix import errors while editing code. It ensures that Qtile dependencies
# are available for development.
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      (pkgs.python3.withPackages (python-pkgs:
        with python-pkgs; [
          qtile
          qtile-extras
        ]))
    ];
  }
