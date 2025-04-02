# ~/.config/qtile/qtile-shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "qtile-dev";
  
  packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      qtile
      qtile-extras
      pyyaml        # For YAML config parsing
      xcffib        # Needed for Qtile internals
      dbus-next     # Required for Wayland support
      setproctitle  # Needed for Qtile's process naming
    ]))
    
    # Additional tools for development
    pkgs.nixpkgs-fmt  # Nix formatting
    pkgs.black        # Python formatter
    pkgs.mypy         # Static type checking
  ];

  # Add Qtile config directory to Python path
  shellHook = ''
    export PYTHONPATH="$PYTHONPATH:${builtins.toString ./.}"
    echo "Qtile development shell activated"
    echo "Python path: $PYTHONPATH"
  '';
}
