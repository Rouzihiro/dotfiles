{
  imports = let
    dir = ./.;

    files = builtins.attrNames (builtins.readDir dir);

    nixFiles = builtins.filter
      (name:
        builtins.match ".*\\.nix" name != null
        && name != "default.nix"
				&& name != "i3blocks.nix"
      )
      files;

  in map (file: import (dir + "/${file}")) nixFiles;
}

