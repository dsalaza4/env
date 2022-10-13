{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver = {
    layout = "us,latam";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
  };
}
