{
  description = "My NixOS System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homeManager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    makes = {
      url = "github:fluidattacks/makes/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    timedoctor = {
      url = "gitlab:fluidattacks/timedoctor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pythonOnNix = {
      url = "github:on-nix/python/main";
      inputs.makes.follows = "makes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          editor = pkgs.vscode;
          makes = attrs.makes;
          makesPkg = attrs.makes.packages.${system}.default;
          pythonOnNix = attrs.pythonOnNix.packages.${system};
          swayModifier = "Mod4";
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
