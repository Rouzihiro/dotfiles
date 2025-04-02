# ~/.config/qtile/shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "qtile-config-dev";

  buildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [
      qtile
      qtile-extras
      pyyaml
      mypy
      types-setuptools
      types-pyyaml
      xcffib
      dbus-next
      setproctitle
    ]))
    pkgs.nixpkgs-fmt
    pkgs.black
  ];

  shellHook = ''
    # Add Qtile's Python packages to MYPY path
    export MYPYPATH="${pkgs.python3.sitePackages}"
    
    # Add local config directory to Python path
    export PYTHONPATH="$PYTHONPATH:${builtins.toString ./.}"
    
    # Create .pyi stub if missing
    if [ ! -f config.pyi ]; then
      echo "Creating basic type stub..."
      echo "# Minimal type hints for Qtile config" > config.pyi
      echo "from libqtile.config import Key, Group, Screen, Drag, Match" >> config.pyi
      echo "from libqtile.layout.base import Layout" >> config.pyi
      echo "from libqtile.bar import Bar" >> config.pyi
    fi

    echo "Qtile development shell ready!"
    echo "Commands available:"
    echo "  - qtile check: Validate config syntax"
    echo "  - black .: Format Python files"
    echo "  - nixpkgs-fmt *.nix: Format Nix files"
    echo "  - mypy --config-file mypy.ini *.py: Run type checks"
  '';
}
