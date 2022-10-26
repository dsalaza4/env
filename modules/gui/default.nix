{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./kanshi.nix
    ./lock.nix
    ./mako.nix
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
  users.users.nixos.extraGroups = ["video"];

  home-manager.users.nixos = {
    home = {
      packages = [
        pkgs.gnome.nautilus
        pkgs.xdg-utils
      ];
      pointerCursor = {
        package = pkgs.dracula-theme;
        name = "Dracula-cursors";
        size = 12;
        gtk.enable = true;
        x11.enable = true;
      };
    };
    gtk = {
      # Themes stored in /etc/profiles/per-user/nixos/share/themes
      enable = true;
      theme = {
        package = pkgs.whitesur-gtk-theme;
        name = "WhiteSur-Dark";
      };
      font = {
        name = "monospace";
        size = 12;
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
