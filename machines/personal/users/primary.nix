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
        claude-monitor
        coreutils
        htop
        jq
        just
        gnugrep
        google-chrome
        nixfmt
        nodejs
        opentofu
        python313
        rustup
        shfmt
        sops
        tree
        unzip
        vscode
        yq
        wget
      ];
    };
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      git = {
        enable = true;
        settings = {
          core.editor = "code --wait";
          user = {
            name = primaryUser.name;
            email = primaryUser.email;
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
        };
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };
        initContent = pkgs.lib.mkOrder 1500 ''
          if test -f "$HOME/.zshrc.profile"; then
            source "$HOME/.zshrc.profile"
          fi
        '';
      };
    };
  };
}
