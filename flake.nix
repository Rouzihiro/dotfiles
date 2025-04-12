{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # catppuccin = {
    #   url = "github:catppuccin/nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # infinity-glass = {
    #   url = "github:Rouzihiro/infinity-glass-icons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
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

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "rey";
    hosts = [
      {hostname = "HP";}
      {hostname = "Saber";}
      {hostname = "MBPro";}
      # Add more hosts as needed
    ];

    makeSystem = {hostname}:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username hostname;
        };
        modules = [
          ./hosts/${hostname}
        ];
      };
  in {
    nixosConfigurations =
      builtins.listToAttrs
      (map (host: {
          name = host.hostname;
          value = makeSystem host;
        })
        hosts);
  };
}
