{
  config,
  pkgs,
  ...
}: {
  home-manager.users.nixos = {
    programs.alacritty = {
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
            background = "#1d1f21";
            foreground = "#c5c8c6";
          };
        };
      };
    };
    home.packages = [
      pkgs.direnv
    ];
  };

  programs.bash.interactiveShellInit = ''
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)
  '';
}
