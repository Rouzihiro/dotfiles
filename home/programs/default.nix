{
  imports = let
    dir = ./.;

    files = builtins.attrNames (builtins.readDir dir);

    nixFiles = builtins.filter
      (name:
        builtins.match ".*\\.nix" name != null
        && name != "default.nix"
        && name != "fish-functions.nix"
 				&& name != "shell-aliases.nix"
  			&& name != "yazi-keymaps.nix"				
				&& name != "spicetify.nix"
      )
      files;

  in map (file: import (dir + "/${file}")) nixFiles;
}

