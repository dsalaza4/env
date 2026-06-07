{
  description = "My MacOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      let
        modules = import ./modules;
      in
      {
        systems = [ "aarch64-darwin" ];

        perSystem = { pkgs, ... }: {
          packages = modules.packages pkgs;
        };

        flake = {
          homeManagerModules = modules.homeManagerModules;

          darwinConfigurations = {
            personal = inputs.nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              modules = [
                ./machines/personal
                { home-manager.sharedModules = modules.sharedModules; }
              ];
              specialArgs = {
                inherit inputs;
                primaryUser = {
                  email = "podany270895@gmail.com";
                  name = "Daniel Salazar";
                  username = "dsalazar";
                };
              };
            };
            work = inputs.nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              modules = [
                ./machines/work
                { home-manager.sharedModules = modules.sharedModules; }
              ];
              specialArgs = {
                inherit inputs;
                primaryUser = {
                  email = "dsalazar@fluidattacks.com";
                  name = "Daniel Salazar";
                  username = "dsalazar";
                };
              };
            };

            test = inputs.nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              modules = [ ./machines/test ];
              specialArgs = { inherit inputs; };
            };
          };
        };
      }
    );
}
