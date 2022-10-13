{
  config,
  pkgs,
  ...
}: {
  users.users.dsalazar.packages = [
    # Aliases
    (pkgs.writeShellScriptBin "a" ''
      git add -p "$@"
    '')
    (pkgs.writeShellScriptBin "c" ''
      git commit --allow-empty "$@"
    '')
    (pkgs.writeShellScriptBin "ca" ''
      git commit --amend --allow-empty "$@"
    '')
    (pkgs.writeShellScriptBin "clip" ''
      ${pkgs.xclip}/bin/xclip -sel clip "$@"
    '')
    (pkgs.writeShellScriptBin "f" ''
      git fetch --all "$@"
    '')
    (pkgs.writeShellScriptBin "l" ''
      git log "$@"
    '')
    (pkgs.writeShellScriptBin "p" ''
      git push -f "$@"
    '')
    (pkgs.writeShellScriptBin "ro" ''
      git pull --autostash --progress --rebase --stat origin "$@"
    '')
    (pkgs.writeShellScriptBin "rf" ''
      git pull --autostash --progress --rebase --stat fork "$@"
    '')
    (pkgs.writeShellScriptBin "s" ''
      git status "$@"
    '')

    # Other
    pkgs.direnv
  ];

  programs.bash.interactiveShellInit = ''
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)
  '';
}
