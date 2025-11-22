{
  description = "My MacOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew/main";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    darwinConfigurations.default = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./modules ];
      specialArgs = {
        inherit inputs;
        primaryUser = {
          email = "podany270895@gmail.com";
          name = "Daniel Salazar";
          username = "dsalazar";
        };
      };
    };
  };
}
