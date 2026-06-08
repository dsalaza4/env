let
  home-manager = {
    fuzzy = import ./fuzzy/module.nix;
    editor = import ./editor/module.nix;
    terminal = import ./terminal/module.nix;
  };
  darwin = {
    system = import ./system/module.nix;
  };
  packages =
    pkgs:
    let
      fuzzy = import ./fuzzy/packages.nix { inherit pkgs; };
      editor = import ./editor/packages.nix { inherit pkgs; };
    in
    {
      inherit (fuzzy) fuzzy ff fs;
      inherit (editor) helix;
    };
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
