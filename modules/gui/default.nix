{
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
}
