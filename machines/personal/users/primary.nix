{ pkgs, primaryUser, ... }:
{
  users.users = {
    ${primaryUser.username}.home = "/Users/${primaryUser.username}";
  };

  home-manager.users.${primaryUser.username} =
    let
      # as .zshrc is pure, antigravity can't impurely install its binary
      code = pkgs.writeScriptBin "code" ''
        "$HOME/Applications/Home Manager Apps/Google Antigravity.app/Contents/MacOS/Electron" $@
      '';
    in
    {
      home = {
        stateVersion = "25.11";
        packages = [
          code
          pkgs.antigravity
          pkgs.awscli
          pkgs.binutils
          pkgs.coreutils
          pkgs.htop
          pkgs.jq
          pkgs.just
          pkgs.gnugrep
          pkgs.google-chrome
          pkgs.nixfmt
          pkgs.nodejs
          pkgs.python313
          pkgs.shfmt
          pkgs.sops
          pkgs.terraform
          pkgs.unzip
          pkgs.yq
          pkgs.wget
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
        };
      };
    };
}
