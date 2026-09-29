{ pkgs, primaryUser, ... }:
{
  users.users = {
    ${primaryUser.username}.home = "/Users/${primaryUser.username}";
  };

  home-manager.users.${primaryUser.username} = {
    imports = [
      (
        { config, lib, ... }:
        {
          # Claude Code rewrites ~/.claude/settings.json itself, so let herdr merge its hook in place.
          home.activation.herdrClaudeIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run ${lib.getExe config.programs.herdr.package} integration install claude
          '';
        }
      )
    ];
    home = {
      stateVersion = "25.11";

      packages = with pkgs; [
        awscli2
        binutils
        cargo-dist
        claude-code
        coreutils
        docker-client
        docker-compose
        gh
        glab
        gnugrep
        htop
        jq
        just
        kubectl
        nixd
        nixfmt
        nodejs
        python313
        rustup
        saml2aws
        shfmt
        sops
        terraform
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
      herdr = {
        enable = true;
        settings = {
          onboarding = false;
          theme = {
            name = "catppuccin";
            auto_switch = true;
            light_name = "catppuccin-latte";
            dark_name = "catppuccin";
          };
          update = {
            version_check = false;
            manifest_check = false;
          };
          ui = {
            agent_panel_sort = "priority";
            toast.delivery = "terminal";
          };
          keys = {
            open_notification_target = [
              "prefix+o"
              "ctrl+shift+o"
            ];
            previous_agent = "ctrl+shift+a";
            next_agent = "ctrl+shift+s";
            switch_workspace = "ctrl+shift+1..9";
            goto = [
              "prefix+g"
              "ctrl+shift+g"
            ];
          };
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
