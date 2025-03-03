{ pkgs }: {
  home.packages = with pkgs; [
    hyprshot
    wev
    wlr-randr
    wdisplays
    gpu-screen-recorder-gtk
    playerctl
    brightnessctl
  ];
}
