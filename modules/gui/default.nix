{pkgs, ...}: {
  services = {
    gnome = {
      core-utilities.enable = false;
      games.enable = false;
    };
    xserver = {
      enable = true;
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          middleEmulation = true;
          tapping = true;
        };
      };
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager.gnome.enable = true;
    };
  };

  fonts = {
    enableDefaultFonts = false;
    fontDir.enable = true;
    fonts = [
      pkgs.noto-fonts-emoji
      pkgs.twitter-color-emoji
      pkgs.fira-code
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Fira Code"];
        sansSerif = ["Fira Code"];
        serif = ["Fira Code"];
        emoji = [
          "Twitter Color Emoji"
          "Noto Color Emoji"
        ];
      };
    };
  };
  home-manager.users.nixos = {
    home = {
      keyboard = {
        layout = "us,latam";
        options = ["grp:win_space_toggle"];
      };
    };
    gtk = {
      enable = true;
      font = {
        name = "monospace";
        size = 12;
      };
    };
  };
}
