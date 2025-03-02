{pkgs, ...}: {
  home.packages = let
    # Get the directory containing this file
    dir = ./.;

    # List all files in the directory
    files = builtins.attrNames (builtins.readDir dir);

    # Filter to only include .nix files and exclude this file
    nixFiles =
      builtins.filter (
        name:
          builtins.match ".*\\.nix" name
          != null
          && name != "default.nix" # Assuming this is default.nix
      )
      files;

    # Import each .nix file with pkgs
    importFile = file: import (dir + "/${file}") {inherit pkgs;};

    # Map the import function over all filtered files
    packages = builtins.map importFile nixFiles;
  in
    packages;
}
