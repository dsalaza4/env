{
  config,
  pkgs,
  ...
}: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    users.dsalazar.home.stateVersion = config.system.stateVersion;
  };

  users.users.root = {
    hashedPassword = "$6$NKlUfhjaPNhm263V$GGMcRBxRBIPvTZ9JVAL90a0AvrdnBQbzo6XLERrX1.QxGPbhC7TlcA5Bfqh6k3TsLkd/OpcPplO19o8J6AG7t/";
  };
  users.users.dsalazar = {
    isNormalUser = true;
    hashedPassword = "$6$Cmzt0OYRh1Ra9nCG$52hnMtWek1aWFbCN44T9AmZrFVws4Lus7vvOObgnJWpCtIJs.v0mUYW/3a4SFm3kOxJbbV/xaYoAu9S9Wc8lb0";
    description = "Daniel Salazar";
    home = "/home/dsalazar";
    group = "users";
    extraGroups = ["wheel"];
  };
}
