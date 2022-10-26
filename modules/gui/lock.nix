{
  pkgs,
  swayModifier,
  ...
}: {
  security.pam.services.swaylock.text = "auth include login";
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

      ring-color = "00000000";
      ring-clear-color = "00000000";
      ring-caps-lock-color = "00000000";
      ring-ver-color = "00000000";
      ring-wrong-color = "00000000";

      text-color = "a4b9ef";
      text-clear-color = "a4b9ef";
      text-caps-lock-color = "a4b9ef";
      text-ver-color = "a4b9ef";
      text-wrong-color = "a4b9ef";

      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";

      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "00000000";

      separator-color = "00000000";
      key-hl-color = "a4b9ef";
      bs-hl-color = "a4b9ef";
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
        {
          timeout = 30 * 60;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
    wayland.windowManager.sway.config.keybindings."${swayModifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
  };
}
