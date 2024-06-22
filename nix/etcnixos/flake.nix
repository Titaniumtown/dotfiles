{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  nixConfig = {
    extra-substituters = [ "https://nyx.chaotic.cx/" ];
    extra-trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "primary";
      hostname = "mreow";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.framework-12th-gen-intel
        ];
      };
    };
}
