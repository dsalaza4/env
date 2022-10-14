{pkgs, ...}: {
  services.xserver = {
    enable = true;
    layout = "us,latam";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome.enable = true;
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
  home-manager.users.dsalazar = {
    gtk = {
      enable = true;
      font = {
        name = "monospace";
        size = 12;
      };
    };
  };
}
