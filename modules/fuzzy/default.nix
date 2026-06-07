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
      inherit (all) fuzzy;
    };
in
{
  inherit homeManagerModules packages;
}
