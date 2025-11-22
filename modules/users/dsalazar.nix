{ pkgs, ... }:
{
  users.users = {
    dsalazar.home = "/Users/dsalazar";
  };

  home-manager.users.dsalazar = {
    home = {
      stateVersion = "25.11";
      packages = with pkgs; [
        antigravity
        awscli
        binutils
        coreutils
        direnv
        htop
        jq
        just
        gnugrep
        google-chrome
        nerd-fonts.fira-code
        nixfmt
        nodejs
        python313
        sops
        terraform
        unzip
        yq
        wget
      ];
    };
    programs =
      let
        # as .zshrc is pure, antrigravity can't impurely install its binary
        agy = ''"$HOME/Applications/Home Manager Apps/Google Antigravity.app/Contents/MacOS/Electron"'';
      in
      {
        git = {
          enable = true;
          settings = {
            core.editor = "${agy} --wait";
            user = {
              name = "Daniel Salazar";
              email = "podany270895@gmail.com";
            };
          };
        };
        starship = {
          enable = true;
          settings = {
            add_newline = false;
          };
        };
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases.agy = agy;
        };
      };
  };
}
