{
  config,
  pkgs,
  ...
}: {
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "ALL";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];
  };

  users.users = {
    root = {
      hashedPassword = "$6$NKlUfhjaPNhm263V$GGMcRBxRBIPvTZ9JVAL90a0AvrdnBQbzo6XLERrX1.QxGPbhC7TlcA5Bfqh6k3TsLkd/OpcPplO19o8J6AG7t/";
    };
    nixos = {
      isNormalUser = true;
      hashedPassword = "$6$Cmzt0OYRh1Ra9nCG$52hnMtWek1aWFbCN44T9AmZrFVws4Lus7vvOObgnJWpCtIJs.v0mUYW/3a4SFm3kOxJbbV/xaYoAu9S9Wc8lb0";
      description = "Daniel Salazar";
      home = "/home/nixos";
      group = "users";
      extraGroups = ["wheel"];
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      nixos = {
        programs.home-manager.enable = true;
        targets.genericLinux.enable = true;
        systemd.user.startServices = true;
        home = {
          username = "nixos";
          homeDirectory = "/home/nixos";
          stateVersion = config.system.stateVersion;
        };
      };
    };
  };
}
