{
  description = "My MacOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    darwinConfigurations.default = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        inputs.home-manager.darwinModules.home-manager
        ./modules
      ];
    };
  };
}
