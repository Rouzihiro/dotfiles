{pkgs, ...}: {
  qt.style = "adwaita-dark";

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
  };

  zsh.enable = true;

  nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc
      zlib
      stdenv.cc.cc.lib # C++ standard library
      vulkan-loader # For Vulkan apps
    ];
  };
}
