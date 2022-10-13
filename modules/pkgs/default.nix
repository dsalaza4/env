{pkgs, ...}:
{
  imports = [
    ./terminal
    ./timedoctor
  ];

  users.users.dsalazar.packages = with pkgs; [
    comma
    coreutils
    git
    jq
    kubectl
    gnugrep
    google-chrome
    parted
    shadow
    sops
    terraform
    vim
    vscode
    yq
  ];
}
