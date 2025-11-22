{ pkgs, primaryUser, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = primaryUser.username;
    defaults.dock = {
      autohide = true;
      show-recents = false;
    };
  };

  nix.enable = false; # Determinate Nix required
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Bogota";
  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };
  nix-homebrew = {
    user = primaryUser.username;
    enable = true;
    autoMigrate = true;
  };

  # Global programs
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
    caskArgs.no_quarantine = true;
    global.brewfile = true;

    casks = [
      "1password"
      "raycast"
      "betterdisplay"
    ];
    brews = [ "docker" ];
  };
}
