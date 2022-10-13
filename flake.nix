{
  description = "My NixOS System configuration";

  inputs = {
    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    makes.url = "github:fluidattacks/makes/main";
    makes.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    timedoctor.url = "gitlab:kamadoatfluid/timedoctor";
    timedoctor.inputs.nixpkgs.follows = "nixpkgs";

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ...} @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system pkgs;

        specialArgs = {
          alejandra = attrs.alejandra.defaultPackage.${system};
          makes = import "${attrs.makes}/src/args/agnostic.nix" {inherit system;};
          makesSrc = attrs.makes;
          pythonOnNix = attrs.pythonOnNix.packages.${system};
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
