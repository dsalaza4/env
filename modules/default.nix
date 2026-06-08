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
  sharedModule = {
    home-manager.sharedModules = builtins.attrValues homeManagerModules;
    imports = builtins.attrValues darwinModules;
  };
in
{
  inherit
    homeManagerModules
    darwinModules
    packages
    sharedModule
    ;
}
