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
      pkgs.fzf
      pkgs.less
      bat
    ];
    text = ''
      bind_cmd='change:reload:[ -n {q} ] && fd --type f --hidden --follow --exclude .git 2>/dev/null || true'
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
      pkgs.fzf
      pkgs.less
      bat
    ];
    text = ''
      bind_cmd='change:reload:[ -n {q} ] && rg --line-number --no-heading --color=always -- {q} 2>/dev/null | cut -d: -f1,2 || true'
      input=""
      if [ -n "$*" ]; then
        input=$(rg --line-number --no-heading --color=always -- "$*" 2>/dev/null | cut -d: -f1,2)
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
      bat --style=numbers,changes --color=always --highlight-line "$line" --pager "less +$line" "$file"
    '';
  };
  fuzzy = pkgs.symlinkJoin {
    name = "fuzzy";
    paths = [
      bat
      delta
      ff
      fs
    ];
  };
in
{
  inherit
    bat
    delta
    ff
    fs
    fuzzy
    ;
}
