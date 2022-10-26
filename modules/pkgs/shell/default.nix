{
  lib,
  pkgs,
  ...
}: {
  environment.shells = [pkgs.zsh];
  environment.binsh = "${pkgs.dash}/bin/dash";
  users = {
    defaultUserShell = pkgs.zsh;
    users.nixos.shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      export DIRENV_WARN_TIMEOUT=1h
      source <(direnv hook zsh)
    '';
  };

  home-manager.users.nixos.programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "branch"
        "colorize"
        "dirhistory"
        "docker"
        "emoji"
        "git"
        "history"
        "kubectl"
        "sudo"
        "web-search"
      ];
    };
    plugins = [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ./.;
      }
      {
        file = "nix-shell.plugin.zsh";
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
    ];
  };
}
