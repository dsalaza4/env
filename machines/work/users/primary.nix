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
        htop
        jq
        just
        gnugrep
        nixd
        nixfmt
        nodejs
        saml2aws
        terraform
        python313
        rustup
        shfmt
        sops
        tree
        unzip
        vscode
        yq
        wget
        zoom-us
      ];
    };
    programs = {
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
          font-size = 12;
          font-thicken = true;
          adjust-cell-height = 2;

          # Theme
          theme = "GitHub Dark Default";

          # Window and appearance
          background-opacity = 0.9;
          background-blur-radius = 20;
          macos-titlebar-style = "transparent";
          window-padding-x = 10;
          window-padding-y = 8;
          window-save-state = "always";
          window-theme = "dark";

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
      zed-editor = {
        enable = true;
        extensions = [
          "git-firefly"
          "github-theme"
          "html"
          "log"
          "material-icon-theme"
          "nix"
          "terraform"
          "toml"
        ];
        userSettings = {
          # Font
          ui_font_family = "FiraCode Nerd Font Mono";
          ui_font_size = 14;
          buffer_font_family = "FiraCode Nerd Font Mono";
          buffer_font_size = 12;

          # Theme
          icon_theme = "Material Icon Theme";
          theme = "GitHub Dark";

          # Editor
          colorize_brackets = true;
          ensure_final_newline_on_save = true;
          wrap_guides = [ 100 ];
          soft_wrap = "none";
          tab_size = 2;
          cursor_blink = true;

          # Tabs
          preview_tabs = {
            enable_preview_from_file_finder = true;
          };
          tabs = {
            close_position = "left";
            activate_on_close = "left_neighbour";
          };

          # Minimap
          minimap = {
            show = "auto";
            thumb = "always";
            max_width_columns = 80;
          };

          # Keybindings
          base_keymap = "VSCode";

          # Languages
          languages = {
            Nix = {
              language_servers = [ "nixd" "!nil" ];
            };
          };
        };
      };
      git = {
        enable = true;
        settings = {
          core.editor = "zeditor --wait";
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
          nodejs.disabled = true;
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
