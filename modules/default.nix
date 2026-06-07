let
  fuzzy = import ./fuzzy;
in
{
  inherit (fuzzy) homeManagerModules;
  sharedModules = builtins.attrValues fuzzy.homeManagerModules;
  inherit (fuzzy) packages;
}
