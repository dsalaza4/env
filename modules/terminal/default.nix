let
  homeManagerModules = {
    terminal = import ./module.nix;
  };
  packages = _: { };
in
{
  inherit homeManagerModules packages;
}
