{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew

    ./package-managers
    ./system
    ./users
  ];
}
