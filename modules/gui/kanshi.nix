{pkgs, ...}: {
  home-manager.users.nixos = {
    services.kanshi = {
      enable = true;
      profiles = {
        home.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
            mode = "1920x1080@60Hz";
          }
          {
            criteria = "DP-2";
            status = "enable";
            mode = "2560x1080@75Hz";
          }
        ];
        undocked.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080@60Hz";
          }
        ];
      };
    };
    home.packages = [
      pkgs.kanshi
    ];
  };
}
