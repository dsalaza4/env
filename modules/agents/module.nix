{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.agents;
  font = lib.head (lib.toList config.programs.ghostty.settings.font-family);
in
{
  options.programs.agents = {
    enable = lib.mkEnableOption "agents — Claude Code inside herdr";
    desktop.enable = lib.mkEnableOption "the herdr desktop app";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

        # Claude Code rewrites ~/.claude/settings.json itself, so let herdr merge its hook in place.
        home.activation.herdrClaudeIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${lib.getExe config.programs.herdr.package} integration install claude
        '';

        programs = {
          claude-code = {
            enable = true;
            # nixpkgs pins the cert store to "system", which on macOS only holds admin-trusted certs, not Apple's roots.
            package = pkgs.claude-code.overrideAttrs (old: {
              installPhase =
                builtins.replaceStrings
                  [ "--set-default CLAUDE_CODE_CERT_STORE system" ]
                  [ "--set-default CLAUDE_CODE_CERT_STORE bundled,system" ]
                  old.installPhase;
            });
          };
          herdr = {
            enable = true;
            settings = {
              onboarding = false;
              theme = {
                name = "catppuccin";
                auto_switch = true;
                light_name = "catppuccin-latte";
                dark_name = "catppuccin";
              };
              update = {
                version_check = false;
                manifest_check = false;
              };
              ui = {
                agent_panel_sort = "priority";
                toast.delivery = "herdr";
              };
              keys = {
                open_notification_target = [
                  "prefix+o"
                  "ctrl+shift+o"
                ];
                previous_agent = "ctrl+shift+a";
                next_agent = "ctrl+shift+s";
                switch_workspace = "ctrl+shift+1..9";
                goto = [
                  "prefix+g"
                  "ctrl+shift+g"
                ];
              };
            };
          };
        };
      }

      (lib.mkIf cfg.desktop.enable {
        home.packages = [ pkgs.herdr-desktop ];

        # Read-only, so in-app zoom changes last until restart.
        xdg.configFile."herdr-app/settings.json".source =
          (pkgs.formats.json { }).generate "herdr-app-settings.json"
            {
              telemetry = false;
              inherit font;
              ui_font = font;
              font_size = lib.head (lib.toList config.programs.ghostty.settings.font-size);
              appearance = "system";
              theme = {
                light = "paper";
                dark = "ink";
              };
            };
      })
    ]
  );
}
