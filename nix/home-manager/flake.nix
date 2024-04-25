{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    chaotic,
    home-manager,
    niri,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "primary";
  in {
    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./home.nix
        niri.homeModules.config

        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };

    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        chaotic.nixosModules.default # chaotic nixos

        #Don't annoy me about permitting stuff
        {
          nix.settings.trusted-users = ["${username}"];
        }
      ];
    };
  };
}
