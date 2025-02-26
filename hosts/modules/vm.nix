{ pkgs, username, ... }:
{
  users.users.${username}.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;

  # services = { spice-vdagentd.enable = true; };

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
        package = pkgs.qemu_kvm;

        verbatimConfig = ''
          memory_backing_dir = "/dev/shm"
          security_driver = "selinux"
          remember_owner = 0
        '';

        ovmf = {
          enable = true;
          packages = [ (pkgs.OVMF.override { secureBoot = true; tpmSupport = true; }).fd ];
        };
      };
    };
  };
}

