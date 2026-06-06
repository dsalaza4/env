{ pkgs, primaryUser, ... }:
let
  withAutoTheme =
    pkg: name:
    pkgs.symlinkJoin {
      inherit name;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${name} \
          --run 'if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then export BAT_THEME="Monokai Extended"; else export BAT_THEME="Monokai Extended Light"; fi'
      '';
      meta = pkg.meta;
    };
in
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
        docker-client
        docker-compose
        cargo-dist
        claude-code
        coreutils
        fd
        htop
        jq
        just
        gnugrep
        gh
        glab
        google-chrome
        nixd
        nixfmt
        nodejs
        opentofu
        python313
        ripgrep
        rustup
        shfmt
        sops
        tree
        unzip
        yq
        wget
        zoom-us
        (pkgs.writeShellScriptBin "zed" ''
          exec "/Users/${primaryUser.username}/Applications/Home Manager Apps/Zed.app/Contents/MacOS/cli" "$@"
        '')
      ];
    };
    programs = {
      bat = {
        enable = true;
        package = withAutoTheme pkgs.bat "bat";
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
        package = withAutoTheme pkgs.delta "delta";
        options = {
          line-numbers = true;
          word-diff-regex = "\\w+";
        };
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = [
          "--height 50%"
          "--border"
          "--layout=reverse"
          "--info=inline"
          "--bind=ctrl-/:toggle-preview"
        ];
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
          theme = "dark:GitHub Dark Dimmed,light:GitHub";

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
          ui_font_size = 15;
          buffer_font_family = "FiraCode Nerd Font Mono";
          buffer_font_size = 13;

          # Theme
          icon_theme = "Material Icon Theme";
          theme = {
            mode = "system";
            light = "GitHub Light Default";
            dark = "GitHub Dark Dimmed";
          };

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
              language_servers = [
                "nixd"
                "!nil"
              ];
            };
          };
        };
      };
      git = {
        enable = true;
        settings = {
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
        sessionVariables = {
          EDITOR = "zed --wait";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
        };
        initContent = pkgs.lib.mkOrder 1500 ''
          if test -f "$HOME/.zshrc.profile"; then
            source "$HOME/.zshrc.profile"
          fi

          fr() {
            [ $# -eq 0 ] && echo "usage: fr <pattern>" && return 1
            local result file line
            result=$(rg --line-number --no-heading --color=always --ignore-case "$*" \
              | fzf --ansi --select-1 \
                    --delimiter=: \
                    --preview 'bat --color=always --style=numbers,changes --highlight-line {2} {1}' \
                    --preview-window 'right:60%,+{2}+3/3')
            [ -n "$result" ] || return
            file=$(echo "$result" | cut -d: -f1)
            line=$(echo "$result" | cut -d: -f2)
            bat --paging=always --highlight-line "$line" --pager "less +''${line}" "$file"
          }

          ff() {
            local file
            file=$(fd --type f --hidden --follow --exclude .git \
              | fzf --query "$*" --select-1 -i \
                    --preview 'bat --color=always --style=numbers,changes {}' \
                    --preview-window 'right:60%')
            [ -n "$file" ] && bat "$file"
          }
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
    home.activation.setDefaultApps = {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        ${pkgs.duti}/bin/duti -s dev.zed.Zed public.plain-text all
        ${pkgs.duti}/bin/duti -s dev.zed.Zed public.source-code all
      '';
    };
  };
}
