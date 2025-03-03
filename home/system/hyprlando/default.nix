{...}: {
  imports = [
    ./needed-packages.nix
    ./monitors.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./window-rules.nix
    ./startup.nix
    ./keybindings.nix
    ./workspace-rules.nix
    ./environment-variables.nix
  ];
}
