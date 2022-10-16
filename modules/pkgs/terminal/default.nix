{
  config,
  pkgs,
  ...
}: {
  home-manager.users.nixos.home.packages = [
    pkgs.direnv
  ];

  programs.bash.interactiveShellInit = ''
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)
  '';
}
