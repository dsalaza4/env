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
