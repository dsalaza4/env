{pkgs, ...}: let
  lock = builtins.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--daemonize"
    "--screenshots"
    "--clock"
    "--grace 5"
    "--fade-in 5"
    "--indicator-idle-visible"
    "--indicator-radius 100"
    "--indicator-thickness 7"
    "--effect-blur 7x5"
    "--effect-vignette 0.5:0.5"
    "--line-color 00000000"
    "--line-clear-color 00000000"
    "--line-caps-lock-color 00000000"
    "--line-ver-color 00000000"
    "--line-wrong-color 00000000"
    "--ring-color 79b8ff"
    "--ring-clear-color 79b8ff"
    "--ring-caps-lock-color 79b8ff"
    "--ring-ver-color 79b8ff"
    "--ring-wrong-color 79b8ff"
    "--text-color ffab70"
    "--text-clear-color ffab70"
    "--text-caps-lock-color ffab70"
    "--text-ver-color ffab70"
    "--text-wrong-color ffab70"
    "--inside-color 1b1f23"
    "--inside-clear-color 1b1f23"
    "--inside-caps-lock-color 1b1f23"
    "--inside-ver-color 1b1f23"
    "--inside-wrong-color 1b1f23"
    "--layout-bg-color 00000000"
    "--layout-border-color 00000000"
    "--layout-text-color 00000000"
    "--separator-color 00000000"
    "--key-hl-color ffab70"
    "--bs-hl-color ffab70"
  ];
in {
  programs.sway = {
    enable = true;
    extraPackages = [
      pkgs.grim
      pkgs.mako
      pkgs.pavucontrol
      pkgs.sway-contrib.grimshot
      pkgs.wl-clipboard
    ];
  };
  home-manager.users.nixos = {
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = lock;
        }
        {
          event = "lock";
          command = lock;
        }
      ];
      timeouts = [
        {
          timeout = 5 * 60;
          command = lock;
        }
        {
          timeout = 15 * 60;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }
      ];
    };
    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      systemdIntegration = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "exec rofi -show drun,run,filebrowser";
        bars = [
          {
            command = "waybar";
          }
        ];
        input = {
          "type:keyboard" = {
            xkb_layout = "us,latam";
            xkb_options = "grp:win_space_toggle";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            dwt = "enabled";
            middle_emulation = "enabled";
          };
        };
        output."*" = {
          scale = "1.0";
          bg = let
            img = builtins.fetchurl {
              url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-dracula.png";
              sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
            };
          in "${img} fill";
        };
        seat."*" = {
          xcursor_theme = "capitaine-cursors-white 20";
          hide_cursor = "when-typing enable";
        };
        fonts = {
          names = ["monospace"];
          style = "FiraCode Nerd Font";
          size = 12.0;
        };
        focus.followMouse = "always";

        startup = [
          {
            command = builtins.concatStringsSep ";" [
              "swaymsg 'workspace 1'"
              "sway-toolwait --waitfor Alacritty -- alacritty"
              "sway-toolwait --waitfor code -- code"
              "swaymsg '[instance=code] resize set width 1600px'"
              "swaymsg 'workspace 2'"
              "sway-toolwait --waitfor brave-browser -- brave"
              "swaymsg 'workspace 1'"
            ];
          }
          {
            always = true;
            command = "kanshi";
          }
        ];

        keybindings = let
          screenshot_dir = "Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";
        in {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Shift+r" = "reload";
          "${modifier}+l" = "exec ${lock}";

          "${modifier}+p" = "${menu}";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+Control+Left" = "resize shrink width 20 px";
          "${modifier}+Control+Down" = "resize grow height 20 px";
          "${modifier}+Control+Up" = "resize shrink height 20 px";
          "${modifier}+Control+Right" = "resize grow width 20 px";

          "${modifier}+Shift+Tab" = "workspace prev";
          "${modifier}+Tab" = "workspace next";

          "${modifier}+b" = "split v";
          "${modifier}+v" = "split h";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          "Print" = "exec grimshot --notify save screen ${screenshot_dir}";
          "Shift+Print" = "exec grimshot --notify copy area";

          "XF86AudioLowerVolume" = "exec pamixer -d 5 --allow-boost";
          "XF86AudioRaiseVolume" = "exec pamixer -i 5 --allow-boost";
          "XF86AudioMute" = "exec pamixer -t";

          "XF86MonBrightnessDown" = "exec ${pkgs.light} -U 5";
          "XF86MonBrightnessUp" = "exec ${pkgs.light} -A 5";

          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        };
      };
    };
  };
}
