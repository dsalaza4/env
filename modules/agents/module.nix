{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.agents;
in
{
  options.programs.agents = {
    enable = lib.mkEnableOption "agents — Claude Code inside herdr";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";

    # Claude Code rewrites ~/.claude/settings.json itself, so let herdr merge its hook in place.
    home.activation.herdrClaudeIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${lib.getExe config.programs.herdr.package} integration install claude
    '';

    programs = {
      claude-code.enable = true;
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
  };
}
