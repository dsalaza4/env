let
  fuzzy = import ./fuzzy;
in
{
  homeManagerModules = fuzzy.homeManagerModules;
  sharedModules = builtins.attrValues fuzzy.homeManagerModules;
  packages = fuzzy.packages;
}
