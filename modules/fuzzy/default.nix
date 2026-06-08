let
  homeManagerModules = {
    fuzzy = import ./module.nix;
  };
  packages =
    pkgs:
    let
      all = import ./packages.nix { inherit pkgs; };
    in
    {
      inherit (all) fuzzy ff fs;
    };
in
{
  inherit homeManagerModules packages;
}
