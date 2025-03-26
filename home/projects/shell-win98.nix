# shell.nix
{ pkgs ? import <nixpkgs> {} }:

let
  wineTricks = pkgs.writeShellScriptBin "winetricks-wrapper" ''
    ${pkgs.winetricks}/bin/winetricks "$@"
  '';
in
pkgs.mkShell {
  name = "win98-gaming";

  buildInputs = with pkgs; [
    wineWowPackages.stable
    winetricks
    pkgsi686Linux.mesa
    pkgsi686Linux.freetype
    pkgsi686Linux.openal
    wineTricks
  ];

  shellHook = ''
    export WINEPREFIX="$HOME/.wine_win98"
    export WINEARCH=win32
    export WINEESYNC=1
    export WINEDEBUG="-all,warn+all"

    if [ ! -d "$WINEPREFIX" ]; then
      echo "Setting up new Windows 98 prefix..."
      wineboot --init
      
      # Install essential components
      winetricks-wrapper --unattended win98 corefonts d3dx9 vd=1024x768
      winetricks-wrapper --unattended hosttime nomousecapture
      
      # Alternative DirectX installation method
      if [ ! -f "$WINEPREFIX/directx_installed" ]; then
        echo "Installing DirectX components..."
        winetricks-wrapper dlls d3dx9_43 ddraw
        touch "$WINEPREFIX/directx_installed"
      fi
    fi

    echo "Windows 98 environment ready in: $WINEPREFIX"
    echo "Run your game with:"
    echo 'wine start /unix "GAME.exe" -windowed'
  '';
}
