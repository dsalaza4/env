{pkgs, ...}: {
  nix.package = let
    package = pkgs.nixUnstable;
  in
    builtins.trace "Nix: ${package.version}" package;
  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
  '';
  nix.settings.trusted-users = ["root" "dsalazar"];

  nixpkgs.config.allowUnfree = true;
}
