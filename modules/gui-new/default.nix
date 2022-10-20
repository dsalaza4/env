{pkgs, ...}: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  programs.dconf.enable = true;
  security.pam.services.swaylock.text = "auth include login";
  programs.light.enable = true;
  users.users.nixos.extraGroups = ["video"];

  fonts = {
    enableDefaultFonts = false;
    fontDir.enable = true;
    fonts = [
      pkgs.noto-fonts-emoji
      pkgs.twitter-color-emoji
      pkgs.fira-code
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Fira Code"];
        sansSerif = ["Fira Code"];
        serif = ["Fira Code"];
        emoji = [
          "Twitter Color Emoji"
          "Noto Color Emoji"
        ];
      };
    };
  };

  home-manager.users.nixos = {
    home = {
      packages = [
        pkgs.gnome.nautilus
        pkgs.grim
        pkgs.mako
        pkgs.sway-contrib.grimshot
        pkgs.swayidle
        pkgs.swaylock
        pkgs.waybar
        pkgs.wl-clipboard
        pkgs.wofi
      ];
      pointerCursor = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors-white";
        size = 20;
        gtk.enable = true;
        x11.enable = true;
      };
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
        menu = "exec wofi --gtk-dark --show run";
        bars = [
          {
            command = "waybar";
            position = "bottom";
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
        gaps = {
          inner = 1;
          outer = 5;
          smartGaps = true;
          smartBorders = "on";
        };
        keybindings = let
          screenshot_dir = "Pictures/Screenshots/$(date +'%Y-%m-%d+%H:%M:%S').png";
        in {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Shift+r" = "reload";

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

          "${modifier}+Shift+f" = "fullscreen toggle";

          "${modifier}+q" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+f" = "layout toggle split";

          "${modifier}+t" = "floating toggle";
          "${modifier}+Shift+t" = "sticky toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+Shift+b" = "bar mode toggle";

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

          "${modifier}+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save screen ${screenshot_dir}";
          "${modifier}+Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

          "${modifier}+F2" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";
          "${modifier}+F2+Shift" = "exec ${pkgs.pamixer}/bin/pamixer -d 10 --allow-boost";
          "${modifier}+F3" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
          "${modifier}+F3+Shift" = "exec ${pkgs.pamixer}/bin/pamixer -i 10 --allow-boost";
          "${modifier}+F1" = "exec ${pkgs.pamixer}/bin/pamixer -t";

          "${modifier}+F5" = "exec ${pkgs.light}/bin/light -U 10";
          "${modifier}+F6" = "exec ${pkgs.light}/bin/light -A 10";
        };
      };
    };
    gtk = {
      enable = true;
      font = {
        name = "monospace";
        size = 12;
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
  };
}
