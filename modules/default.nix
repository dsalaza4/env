{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew

    ./core
    ./network
    ./users
  ];
}
