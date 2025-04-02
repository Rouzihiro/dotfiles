{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    font-awesome
    dejavu_fonts
  ];
}
