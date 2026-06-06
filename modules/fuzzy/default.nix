{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fuzzy;
  withAutoTheme =
    pkg: name: dark: light:
    pkgs.symlinkJoin {
      inherit name;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --run 'if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then export BAT_THEME="${dark}"; else export BAT_THEME="${light}"; fi'
      '';
      meta = pkg.meta;
    };
  batPkg = withAutoTheme pkgs.bat "bat" cfg.theme.bat.dark cfg.theme.bat.light;
  deltaPkg = withAutoTheme pkgs.delta "delta" cfg.theme.delta.dark cfg.theme.delta.light;
  ffPkg = pkgs.writeShellApplication {
    name = "ff";
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    runtimeInputs = [
      pkgs.fd
      pkgs.fzf
      batPkg
    ];
    text = ''
      files=$(fd --type f --hidden --follow --exclude .git)
      if [ -z "$files" ]; then
        echo "no files found"
        exit 0
      fi
      if [ -n "$*" ]; then
        filtered=$(echo "$files" | fzf --filter "$*" -i)
        if [ -z "$filtered" ]; then
          echo "no files found for \"$*\""
          exit 0
        fi
      fi
      fzf_exit=0
      file=$(echo "$files" | fzf --query "$*" --preview 'bat {}') || fzf_exit=$?
      [ "$fzf_exit" -eq 130 ] && exit 0
      [ -n "$file" ] && bat "$file"
    '';
  };
  fsPkg = pkgs.writeShellApplication {
    name = "fs";
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    runtimeInputs = [
      pkgs.ripgrep
      pkgs.fzf
      batPkg
    ];
    text = ''
      [ $# -eq 0 ] && echo "usage: fs <pattern>" && exit 1
      rg_out=$(rg --line-number --no-heading --color=always --field-match-separator $'\t' "$*")
      if [ -z "$rg_out" ]; then
        echo "no results for \"$*\""
        exit 0
      fi
      fzf_exit=0
      result=$(echo "$rg_out" | fzf --delimiter=$'\t' \
            --preview 'bat --highlight-line {2} {1}' \
            --preview-window 'right:60%,+{2}+3/3') || fzf_exit=$?
      [ "$fzf_exit" -eq 130 ] && exit 0
      [ -z "$result" ] && exit 0
      file=$(echo "$result" | cut -f1)
      line=$(echo "$result" | cut -f2)
      bat --paging=always --highlight-line "$line" --pager "less +$line" "$file"
    '';
  };
in
{
  options.programs.fuzzy = {
    enable = lib.mkEnableOption "fuzzy — auto-themed bat, delta, fzf with ff and fs";

    theme = {
      bat = {
        dark = lib.mkOption {
          type = lib.types.str;
          default = "Monokai Extended";
          description = "bat theme name for dark mode";
        };
        light = lib.mkOption {
          type = lib.types.str;
          default = "Monokai Extended Light";
          description = "bat theme name for light mode";
        };
      };
      delta = {
        dark = lib.mkOption {
          type = lib.types.str;
          default = "Monokai Extended";
          description = "delta theme name for dark mode";
        };
        light = lib.mkOption {
          type = lib.types.str;
          default = "Monokai Extended Light";
          description = "delta theme name for light mode";
        };
      };
    };

    ff.enable = lib.mkEnableOption "ff — fuzzy file finder" // {
      default = true;
    };
    fs.enable = lib.mkEnableOption "fs — fuzzy string search" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fd ] ++ lib.optional cfg.ff.enable ffPkg ++ lib.optional cfg.fs.enable fsPkg;

    programs.bat = {
      enable = true;
      package = batPkg;
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      package = deltaPkg;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };
  };
}
