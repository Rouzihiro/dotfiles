{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
		nerd-fonts.jetbrains-mono
		nerd-fonts.caskaydia-cove
		cascadia-code
    font-awesome
    dejavu_fonts
  ];
}
