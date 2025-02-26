{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # DEV
    python3
    gcc
    ccache
    # MEDIA
    mpv
    imv
    pwvucontrol

    # CONNECTIONS
    #overskride
    #protonvpn-cli_2
    networkmanagerapplet

    # APPS
    notes
    #aerc
    #tor-browser
    #ungoogled-chromium
    chromium

    #nautilus
    #file-roller
    keepassxc

    #element-desktop
    whatsapp-for-linux
    #zapzap
    qalculate-gtk

    gpu-screen-recorder-gtk

    #ventoy-full
  ];
}
