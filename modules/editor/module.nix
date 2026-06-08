{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.editor;
  defaults = import ./packages.nix { inherit pkgs; };
  editorPkgs = import ./packages.nix {
    inherit pkgs;
    inherit (cfg) theme;
  };
in
{
  options.programs.editor = {
    enable = lib.mkEnableOption "editor — auto-themed micro with Catppuccin themes";

    theme = {
      dark = lib.mkOption {
        type = lib.types.package;
        default = defaults.theme.dark;
        description = "micro theme file for dark mode (.micro file)";
      };
      light = lib.mkOption {
        type = lib.types.package;
        default = defaults.theme.light;
        description = "micro theme file for light mode (.micro file)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ editorPkgs.micro ];
  };
}
