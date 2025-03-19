{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (cores:
      with cores; [
        dosbox # DOS
        mupen64plus # N64
        desmume # NDS
        snes9x # SNES
        fceumm # NES
        ppsspp # PSP
        dolphin # GameCube/Wii
        genesis-plus-gx
        beetle-psx-hw
      ]))
  ];
}
