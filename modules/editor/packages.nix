{
  pkgs,
  theme ? {
    dark = "catppuccin_mocha";
    light = "catppuccin_latte";
  },
}:
let
  helix = pkgs.writeShellApplication {
    name = "hx";
    text = ''
      _cache="''${XDG_CACHE_HOME:-$HOME/.cache}/helix-auto-theme"
      _user_cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/helix/config.toml"
      mkdir -p "$_cache"
      if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
        _theme="${theme.dark}"
      else
        _theme="${theme.light}"
      fi
      {
        printf 'theme = "%s"\n' "$_theme"
        if [ -f "$_user_cfg" ]; then
          grep -v '^theme' "$_user_cfg"
        fi
      } > "$_cache/config.toml"
      exec ${pkgs.helix}/bin/hx --config "$_cache/config.toml" "$@"
    '';
  };
  editor = helix;
in
{
  inherit helix editor theme;
}
