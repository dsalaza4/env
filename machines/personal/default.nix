{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ./package-managers
    ./users
  ];

}
