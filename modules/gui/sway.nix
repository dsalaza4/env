{pkgs, ...}: {
  home-manager.users.nixos.wayland.windowManager.sway = {
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
      menu = "exec rofi -show drun";
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
        style = "Fira Code";
        size = 12.0;
      };
      focus.followMouse = "always";

      startup = [
        {
          always = true;
          command = ''
            swayidle -w timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
          '';
        }
      ];

      keybindings = let
        screenshot_dir = "Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";
      in {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+r" = "reload; exec_always pkill kanshi; exec kanshi";

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

        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer} -d 10 --allow-boost";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer} -i 10 --allow-boost";
        "XF86AudioMute" = "exec ${pkgs.pamixer} -t";

        "XF86MonBrightnessDown" = "exec ${pkgs.light} -U 10";
        "XF86MonBrightnessUp" = "exec ${pkgs.light} -A 10";

        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
      };
    };
  };
}