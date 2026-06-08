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
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
        settings = {
          # Typography
          font-family = "FiraCode Nerd Font Mono";
          font-size = 13;
          font-thicken = true;
          adjust-cell-height = 2;

          # Theme
          theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";

          # Window and appearance
          macos-titlebar-style = "transparent";
          window-padding-x = 10;
          window-padding-y = 8;
          window-save-state = "always";

          # Cursor
          cursor-style = "bar";
          cursor-style-blink = true;

          # Mouse
          mouse-hide-while-typing = true;
          copy-on-select = "clipboard";

          # Quick terminal
          quick-terminal-position = "top";
          quick-terminal-screen = "mouse";
          quick-terminal-autohide = true;
          quick-terminal-animation-duration = 0.15;

          # Security
          clipboard-paste-protection = true;
          clipboard-paste-bracketed-safe = true;

          # Shell integration
          shell-integration = "detect";

          # Performance
          scrollback-limit = 25000000;

          keybind = [
            # Tabs
            "cmd+t=new_tab"
            "cmd+shift+left=previous_tab"
            "cmd+shift+right=next_tab"
            "cmd+w=close_surface"

            # Splits
            "cmd+d=new_split:right"
            "cmd+shift+d=new_split:down"
            "cmd+alt+left=goto_split:left"
            "cmd+alt+right=goto_split:right"
            "cmd+alt+up=goto_split:top"
            "cmd+alt+down=goto_split:bottom"
            "cmd+shift+e=equalize_splits"
            "cmd+shift+f=toggle_split_zoom"

            # Font size
            "cmd+plus=increase_font_size:1"
            "cmd+minus=decrease_font_size:1"
            "cmd+zero=reset_font_size"

            # Quick terminal
            "global:ctrl+grave_accent=toggle_quick_terminal"

            # Config
            "cmd+shift+comma=reload_config"
          ];
        };
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
