{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    infinity-glass = {
      url = "github:Rouzihiro/infinity-glass-icons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    assets = {
      url = "github:Rouzihiro/assets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yt-x.url = "github:Benexl/yt-x";

    fzf-preview = {
      url = "github:niksingh710/fzf-preview";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations = {
      HP = nixpkgs.lib.nixosSystem {
        modules = [./hosts];
        specialArgs = {
          inherit inputs;
          username = "rey";
          hostname = "HP";
        };
      };

      MBPro = nixpkgs.lib.nixosSystem {
        modules = [./hosts];
        specialArgs = {
          inherit inputs;
          username = "rey";
          hostname = "MBPro";
        };
      };

      server = nixpkgs.lib.nixosSystem {
        modules = [./hosts];
        specialArgs = {
          inherit inputs;
          username = "rey";
          hostname = "server";
        };
      };
    };
  };
}
