{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.stable
        pkgs.winetricks
      ];
    })
  ];

  # Intel GPU drivers (complementary to your existing config)
  #hardware.opengl.extraPackages = with pkgs; [
  #  intel-compute-runtime
  #];
}
