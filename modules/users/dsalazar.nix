{ pkgs, ... }:
{
  users.users = {
    dsalazar.home = "/Users/dsalazar";
  };

  home-manager.users.dsalazar =
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
          pkgs.direnv
          pkgs.htop
          pkgs.jq
          pkgs.just
          pkgs.gnugrep
          pkgs.google-chrome
          pkgs.nerd-fonts.fira-code
          pkgs.nixfmt
          pkgs.nodejs
          pkgs.python313
          pkgs.sops
          pkgs.terraform
          pkgs.unzip
          pkgs.yq
          pkgs.wget
        ];
      };
      programs = {
        git = {
          enable = true;
          settings = {
            core.editor = "code --wait";
            user = {
              name = "Daniel Salazar";
              email = "podany270895@gmail.com";
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
