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
        AppleInterfaceStyleSwitchesAutomatically = true;
        ApplePressAndHoldEnabled = true;
        InitialKeyRepeat = 30;
        KeyRepeat = 5;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
      };
    };
  };

  nix.enable = false;

  launchd.daemons.nix-gc = {
    script = ''
      /nix/var/nix/profiles/default/bin/nix-env --delete-generations --profile /nix/var/nix/profiles/system +5
      /nix/var/nix/profiles/default/bin/nix-collect-garbage
      /nix/var/nix/profiles/default/bin/nix-store --optimise
    '';
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Hour = 13;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
    };
  };

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
