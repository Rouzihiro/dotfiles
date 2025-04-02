{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qemu_kvm
    #spice-vdagent # For clipboard sharing (optional)
    #swtpm # For TPM emulation (optional)
  ];
}
