{
  pkgs,
  editor,
  ...
}: {
  home-manager.users.nixos = {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Daniel Salazar";
      userEmail = "podany270895@gmail.com";
      extraConfig = {
        core.editor = "${editor}/bin/code --wait";
        diff.tool = "${editor}/bin/code";
        difftool.editor.cmd = "${editor}/bin/code --diff $LOCAL $REMOTE --wait";
        merge.tool = "${editor}/bin/code";
        mergetool.editor.cmd = "${editor}/bin/code --wait $MERGED";
      };
      aliases = {
        a = "add -p";
        c = "commit --allow-empty";
        ca = "commit --amend --allow-empty";
        d = "diff";
        f = "fetch --all";
        l = "log";
        p = "push -f";
        ro = "pull --autostash --progress --rebase --stat origin";
        rf = "pull --autostash --progress --rebase --stat fork";
        s = "status";
      };
      signing = {
        signByDefault = true;
        key = "0x1DB5E8128304E704";
      };
    };
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
  };
}
