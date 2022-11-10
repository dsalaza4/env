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
          "network"
          "pulseaudio"
          "battery"
          "backlight"
          "clock"
          "sway/language"
        ];

        backlight = {
          format = "<span size='13000' foreground='#F5AD64'>{icon}</span> {percent}%";
          format-icons = [" " " "];
          on-scroll-up = "light -A 1";
          on-scroll-down = "light -U 1";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
          format-warning = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
          format-critical = "<span size='13000' foreground='#E38C8F'>{icon}</span> {capacity}%";
          format-charging = "<span size='13000' foreground='#B1E3AD'> </span> {capacity}%";
          format-plugged = "<span size='13000' foreground='#B1E3AD'> </span> {capacity}%";
          format-alt = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {time}";
          format-full = "<span size='13000' foreground='#B1E3AD'> </span> {capacity}%";
          format-icons = [" " " " " " " " " "];
          tooltip-format = "{time}";
        };

        clock = {
          format = "<span foreground='#C6AAE8'></span> {:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          today-format = "<span color='#F5AD64'><b><u>{}</u></b></span>";
          week-pos = "left";
          week-format = "<span color='#99ffdd'><b>{}</b></span>";
          interval = 60;
        };

        network = {
          format-wifi = "<span size='13000' foreground='#F2CECF'> </span> {essid}";
          format-disconnected = "<span size='13000' foreground='#F2CECF'></span> Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}%";
          on-click = "alacritty -e nmtui";
          on-click-middle = "pkill nmtui";
        };

        pulseaudio = {
          format = "<span size='13000' foreground='#EBDDAA'>{icon}</span> {volume}%";
          format-muted = "<span size='13000' foreground='#EBDDAA'></span> Muted";
          format-icons = {
            headphone = " ";
            hands-free = "";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
          on-click-middle = "pkill pavucontrol";
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          persistent_workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
          };
          format-icons = {
            default = "";
            urgent = "";
            focused = "";
          };
        };

        "sway/language" = {
          format = "<span size='13000' foreground='#64a3f5'></span> {shortDescription}";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 16;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        tray = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        border-radius: 0;
        font-size: 12pt;
        min-height: 0;
      }

      window#waybar {
        background: #1d2024;
        color: #DADAE8;
      }

      tooltip {
        background: #1d2024;
        border-radius: 15px;
        border-width: 2px;
        border-style: solid;
        border-color: #a4b9ef;
      }

      #workspaces {
        background: #181b1f;
        margin-left: 5px;
        margin-top: 5px;
        margin-bottom: 5px;
        border-radius: 15px;
      }

      #workspaces button {
        padding-left: 10px;
        padding-right: 10px;
        min-width: 0;
        color: #DADAE8;
      }

      #workspaces button.focused {
        color: #a4b9ef;
      }

      #workspaces button.urgent {
        color: #F9C096;
      }

      #workspaces button:hover {
        background: #181b1f;
        border-color: #a4b9ef;
        color: #a4b9ef;
      }

      #backlight, #battery, #clock, #language, #network, #pulseaudio, #taskbar, #tray, #workspaces {
        padding: 2px 10px;
        background: #181b1f;
        margin-top: 5px;
        margin-bottom: 5px;
      }

      #taskbar {
        padding-left: 15px;
        padding-right: 15px;
        margin-left: 5px;
        margin-right: 5px;
        border-radius: 15px;
      }

      #taskbar button:hover {
        background: #181b1f;
        border-color: #a4b9ef;
        color: #a4b9ef;
      }

      #tray {
        padding-left: 15px;
        padding-right: 2px;
        border-radius: 15px 0px 0px 15px;
      }

      #language {
        padding-right: 15px;
        margin-right: 5px;
        border-radius: 0px 15px 15px 0px;
      }
    '';
  };
}
