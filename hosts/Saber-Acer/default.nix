{
  imports = [
    ./hardware-configuration.nix
    ./nvidia-prime-drivers.nix
    ../modules/boot.nix
    ../modules/ly.nix
    ../modules/configuration.nix
    ../modules/shell.nix
    ../modules/nix.nix
    ../modules/bluetooth.nix
    ../modules/users.nix
    ../modules/zram.nix
    ../modules/network.nix
    ../modules/nh.nix
    ../modules/time.nix
    ../modules/sound.nix
    # ../modules/fonts.nix
    ../modules/polkit.nix
    ../modules/sway.nix
    # ../modules/hyprland-uwsm.nix
    # ../modules/android.nix
    ../modules/tlp.nix
    ../modules/gaming
    # ../modules/samba.nix
    # ../modules/iphone.nix
    #../modules/fstrim.nix
    #../modules/ssh.nix
    #../modules/vm.nix
    #../modules/adb.nix
    #../modules/fstrim.nix
  ];
}
