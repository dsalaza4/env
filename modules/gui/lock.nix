{
  pkgs,
  swayModifier,
  ...
}: {
  home-manager.users.nixos = {
    programs.swaylock.settings = {
      daemonize = true;
      screenshots = true;
      clock = true;
      grace = 5;
      fade-in = 2;

      indicator-idle-visible = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";

      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";

      ring-color = "79b8ff";
      ring-clear-color = "79b8ff";
      ring-caps-lock-color = "79b8ff";
      ring-ver-color = "79b8ff";
      ring-wrong-color = "79b8ff";

      text-color = "ffab70";
      text-clear-color = "ffab70";
      text-caps-lock-color = "ffab70";
      text-ver-color = "ffab70";
      text-wrong-color = "ffab70";

      inside-color = "1b1f23";
      inside-clear-color = "1b1f23";
      inside-caps-lock-color = "1b1f23";
      inside-ver-color = "1b1f23";
      inside-wrong-color = "1b1f23";

      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "00000000";

      separator-color = "00000000";
      key-hl-color = "ffab70";
      bs-hl-color = "ffab70";
    };
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }
      ];
      timeouts = [
        {
          timeout = 5 * 60;
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }
        {
          timeout = 15 * 60;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }
      ];
    };
    wayland.windowManager.sway.config.keybindings."${swayModifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
  };
}
