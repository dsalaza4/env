{ primaryUser, ... }:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };

  nix-homebrew = {
    user = primaryUser.username;
    enable = true;
    autoMigrate = true;
  };

  # Global programs
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
    global.brewfile = true;

    casks = [
      "1password"
      "zoom"
    ];
  };
}
