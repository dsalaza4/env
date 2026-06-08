let
  mods = map import [
    ./fuzzy
    ./editor
    ./terminal
    ./system
  ];
  home-manager = builtins.foldl' (acc: m: acc // (m.homeManagerModules or { })) { } mods;
  darwin = builtins.foldl' (acc: m: acc // (m.darwinModules or { })) { } mods;
  packages = pkgs: builtins.foldl' (acc: m: acc // (m.packages pkgs)) { } mods;
  all = {
    home-manager.sharedModules = builtins.attrValues home-manager;
    imports = builtins.attrValues darwin;
  };
in
{
  inherit
    home-manager
    darwin
    packages
    all
    ;
}
