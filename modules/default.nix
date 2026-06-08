let
  mods = map import [
    ./fuzzy
    ./editor
    ./terminal
    ./system
  ];
  homeManagerModules = builtins.foldl' (acc: m: acc // (m.homeManagerModules or { })) { } mods;
  darwinModules = builtins.foldl' (acc: m: acc // (m.darwinModules or { })) { } mods;
  packages = pkgs: builtins.foldl' (acc: m: acc // (m.packages pkgs)) { } mods;
in
{
  inherit homeManagerModules darwinModules packages;
  sharedModules = builtins.attrValues homeManagerModules;
  darwinSharedModules = builtins.attrValues darwinModules;
}
