{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.terminal;
in
{
  options.programs.terminal = {
    enable = lib.mkEnableOption "terminal — ghostty with Catppuccin themes";

    theme = {
      dark = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin Mocha";
        description = "ghostty theme for dark mode";
      };
      light = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin Latte";
        description = "ghostty theme for light mode";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-family = "FiraCode Nerd Font Mono";
        font-size = 13;
        font-thicken = true;
        adjust-cell-height = 2;

        theme = "dark:${cfg.theme.dark},light:${cfg.theme.light}";

        macos-titlebar-style = "transparent";
        window-padding-x = 10;
        window-padding-y = 8;
        window-save-state = "always";

        cursor-style = "bar";
        cursor-style-blink = true;

        mouse-hide-while-typing = true;
        copy-on-select = "clipboard";

        quick-terminal-position = "top";
        quick-terminal-screen = "mouse";
        quick-terminal-autohide = true;
        quick-terminal-animation-duration = 0.15;

        clipboard-paste-protection = true;
        clipboard-paste-bracketed-safe = true;

        shell-integration = "detect";

        scrollback-limit = 25000000;

        keybind = [
          "cmd+t=new_tab"
          "cmd+shift+left=previous_tab"
          "cmd+shift+right=next_tab"
          "cmd+w=close_surface"

          "cmd+d=new_split:right"
          "cmd+shift+d=new_split:down"
          "cmd+alt+left=goto_split:left"
          "cmd+alt+right=goto_split:right"
          "cmd+alt+up=goto_split:top"
          "cmd+alt+down=goto_split:bottom"
          "cmd+shift+e=equalize_splits"
          "cmd+shift+f=toggle_split_zoom"

          "cmd+plus=increase_font_size:1"
          "cmd+minus=decrease_font_size:1"
          "cmd+zero=reset_font_size"

          "global:ctrl+grave_accent=toggle_quick_terminal"

          "cmd+shift+comma=reload_config"
        ];
      };
    };
  };
}
