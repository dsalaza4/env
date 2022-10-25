{pkgs, ...}: let
  interpreter = pkgs.python310.withPackages (p:
    with p; [
      i3ipc
    ]);
  script = builtins.fetchurl {
    url = "https://gitlab.com/wef/dotfiles/-/raw/f93d85e4f90fd7a92d52b8d6a53ad34f649f69fc/bin/sway-toolwait";
    sha256 = "14z8gkzffi0f9ifyxfnikxc91mvgypyv8mr151kc98s3p9nvd9yw";
  };
in {
  home-manager.users.nixos.home.packages = [
    (pkgs.writeShellScriptBin "sway-toolwait" ''
      ${interpreter}/bin/python ${script} "$@"
    '')
  ];
}
