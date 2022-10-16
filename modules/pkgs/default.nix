{pkgs, ...}: {
  imports = [
    ./editor
    ./git
    ./terminal
    ./timedoctor
  ];

  home-manager.users.nixos.home.packages = [
    pkgs.awscli
    pkgs.binutils
    pkgs.comma
    pkgs.coreutils
    pkgs.htop
    pkgs.jq
    pkgs.kubectl
    pkgs.gnugrep
    pkgs.google-chrome
    pkgs.parted
    pkgs.python310
    pkgs.shadow
    pkgs.sops
    pkgs.terraform
    pkgs.vim
    pkgs.yq
  ];
}
