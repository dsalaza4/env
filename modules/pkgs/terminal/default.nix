{
  config,
  pkgs,
  ...
}: {
  home-manager.users.nixos.programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      font = {
        normal = {
          family = "monospace";
          style = "regular";
        };
        bold = {
          family = "monospace";
          style = "regular";
        };
        italic = {
          family = "monospace";
          style = "regular";
        };
        bold_italic = {
          family = "monospace";
          style = "regular";
        };
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#24292e";
          foreground = "#d1d5da";
        };
        normal = {
          black = "#24292e";
          red = "#f14c4c";
          green = "#23d18b";
          yellow = "#e2e210";
          blue = "#3b8eea";
          magenta = "#bc3fbc";
          cyan = "#29b7da";
          white = "#d1d5da";
        };
        bright = {
          black = "#666666";
          red = "#f14c4c";
          green = "#23d18b";
          yellow = "#f5f543";
          blue = "#3b8eea";
          magenta = "#d670d6";
          cyan = "#29b7da";
          white = "#d1d5da";
        };
        indexed_colors = [
          {
            index = 16;
            color = "#d18616";
          }
          {
            index = 17;
            color = "#f14c4c";
          }
        ];
        theme = "github_dark";
      };
    };
  };
}
