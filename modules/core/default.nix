{ pkgs, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = "dsalazar";
    defaults.dock.show-recents = false;
  };

  nix.enable = false; # Determinate Nix required
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };

  time.timeZone = "America/Bogota";
  security.pam.services.sudo_local.touchIdAuth = true;

  # Global programs
  programs = {
    _1password-gui.enable = true;
  };
}
