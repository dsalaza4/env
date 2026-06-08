let
  homeManagerModules = {
    editor = import ./module.nix;
  };
  packages =
    pkgs:
    let
      all = import ./packages.nix { inherit pkgs; };
    in
    {
      inherit (all) micro editor;
    };
in
{
  inherit homeManagerModules packages;
}
