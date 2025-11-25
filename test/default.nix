{ inputs, pkgs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  nix.enable = false;
  system.stateVersion = 6;
  users.users.runner.home = "/Users/runner";
  home-manager.users.runner.home = {
    stateVersion = "25.11";
    packages = [ pkgs.just ];
  };
}
