{
  config,
  lib,
  ...
}:
{
  options.programs.terminal.enable = lib.mkEnableOption "terminal — zsh with Starship";

  config = lib.mkIf config.programs.terminal.enable {
    programs = {
      starship = {
        enable = true;
        settings = {
          add_newline = true;
          direnv.disabled = false;
          git_metrics.disabled = false;
          nix_shell.disabled = true;
          nodejs.disabled = true;
        };
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        sessionVariables = {
          # awscli2 pipes every command through less unless this is empty
          AWS_PAGER = "";
          EDITOR = "hx";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };
        initContent = ''
          if test -f "$HOME/.zshrc.profile"; then
            source "$HOME/.zshrc.profile"
          fi
        '';
      };
    };
  };
}
