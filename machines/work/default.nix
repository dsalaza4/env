{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ./package-managers
    ./system
    ./users
  ];
}
