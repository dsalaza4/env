{
  description = "My NixOS System configuration";

  inputs = {

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    timedoctor.url = "gitlab:kamadoatfluid/timedoctor";
    timedoctor.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }@attrs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true;  };
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system pkgs;

        specialArgs = {
          timedoctor = attrs.timedoctor.packages.${system}.default;
        };

        modules = [
          {
            imports = [
              attrs.homeManager.nixosModules.home-manager
              ./modules
            ];
          }
        ];
      };
    };
  };
}
