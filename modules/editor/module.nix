{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.editor;
  editorPkgs = import ./packages.nix {
    inherit pkgs;
    inherit (cfg) theme;
  };
in
{
  options.programs.editor = {
    enable = lib.mkEnableOption "editor — auto-themed helix with built-in themes";

    theme = {
      dark = lib.mkOption {
        type = lib.types.str;
        default = "catppuccin_mocha";
        description = "helix theme name for dark mode";
      };
      light = lib.mkOption {
        type = lib.types.str;
        default = "catppuccin_latte";
        description = "helix theme name for light mode";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ editorPkgs.helix ];
  };
}
