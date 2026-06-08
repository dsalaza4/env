let
  darwinModules = {
    system = import ./module.nix;
  };
  homeManagerModules = { };
  packages = _: { };
in
{
  inherit darwinModules homeManagerModules packages;
}
