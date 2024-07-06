{ config, pkgs, ... }:
{

 #Allow unfree packages
 nixpkgs.config.allowUnfree = true;
 #services.devmon.enable = true;
 #services.gvfs.enable = true;
 #services.udisks2.enable = true;
 #services.nfs.client.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

#appimagekit
#appimage-run
#audacious
#autoconf
#binutils
#brave
#calibre
#callPackage
#cider
#cifs-utils #network sharing
#clang
#cmake
#corefonts
#coreutils
#curl
#dconf
#distrobox
#dmidecode
#evolutionWithPlugins
#ffmpeg
#fetchFromGitHub
#fetchpatch
#filezilla
firefox
#freefilesync
#fuse
#gcc
#gh
#gimp
#git
#glib
#glxinfo
#gnumake
#imagemagick
#killall
#libclang
#libreoffice-fresh
#llvm
mpv
neofetch
#ntfs3g
#nfs-utils
#obs-studio
#onlyoffice-bin
#openshot-qt
#openvpn
#openssl
#pantheon-tweaks
#pciutils
#podman
#powershell
#protonup-ng
#python311
#python311Packages.pip
#qbittorrent
#rar
#samba
#screenfetch
#shortwave
#stdenv
#swaycons
#synergy
#transmission
#transmission-qt
#ulauncher
#unrar
#uget
#unzip
#virtualglLib
#virt-manager
#vlc
#wget
#xclip
#xorg.xinit
#ytmdesktop
#zoom-us

  ];
}
