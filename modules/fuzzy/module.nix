{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fuzzy;
  fuzzyPkgs = import ./packages.nix {
    inherit pkgs;
    inherit (cfg) theme;
  };
in
{
  options.programs.fuzzy = {
    enable = lib.mkEnableOption "fuzzy — auto-themed bat, delta, fzf with ff and fs";

    theme = {
      dark = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin Mocha";
        description = "syntax theme for dark mode (bat and delta)";
      };
      light = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin Latte";
        description = "syntax theme for light mode (bat and delta)";
      };
    };

  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fd
      fuzzyPkgs.ff
      fuzzyPkgs.fs
    ];

    programs = {
      bat = {
        enable = true;
        package = fuzzyPkgs.bat;
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
        package = fuzzyPkgs.delta;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = fuzzyPkgs.fzfOptions;
        package = fuzzyPkgs.fzf;
      };
    };
  };
}
