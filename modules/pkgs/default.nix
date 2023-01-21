{
  makesPkg,
  pkgs,
  ...
}: {
  imports = [
    ./editor
    ./git
    ./shell
    ./terminal
    ./timedoctor
  ];

  home-manager.users.nixos = {
    home.packages = [
      makesPkg
      pkgs._1password-gui-beta
      pkgs.awscli
      pkgs.binutils
      pkgs.brave
      pkgs.coreutils
      pkgs.direnv
      pkgs.htop
      pkgs.jq
      pkgs.just
      pkgs.kubectl
      pkgs.gnugrep
      pkgs.nodejs
      pkgs.pamixer
      pkgs.parted
      pkgs.python311
      pkgs.qbittorrent
      pkgs.shadow
      pkgs.sops
      pkgs.terraform
      pkgs.unzip
      pkgs.vlc
      pkgs.yq
      pkgs.wget
    ];

    programs = {
      neovim = {
        enable = true;
        vimAlias = true;
      };
    };
  };
}
