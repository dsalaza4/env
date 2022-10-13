{pkgs, ...}:
{
  imports = [
    ./terminal
    ./timedoctor
  ];

  users.users.dsalazar.packages = with pkgs; [
    awscli
    binutils
    comma
    coreutils
    git
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
    vscode
    yq
  ];
}
