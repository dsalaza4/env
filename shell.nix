{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = [
    pkgs.git
    pkgs.just
    pkgs.nixFlakes
  ];

  shellHook = ''
    echo "You can apply this flake to your system with 'just b'"
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
