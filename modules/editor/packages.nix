{
  pkgs,
  theme ? {
    dark = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/micro/015a2bb208f61a2d5a33121de2644bf4a059436b/themes/catppuccin-mocha-transparent.micro";
      hash = "sha256-v1rCrl13pQGVaZHxkH2qdG8tDUyXjSH8oieR6eTNEG8=";
    };
    light = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/micro/015a2bb208f61a2d5a33121de2644bf4a059436b/themes/catppuccin-latte-transparent.micro";
      hash = "sha256-GDr54mUa3bdcvlUKohWHEUr1adA2LHIO3o/6y0L6fC4=";
    };
  },
}:
let
  darkName = pkgs.lib.removeSuffix ".micro" theme.dark.name;
  lightName = pkgs.lib.removeSuffix ".micro" theme.light.name;
  micro = pkgs.writeShellApplication {
    name = "micro";
    text = ''
      _cs="''${XDG_CONFIG_HOME:-$HOME/.config}/micro/colorschemes"
      mkdir -p "$_cs"
      ln -sf ${theme.dark} "$_cs/${theme.dark.name}"
      ln -sf ${theme.light} "$_cs/${theme.light.name}"
      if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
        _theme="${darkName}"
      else
        _theme="${lightName}"
      fi
      exec ${pkgs.micro}/bin/micro -colorscheme "$_theme" "$@"
    '';
  };
  editor = micro;
in
{
  inherit
    micro
    editor
    theme
    ;
}
