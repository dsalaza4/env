{ pkgs, primaryUser, ... }:
{
  users.users = {
    ${primaryUser.username}.home = "/Users/${primaryUser.username}";
  };

  home-manager.users.${primaryUser.username} = {
    home = {
      stateVersion = "25.11";

      packages = with pkgs; [
        awscli
        binutils
        cargo-dist
        claude-code
        coreutils
        docker-client
        docker-compose
        gh
        glab
        gnugrep
        google-chrome
        htop
        jq
        just
        nixd
        nixfmt
        nodejs
        opentofu
        python313
        rustup
        shfmt
        sops
        tree
        unzip
        wget
        yq
        zoom-us
      ];
    };
    programs = {
      fuzzy.enable = true;
      editor.enable = true;
      terminal.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      git = {
        enable = true;
        settings = {
          user = {
            inherit (primaryUser) name;
            inherit (primaryUser) email;
          };
        };
      };
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
    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        setDockerHost = true;
      };
    };
  };
}
