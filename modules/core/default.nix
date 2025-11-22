{ pkgs, primaryUser, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = primaryUser.username;
    defaults = {
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      NSGlobalDomain = {
        InitialKeyRepeat = 4;
        KeyRepeat = 5;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
      };
    };
  };

  nix.enable = false; # Determinate Nix required
  nixpkgs.config.allowUnfree = true;

  fonts.packages = [ pkgs.nerd-fonts.fira-code ];
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
    ];
  };
}
