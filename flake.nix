{
  description = "My NixOS System configuration";

  inputs = {
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
              ./modules
            ];
          }
        ];
      };
    };
  };
}
