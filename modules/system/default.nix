let
  darwinModules = {
    system = import ./module.nix;
  };
in
{
  inherit darwinModules;
}
