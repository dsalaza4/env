{pkgs, ...}: {
  imports = [
    ./editor
    ./terminal
    ./timedoctor
  ];

  users.users.dsalazar.packages = with pkgs; [
    awscli
    binutils
    comma
    coreutils
    jq
    kubectl
    gnugrep
    google-chrome
    parted
    python310
    shadow
    sops
    terraform
    vim
    yq
  ];
}
