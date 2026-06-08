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

          checks = {
            statix = pkgs.runCommand "statix" { buildInputs = [ pkgs.statix ]; } ''
              statix check ${./.}
              touch $out
            '';
            nixfmt-tree = pkgs.runCommand "nixfmt-tree" { buildInputs = [ pkgs.nixfmt-tree ]; } ''
              treefmt --fail-on-change --no-cache --walk filesystem --tree-root ${./.}
              touch $out
            '';
          };
        };

        flake = {
          inherit (modules) homeManagerModules;

          darwinConfigurations = import ./machines { inherit inputs modules; };
        };
      }
    );
}
