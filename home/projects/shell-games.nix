{ pkgs ? import <nixpkgs> {} }:

let
  wineStaging = pkgs.wineWowPackages.staging.override {
    wineBuild = "wineWow";  # 32+64-bit support
    mingwSupport = true;    # Better Windows DLL compatibility
  };
in
pkgs.mkShell {
  name = "wine-gaming";

  buildInputs = [
    wineStaging
    pkgs.winetricks
    pkgs.xorg.libX11       # X11 base
    pkgs.xorg.libXext      # Extended X11
    pkgs.xorg.libXcursor   # Cursor support
    pkgs.xorg.libXrandr    # Resolution switching
    pkgs.xorg.libXi        # Input handling
    pkgs.freetype          # Font rendering
    pkgs.gnutls            # HTTPS/Networking
    pkgs.mpg123            # Audio codecs
    pkgs.openal            # 3D audio
  ];

  shellHook = ''
    echo "=== Wine Gaming Shell ==="
    echo "Wine Staging: $(wine --version)"
    echo "Winetricks: $(winetricks --version)"
    echo ""

    # Configure Wine environment
    export WINEPREFIX="$PWD/.wineprefix"  # Local prefix
    export WINEARCH=win32                 # Force 32-bit for old games
    export WINEDEBUG="-all"               # Suppress debug logs (optional)
    export WINEESYNC=1                    # Better performance (if kernel supports it)
    export WINEFSYNC=1                    # Even better performance (Linux 5.16+)

    # Initialize Wine prefix if missing
    if [ ! -d "$WINEPREFIX" ]; then
      echo "Setting up new Wine prefix..."
      wine wineboot
      
      # Install critical dependencies
      winetricks -q \
        corefonts \       # Fix missing fonts
        vcrun2008 \      # Visual C++ 2008 runtime
        d3dx9_43 \       # Direct3D 9 support
        xact \           # Audio fixes
        d3dcompiler_43 \ # More Direct3D
        win7             # Set Windows 7 compatibility

      # Disable CSMT if graphical glitches occur (uncomment if needed)
      # wine reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v UseGLSL /t REG_SZ /d disabled /f
      
      echo "Wine prefix ready at $WINEPREFIX"
    else
      echo "Using existing Wine prefix at $WINEPREFIX"
    fi

    # Post-setup tips
    echo ""
    echo "=== Quick Start ==="
    echo "Run the game:   wine ./GAME.EXE"
    echo "Configure Wine: winecfg"
    echo "Debug output:   export WINEDEBUG=warn+all"
    echo "Reset prefix:   rm -rf .wineprefix"
  '';
}
