{ inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };

  nix = {
    channel.enable = false;
		nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      max-jobs = "auto";
      cores = 0;
      show-trace = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      #experimental-features = ["nix-command" "flakes"];
			experimental-features = [ "nix-command" "flakes" "recursive-nix" "fetch-closure" ];
      use-xdg-base-directories = true;

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://cuda-maintainers.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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
