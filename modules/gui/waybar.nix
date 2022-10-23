{
  home-manager.users.nixos.programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = ["wlr/taskbar"];
        modules-center = ["sway/workspaces"];
        modules-right = [
          "tray"
          "clock"
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "sway/language"
        ];

        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["🔅" "🔆"];
        };

        battery = {
          interval = 60;
          states = {
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["🪫" "🔋"];
        };

        clock = {
          format = "{:%R} 📅";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          today-format = "<span color='#ff6699'><b><u>{}</u></b></span>";
          week-pos = "left";
          week-format = "<span color='#99ffdd'><b>{}</b></span>";
          interval = 60;
        };

        network = {
          format-wifi = "{essid} 🛜";
          format-disconnected = "Disconnected ⚠️";
          on-click = "alacritty -e nmtui";
          on-click-right = "pkill nmtui";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} 🛜";
          format-muted = "🔇";
          format-icons.default = ["🔈" "🔉" "🔊"];
          scroll-step = 1;
          on-click = "pavucontrol";
          on-click-right = "pkill pavucontrol";
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "sway/language" = {
          format = "{short} 🌐";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };
      };
    };
  };
}
