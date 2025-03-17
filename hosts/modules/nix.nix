{...}: {
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };

  nix = {
    channel.enable = false;

    settings = {
      max-jobs = "auto";
      cores = 0;
      show-trace = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = true;

      substituters = [
        "https://cache.nixos.org/"
        "https://anyrun.cachix.org"
        "https://nix-community.cachix.org/"
        "https://cuda-maintainers.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };

    optimise = {
      automatic = true;
      dates = ["daily"];
    };
  };
}
