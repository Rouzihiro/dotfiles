{
  description = "DOSBox Game Manager";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    gamesDir = "$HOME/Games/dosgames";
    
    dosrunScript = pkgs.writeShellScriptBin "dosrun" ''
      GAME_DIR="${gamesDir}"
      GAME_NAME="$1"
      EXECUTABLE="''${2:-START.EXE}"
      REAL_GAME_DIR=$(realpath "$GAME_DIR")
      SAVE_DIR="$REAL_GAME_DIR/$GAME_NAME/saves"

      # Validation checks
      if [ ! -d "$REAL_GAME_DIR" ]; then
        echo "Error: Missing games directory at $GAME_DIR"
        echo "Create it with: mkdir -p ~/Games/dosgames"
        exit 1
      fi

      if [ -z "$GAME_NAME" ]; then
        echo "Available games:"
        ls -1 "$REAL_GAME_DIR" | sed 's/^/  • /'
        echo ""
        echo "Usage: dosrun <game-folder> [executable]"
        exit 0
      fi

      if [ ! -d "$REAL_GAME_DIR/$GAME_NAME" ]; then
        echo "Game folder not found: $REAL_GAME_DIR/$GAME_NAME"
        echo "Available games:"
        ls -1 "$REAL_GAME_DIR" | sed 's/^/  • /'
        exit 1
      fi

      if [ ! -f "$REAL_GAME_DIR/$GAME_NAME/$EXECUTABLE" ]; then
        echo "Executable not found: $REAL_GAME_DIR/$GAME_NAME/$EXECUTABLE"
        echo "Try one of these:"
        find "$REAL_GAME_DIR/$GAME_NAME" -maxdepth 1 -type f \( -iname "*.exe" -o -iname "*.com" -o -iname "*.bat" \) -printf '  • %f\n'
        exit 1
      fi

      # Prepare save directory
      mkdir -p "$SAVE_DIR"

      # Launch game
      echo "🕹️ Launching $GAME_NAME/$EXECUTABLE..."
      echo "💾 Save location: $SAVE_DIR"
      cd "$REAL_GAME_DIR/$GAME_NAME"
      dosbox -nocontroller \
        -c "mount c ." \
        -c "mount s $SAVE_DIR" \
        -c "config -writeconf dosbox.conf" \
        -c "c:" \
        -c "$EXECUTABLE" \
        -c "exit"
    '';
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "dosbox-manager";
      
      buildInputs = [
        pkgs.dosbox
        pkgs.findutils
        dosrunScript
      ];

      shellHook = ''
        echo "🎮 DOSBox Manager Ready"
        echo "Games directory: ${gamesDir}"
        echo ""
        echo "Usage:"
        echo "  dosrun <game-folder>       # Launch START.EXE"
        echo "  dosrun <game> <executable> # Launch specific EXE"
        echo ""
        echo "Example:"
        echo "  dosrun Theme-Hospital HOSPITAL.EXE"
        echo ""
        echo "Available games:"
        if [ -d "${gamesDir}" ]; then
          ls -1 "${gamesDir}" | sed 's/^/  • /'
        else
          echo "  (Create ${gamesDir} and add game folders)"
        fi
      '';
    };
  };
}
