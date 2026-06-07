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
      input=""
      if [ -n "$*" ]; then
        input=$(fd --type f --hidden --follow --exclude .git | fzf --filter "$*" -i)
        if [ -z "$input" ]; then
          echo "no files found for \"$*\""
          exit 0
        fi
      fi
      unset FZF_DEFAULT_COMMAND
      fzf_exit=0
      file=$(
        printf '%s' "$input" | fzf \
            --ansi \
            --query "$*" \
            --bind 'change:reload:[ -n {q} ] && fd --type f --hidden --follow --exclude .git 2>/dev/null || true' \
            --preview 'bat {}'
      ) || fzf_exit=$?
      [ "$fzf_exit" -ne 0 ] && exit 0
      bat "$file"
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
      sep=$'\t'
      bind_cmd='change:reload:[ -n {q} ] && rg --line-number --no-heading --color=always --field-match-separator "'"$sep"'" -- {q} 2>/dev/null || true'
      input=""
      if [ -n "$*" ]; then
        input=$(rg --line-number --no-heading --color=always --field-match-separator "$sep" -- "$*" 2>/dev/null)
        if [ -z "$input" ]; then
          echo "no results for \"$*\""
          exit 0
        fi
      fi
      unset FZF_DEFAULT_COMMAND
      fzf_exit=0
      result=$(
        printf '%s' "$input" | fzf \
            --disabled \
            --ansi \
            --query "$*" \
            --delimiter="$sep" \
            --bind "$bind_cmd" \
            --preview 'bat --highlight-line {2} {1}' \
            --preview-window 'right:60%,+{2}+3/3'
      ) || fzf_exit=$?
      [ "$fzf_exit" -ne 0 ] && exit 0
      IFS=$'\t' read -r file line _ <<< "$result"
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
          default = "Catppuccin Mocha";
          description = "bat theme name for dark mode";
        };
        light = lib.mkOption {
          type = lib.types.str;
          default = "Catppuccin Latte";
          description = "bat theme name for light mode";
        };
      };
      delta = {
        dark = lib.mkOption {
          type = lib.types.str;
          default = "Catppuccin Mocha";
          description = "delta theme name for dark mode";
        };
        light = lib.mkOption {
          type = lib.types.str;
          default = "Catppuccin Latte";
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
