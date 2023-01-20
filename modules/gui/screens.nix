# To see display options, use xrandr
# To create mirror displays, use wl-mirror <output>
{pkgs, ...}: {
  home-manager.users.nixos = {
    services.kanshi = {
      enable = true;
      profiles = {
        home-studio.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "1920,0";
          }
        ];
        home-workstation.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-2";
            status = "enable";
            mode = "2560x1080@75Hz";
            position = "0,0";
          }
        ];
        undocked.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }
        ];
      };
    };
    home.packages = [
      pkgs.kanshi
      pkgs.xorg.xrandr
      pkgs.wl-mirror
    ];
  };
}
