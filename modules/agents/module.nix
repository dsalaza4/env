{
  config,
  lib,
  pkgs,
  ...
}:
let
  font = "FiraCode Nerd Font Mono";
in
{
  options.programs.agents.enable = lib.mkEnableOption "agents — Claude Code inside the herdr desktop app";

  config = lib.mkIf config.programs.agents.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

    home.packages = [ pkgs.herdr-desktop ];

    programs.claude-code.enable = true;

    # Read-only, so in-app zoom changes last until restart.
    xdg.configFile."herdr-app/settings.json".source =
      (pkgs.formats.json { }).generate "herdr-app-settings.json"
        {
          telemetry = false;
          inherit font;
          ui_font = font;
          font_size = 13;
          appearance = "system";
          theme = {
            light = "paper";
            dark = "ink";
          };
        };
  };
}
