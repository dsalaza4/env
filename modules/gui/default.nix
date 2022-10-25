{pkgs, ...}: {
  imports = [
    ./kanshi.nix
    ./rofi.nix
    ./sway.nix
    ./waybar.nix
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  programs.dconf.enable = true;
  security.pam.services.swaylock.text = "auth include login";
  users.users.nixos.extraGroups = ["video"];

  fonts = {
    enableDefaultFonts = false;
    fontDir.enable = true;
    fonts = [
      pkgs.noto-fonts-emoji
      pkgs.twitter-color-emoji
      (pkgs.nerdfonts.override
        {
          fonts = [
            "FiraCode"
          ];
        })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["FiraCode Nerd Font"];
        sansSerif = ["FiraCode Nerd Font"];
        serif = ["FiraCode Nerd Font"];
      };
    };
  };

  home-manager.users.nixos = {
    home = {
      packages = [
        pkgs.gnome.nautilus
      ];
      pointerCursor = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors-white";
        size = 20;
        gtk.enable = true;
        x11.enable = true;
      };
    };
    gtk = {
      enable = true;
      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };
      font = {
        name = "monospace";
        size = 12;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
