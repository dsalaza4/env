let
  homeManagerModules = {
    terminal = import ./module.nix;
  };
in
{
  inherit homeManagerModules;
}
