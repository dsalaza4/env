{
  pkgs,
  theme ? {
    dark = "Catppuccin Mocha";
    light = "Catppuccin Latte";
  },
}:
let
  bat = pkgs.symlinkJoin {
    name = "bat";
    paths = [ pkgs.bat ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bat \
        --set-default BAT_THEME "auto:system" \
        --set-default BAT_THEME_DARK "${theme.dark}" \
        --set-default BAT_THEME_LIGHT "${theme.light}"
    '';
    meta = pkgs.bat.meta;
  };
  fzfOptions = [
    "--height 50%"
    "--border"
    "--layout=reverse"
    "--info=inline"
    "--bind=ctrl-/:toggle-preview"
    "--ansi"
    "--select-1"
  ];
  fzf = pkgs.symlinkJoin {
    name = "fzf";
    paths = pkgs.fzf.all;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/fzf \
        --set-default FZF_DEFAULT_OPTS "${pkgs.lib.concatStringsSep " " fzfOptions}"
    '';
    meta = pkgs.fzf.meta // {
      outputsToInstall = [ "out" ];
    };
    passthru.version = pkgs.fzf.version;
  };
  delta = pkgs.symlinkJoin {
    name = "delta";
    paths = [ pkgs.delta ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/delta \
        --run 'if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then export BAT_THEME="${"$"}{BAT_THEME_DARK:-${theme.dark}}"; else export BAT_THEME="${"$"}{BAT_THEME_LIGHT:-${theme.light}}"; fi' \
        --add-flags "--line-numbers"
    '';
    meta = pkgs.delta.meta;
  };
  ff = pkgs.writeShellApplication {
    name = "ff";
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    runtimeInputs = [
      pkgs.fd
      fzf
      pkgs.less
      bat
    ];
    text = ''
      usage() {
        echo "usage: ff [-d dir] [-c] [query]" >&2
      }
      dir=""
      case_flag="-i"
      while getopts ":d:c" opt; do
        case "$opt" in
          d) dir=$OPTARG ;;
          c) case_flag="+i" ;;
          :) echo "option -$OPTARG requires a directory" >&2; usage; exit 1 ;;
          *) echo "unknown option -$OPTARG" >&2; usage; exit 1 ;;
        esac
      done
      shift $((OPTIND - 1))
      if [ -n "$dir" ] && [ ! -d "$dir" ]; then
        echo "not a directory: $dir" >&2
        exit 1
      fi
      fd_args=(--type f --hidden --follow --exclude .git)
      [ -n "$dir" ] && fd_args+=(--search-path "$dir")
      bind_cmd="change:reload:[ -n {q} ] && fd ''${fd_args[*]@Q} 2>/dev/null || true"
      input=""
      if [ -n "$*" ]; then
        input=$(fd "''${fd_args[@]}" | fzf --filter "$*" "$case_flag")
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
            "$case_flag" \
            --query "$*" \
            --bind "$bind_cmd" \
            --preview 'bat --style=numbers,changes --color=always {}' \
            --preview-window 'right:50%'
      ) || fzf_exit=$?
      [ "$fzf_exit" -ne 0 ] && exit 0
      bat --style=numbers,changes --color=always "$file"
    '';
  };
  fs = pkgs.writeShellApplication {
    name = "fs";
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    runtimeInputs = [
      pkgs.ripgrep
      fzf
      pkgs.less
      pkgs.ncurses
      bat
    ];
    text = ''
      usage() {
        echo "usage: fs [-d dir] [-c] [query]" >&2
      }
      dir=""
      case_flag="-i"
      while getopts ":d:c" opt; do
        case "$opt" in
          d) dir=$OPTARG ;;
          c) case_flag="-s" ;;
          :) echo "option -$OPTARG requires a directory" >&2; usage; exit 1 ;;
          *) echo "unknown option -$OPTARG" >&2; usage; exit 1 ;;
        esac
      done
      shift $((OPTIND - 1))
      if [ -n "$dir" ] && [ ! -d "$dir" ]; then
        echo "not a directory: $dir" >&2
        exit 1
      fi
      rg_args=(--line-number --no-heading --color=always "$case_flag")
      path_args=()
      [ -n "$dir" ] && path_args=("$dir")
      bind_cmd="change:reload:[ -n {q} ] && rg ''${rg_args[*]@Q} -- {q} ''${path_args[*]@Q} 2>/dev/null | cut -d: -f1,2 || true"
      input=""
      if [ -n "$*" ]; then
        input=$(rg "''${rg_args[@]}" -- "$*" "''${path_args[@]}" 2>/dev/null | cut -d: -f1,2)
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
            --delimiter=":" \
            --bind "$bind_cmd" \
            --preview 'bat --style=numbers,changes --color=always --highlight-line {2} {1}' \
            --preview-window 'right:50%,+{2}+3/3'
      ) || fzf_exit=$?
      [ "$fzf_exit" -ne 0 ] && exit 0
      IFS=: read -r file line <<< "$result"
      if [ "$(wc -l < "$file")" -le "$(tput lines)" ]; then
        bat --style=numbers,changes --color=always --paging=never --highlight-line "$line" "$file"
      else
        bat --style=numbers,changes --color=always --paging=always --highlight-line "$line" --pager "less +$line" "$file"
      fi
    '';
  };
  fuzzy = pkgs.symlinkJoin {
    name = "fuzzy";
    paths = [
      bat
      delta
      fzf
      ff
      fs
    ];
  };
in
{
  inherit
    bat
    delta
    fzf
    ff
    fs
    fuzzy
    fzfOptions
    ;
}
