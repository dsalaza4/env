{
  pkgs,
  timedoctor,
  ...
}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "timedoctor" ''
      ${timedoctor}/bin/timedoctor "$@" &> /dev/null &!
      exit 0
    '')
  ];
}
