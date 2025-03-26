{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # dosbox
    # retroarchFull
    # cemu  # Ensure it runs with X11 backend if needed
    # dolphin-emu
    # dolphin-emu-primehack
    # suyu
    # ryujinx
    # ryujinx-greemdev
    # ryubing
  ];
}
