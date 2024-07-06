{ config, pkgs, ... }:

# installation of Cemu and its obviously necessary files

{
  environment.systemPackages = with pkgs; [
    clang
    cmake
    curl
    freeglut
    #gtk3
    libgcrypt
    libsecret
    nasm
    ninja
    pulseaudio
    systemd
  ];
}
