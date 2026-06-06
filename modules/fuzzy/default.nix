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
    home.packages = with pkgs; [
      fd
      ripgrep
    ];

    programs.bat = {
      enable = true;
      package = withAutoTheme pkgs.bat "bat" cfg.theme.bat.dark cfg.theme.bat.light;
    };

    programs.delta = {
      enable = true;
      package = withAutoTheme pkgs.delta "delta" cfg.theme.delta.dark cfg.theme.delta.light;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };

    programs.zsh.initContent = lib.mkOrder 1500 (
      lib.optionalString cfg.fs.enable ''
        fs() {
          [ $# -eq 0 ] && echo "usage: fs <pattern>" && return 1
          local result file line
          result=$(rg --line-number --no-heading --color=always "$*" \
            | fzf --delimiter=: \
                  --preview 'bat --highlight-line {2} {1}' \
                  --preview-window 'right:60%,+{2}+3/3')
          [ -n "$result" ] || return
          file=$(echo "$result" | cut -d: -f1)
          line=$(echo "$result" | cut -d: -f2)
          bat --paging=always --highlight-line "$line" --pager "less +''${line}" "$file"
        }
      ''
      + lib.optionalString cfg.ff.enable ''
        ff() {
          local file
          file=$(fd --type f --hidden --follow --exclude .git \
            | fzf --query "$*" \
                  --preview 'bat {}')
          [ -n "$file" ] && bat "$file"
        }
      ''
    );
  };
}
