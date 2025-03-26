{ pkgs ? import <nixpkgs> {} }:

let
  gamesDir = "$HOME/Games/dosgames";
  
  dosrunScript = pkgs.writeShellScriptBin "dosrun" ''
    GAME_DIR="${gamesDir}"
    GAME_NAME="$1"
    EXECUTABLE="''${2:-START.EXE}"
    REAL_GAME_DIR=$(realpath "$GAME_DIR")

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

    echo "🕹️ Launching $GAME_NAME/$EXECUTABLE..."
    cd "$REAL_GAME_DIR/$GAME_NAME"
    dosbox -c "mount c ." -c "c:" -c "$EXECUTABLE" -c "exit"
  '';
in
pkgs.mkShell {
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
}
