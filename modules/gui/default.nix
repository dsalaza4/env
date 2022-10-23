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
      packages = [
        pkgs.gnome.nautilus
        pkgs.grim
        pkgs.mako
        pkgs.pavucontrol
        pkgs.sway-contrib.grimshot
        pkgs.swayidle
        pkgs.swaylock
        pkgs.wl-clipboard
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
      font = {
        name = "monospace";
        size = 12;
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
