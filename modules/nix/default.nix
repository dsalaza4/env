{pkgs, ...}: {
  nix = {
    package = let
      package = pkgs.nixUnstable;
    in
      builtins.trace "Nix: ${package.version}" package;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
    '';
    settings.trusted-users = ["root" "dsalazar"];
  };

  nixpkgs.config.allowUnfree = true;
}
