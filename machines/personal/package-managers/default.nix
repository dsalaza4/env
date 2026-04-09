{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };

  # Global packages that are available to all users.
  programs._1password-gui.enable = true;
}
