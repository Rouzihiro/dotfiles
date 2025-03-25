{ pkgs ? import <nixpkgs> {} }:

let
  # Define our custom commands first
  customCommands = pkgs.symlinkJoin {
    name = "iso-commands";
    paths = [
      (pkgs.writeShellScriptBin "mount-iso" ''
        if [ $# -ne 2 ]; then
          echo "Usage: mount-iso <image.iso> <mountpoint>"
          exit 1
        fi
        mkdir -p "$2"
        ${pkgs.fuseiso}/bin/fuseiso "$1" "$2"
        echo "Mounted $1 at $2"
      '')
      
      (pkgs.writeShellScriptBin "bin2iso" ''
        if [ $# -ne 3 ]; then
          echo "Usage: bin2iso <input.bin> <input.cue> <output.iso>"
          exit 1
        fi
        ${pkgs.bchunk}/bin/bchunk "$1" "$2" "$3"
        echo "Converted to ISO: $3"
      '')
      
      (pkgs.writeShellScriptBin "lsiso" ''
        if [ $# -ne 1 ]; then
          echo "Usage: lsiso <image.iso>"
          exit 1
        fi
        ${pkgs.p7zip}/bin/7z l "$1"
      '')
      
      (pkgs.writeShellScriptBin "unmount-iso" ''
        if [ $# -ne 1 ]; then
          echo "Usage: unmount-iso <mountpoint>"
          exit 1
        fi
        ${pkgs.fuse}/bin/fusermount -u "$1"
        echo "Unmounted $1"
      '')
    ];
  };
in
pkgs.mkShell {
  name = "iso-tools";

  buildInputs = [
    pkgs.fuseiso
    pkgs.bchunk
    pkgs.mtools
    pkgs.p7zip
    customCommands  # This makes our commands available
  ];

  shellHook = ''
    echo "📀 ISO Tools Shell Activated"
    echo ""
    echo "Available commands:"
    echo "  mount-iso <image.iso> <mountpoint>  # Mount ISO"
    echo "  bin2iso <input.bin> <input.cue> <output.iso>  # Convert BIN/CUE"
    echo "  lsiso <image.iso>                   # List contents (7z)"
    echo "  unmount-iso <mountpoint>            # Unmount"
    echo ""
  '';
}
