{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ../../nixos/drivers/intel-drivers.nix
    ../../nixos/gaming
    ../../nixos/modules/ly.nix
    ../../nixos/modules/configuration.nix
    ../../nixos/modules/shell.nix
    ../../nixos/modules/nix.nix
    ../../nixos/modules/bluetooth.nix
    ../../nixos/modules/users.nix
    ../../nixos/modules/zram.nix
    ../../nixos/modules/network.nix
    ../../nixos/modules/nh.nix
    ../../nixos/modules/time.nix
    ../../nixos/modules/sound.nix
    ../../nixos/modules/fonts.nix
    ../../nixos/modules/polkit.nix
    ../../nixos/modules/sway.nix
    #../../nixos/modules/hyprland-uwsm.nix
		#../../nixos/modules/qtile.nix
		#../../nixos/modules/i3.nix
    # ../../nixos/modules/android.nix
    ../../nixos/modules/tlp.nix
    # ../../nixos/modules/samba.nix
    ../../nixos/modules/nas.nix
    # ../../nixos/modules/iphone.nix
    #../../nixos/modules/fstrim.nix
    #../../nixos/modules/ssh.nix
    #../../nixos/modules/vm.nix
    #../../nixos/modules/adb.nix
    #../../nixos/modules/fstrim.nix
  ];
}
