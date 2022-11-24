{pkgs, ...}: {
  home-manager.users.nixos = {
    services.kanshi = {
      enable = true;
      profiles = {
        home-studio.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "3840x2160@60Hz";
            position = "0,0";
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
    ];
  };
}
