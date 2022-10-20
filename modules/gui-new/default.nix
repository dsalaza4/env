{pkgs, ...}: {
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
    home.packages = [
      pkgs.gnome.nautilus
      pkgs.swaylock
      pkgs.swayidle
      pkgs.wl-clipboard
      pkgs.mako
      pkgs.alacritty
      pkgs.wofi
      pkgs.waybar
    ];
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        terminal = "alacritty";
        menu = "wofi --show run";
        bars = [
          {
            fonts.size = 12.0;
            command = "waybar";
            position = "bottom";
          }
        ];
        fonts = {
          names = ["monospace"];
          size = 12.0;
        };
        input."*" = {
          xkb_layout = "us,latam";
          xkb_options = "grp:win_space_toggle";
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          middle_emulation = "enabled";
        };
        output.eDP-1.scale = "1.0";
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
