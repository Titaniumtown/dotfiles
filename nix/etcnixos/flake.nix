{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org/"
      "https://nyx.chaotic.cx/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    chaotic,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "primary";
  in {
    nixosConfigurations.mreow = nixpkgs.lib.nixosSystem {
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
