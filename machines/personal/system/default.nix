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
        InitialKeyRepeat = 30;
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

  networking = {
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
