{
  pkgs,
  timedoctor,
  ...
}: {
  home-manager.users.nixos.home.packages = [
    (pkgs.writeShellScriptBin "timedoctor" ''
      ${timedoctor}/bin/timedoctor "$@" &> /dev/null &!
      exit 0
    '')
  ];
}
