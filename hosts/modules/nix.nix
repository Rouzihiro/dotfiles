{...}: {
  # ---------------------------------------------------------
  # Nix
  # ---------------------------------------------------------

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };

  nix = {
    channel.enable = false;
    # registry.nixpkgs.flake = nixpkgs;

    optimise = {
      automatic = true;
      dates = ["daily"];
    };

    settings = {
      show-trace = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = false;
      # warn-dirty = false;
      # keep-outputs = true;
      # keep-derivations = true;
      # package = pkgs.nixVersions.stable;
      substituters = [
        "https://cache.nixos.org/"
        "https://chaotic-nyx.cachix.org/"
        "https://cachix.cachix.org"
        "https://anyrun.cachix.org"
        "https://nix-community.cachix.org/"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-gaming.cachix.org/"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };
}
