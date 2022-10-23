{pkgs, ...}: {
  home-manager.users.nixos = {
    services.kanshi = {
      enable = true;
      profiles = let
        moveSession = output: "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to ${output}";
      in {
        home = {
          exec = [(moveSession "DP-2")];
          outputs = [
            {
              criteria = "DP-2";
              status = "enable";
              mode = "2560x1080@75Hz";
            }
            {
              criteria = "eDP-1";
              status = "disable";
              mode = "1920x1080@60Hz";
            }
          ];
        };
        undocked = {
          exec = [(moveSession "eDP-1")];
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1080@60Hz";
            }
          ];
        };
      };
    };
    home.packages = [
      pkgs.kanshi
    ];
  };
}
