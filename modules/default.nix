let
  mods = map import [
    ./fuzzy
    ./editor
  ];
  homeManagerModules = builtins.foldl' (acc: m: acc // m.homeManagerModules) { } mods;
  packages = pkgs: builtins.foldl' (acc: m: acc // (m.packages pkgs)) { } mods;
in
{
  inherit homeManagerModules packages;
  sharedModules = builtins.attrValues homeManagerModules;
}
