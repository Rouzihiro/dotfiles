{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # infinity-glass = {
    #   url = "github:Rouzihiro/infinity-glass-icons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    assets = {
      url = "github:Rouzihiro/assets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yt-x.url = "github:Benexl/yt-x";

    fzf-preview = {
      url = "github:niksingh710/fzf-preview";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    system = "x86_64-linux";

    # Shared variables across all hosts
    commonSettings = {
      username = "rey";
      gitUsername = "Rouzihiro";
      gitEmail = "ryossj@gmail.com";
      shell = "bash";
    };

    hosts = [
      {
        hostname = "HP";
        extra = {
          WM = "sway";
          BT-status = false;
        };
      }
      {
        hostname = "Saber";
        extra = {
					WM = "sway";
          BT-status = true;
        };
      }
      {
        hostname = "MBPro";
        extra = {
					WM = "sway";
					BT-status = false;
        };
      }
    ];

    makeSystem = { hostname, extra ? {} }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = commonSettings // extra // {
        inherit inputs hostname;
      };
      modules = [
        ./hosts/${hostname}
      ];
    };

  in {
    nixosConfigurations = builtins.listToAttrs (
      map (host: {
        name = host.hostname;
        value = makeSystem host;
      }) hosts
    );
  };
}

