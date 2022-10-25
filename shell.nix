{pkgs ? import <nixpkgs> {}}: let
  nix = pkgs.writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
  '';
in
  pkgs.mkShell {
    name = "nixosBuildShell";
    nativeBuildInputs = [
      pkgs.git
      pkgs.just
      pkgs.nixFlakes
    ];

    shellHook = ''
      echo "You can apply this flake to your system with 'just b'"
      PATH=${nix}/bin:$PATH
    '';
  }
