{
  alejandra,
  config,
  makes,
  makesSrc,
  pkgs,
  pythonOnNix,
  ...
}: let
  extensionsDir = "/home/dsalazar/.vscode/extensions";
  userDataDir = "/home/dsalazar/.vscode/data";
  bin = "${pkgs.vscode}/bin/code";
  extensions = pkgs.symlinkJoin {
    name = "extensions";
    paths = with pkgs; [
      vscode-extensions._4ops.terraform
      vscode-extensions.bbenoist.nix
      vscode-extensions.coolbear.systemd-unit-file
      vscode-extensions.eamodio.gitlens
      vscode-extensions.grapecity.gc-excelviewer
      vscode-extensions.hashicorp.terraform
      vscode-extensions.jkillian.custom-local-formatters
      vscode-extensions.kamadorueda.alejandra
      vscode-extensions.mads-hartmann.bash-ide-vscode
      vscode-extensions.ms-python.python
      vscode-extensions.ms-python.vscode-pylance # unfree
      vscode-extensions.ms-toolsai.jupyter
      vscode-extensions.ms-toolsai.jupyter-renderers
      vscode-extensions.njpwerner.autodocstring
      vscode-extensions.shardulm94.trailing-spaces
      vscode-extensions.streetsidesoftware.code-spell-checker
      vscode-extensions.tamasfe.even-better-toml
    ];
  };
  settings = {
    "[python]"."editor.tabSize" = 4;
    "alejandra.program" = "${alejandra}/bin/alejandra";
    "customLocalFormatters.formatters" = [
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser css";
        languages = ["css"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser html";
        languages = ["html"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser babel";
        languages = ["javascript"];
      }
      {
        command = "${pkgs.jq}/bin/jq -S";
        languages = ["json" "jsonc"];
      }
      {
        command = "${pkgs.texlive.combined.scheme-medium}/bin/latexindent";
        languages = ["latex"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser markdown";
        languages = ["markdown"];
      }
      {
        command =
          (pkgs.writeScript "python-fmt" ''
            #! ${pkgs.bash}/bin/bash
            ${pythonOnNix.black-latest-python39-bin}/bin/black \
              --config \
              ${makesSrc}/src/evaluator/modules/format-python/settings-black.toml \
              - \
              | \
            ${pythonOnNix.isort-latest-python39-bin}/bin/isort \
              --settings-path \
              ${makesSrc}/src/evaluator/modules/format-python/settings-isort.toml \
              -
          '')
          .outPath;
        languages = ["python"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser scss";
        languages = ["scss"];
      }
      {
        command = "${pkgs.shfmt}/bin/shfmt -bn -ci -i 2 -s -sr -";
        languages = ["shellscript"];
      }
      {
        command = "${pkgs.terraform}/bin/terraform fmt -";
        languages = ["terraform"];
      }
      {
        command =
          (pkgs.writeScript "toml-fmt" ''
            #! ${pkgs.bash}/bin/bash
            NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH \
            ${pkgs.nodePackages.prettier}/bin/prettier \
              --parser toml \
              --plugin prettier-plugin-toml
          '')
          .outPath;
        languages = ["toml"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser html";
        languages = ["xml"];
      }
      {
        command = "${pkgs.nodePackages.prettier}/bin/prettier --parser yaml";
        languages = ["yaml"];
      }
    ];
    "diffEditor.ignoreTrimWhitespace" = false;
    "diffEditor.maxComputationTime" = 0;
    "diffEditor.renderSideBySide" = false;
    "diffEditor.wordWrap" = "on";
    "editor.cursorStyle" = "underline";
    "editor.defaultFormatter" = "jkillian.custom-local-formatters";
    "editor.bracketPairColorization.enabled" = true;
    "editor.formatOnPaste" = false;
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.fontFamily" = "monospace";
    "editor.fontLigatures" = true;
    "editor.fontSize" = "12";
    "editor.guides.bracketPairs" = "active";
    "editor.minimap.enabled" = false;
    "editor.minimap.maxColumn" = 80;
    "editor.minimap.renderCharacters" = true;
    "editor.minimap.showSlider" = "always";
    "editor.minimap.side" = "left";
    "editor.minimap.size" = "fill";
    "editor.rulers" = [80];
    "editor.tabSize" = 2;
    "editor.wordWrap" = "off";
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "extensions.autoUpdate" = false;
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.trimTrailingWhitespace" = true;
    "gitlens.showWelcomeOnInstall" = false;
    "gitlens.showWhatsNewAfterUpgrades" = false;
    "python.analysis.autoSearchPaths" = false;
    "python.analysis.diagnosticMode" = "openFilesOnly";
    "python.formatting.provider" = "none";
    "python.languageServer" = "Pylance";
    "python.linting.enabled" = true;
    "python.linting.lintOnSave" = true;
    "python.linting.mypyArgs" = [
      "--config-file"
      "${makesSrc}/src/evaluator/modules/lint-python/settings-mypy.cfg"
    ];
    "python.linting.mypyEnabled" = true;
    "python.linting.mypyPath" = "${pythonOnNix.mypy-latest-python39-bin}/bin/mypy";
    "python.linting.prospectorArgs" = [
      "--profile"
      "${makesSrc}/src/evaluator/modules/lint-python/settings-prospector.yaml"
    ];
    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
    "python.linting.prospectorEnabled" = true;
    "python.linting.prospectorPath" = "${pythonOnNix.prospector-latest-python39-bin}/bin/prospector";
    "python.linting.pylintEnabled" = false;
    "security.workspace.trust.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "window.zoomLevel" = 3;
    "workbench.activityBar.visible" = false;
    "workbench.colorTheme" = "Default High Contrast";
    "workbench.editor.enablePreview" = false;
    "workbench.editor.focusRecentEditorAfterClose" = false;
    "workbench.editor.openPositioning" = "last";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
  };
in {
  environment.variables.EDITOR = bin;
  users.users.dsalazar.packages = [pkgs.vscode];
  programs.git.config = {
    core.editor = "${bin} --wait";
    diff.tool = "editor";
    difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
    merge.tool = "editor";
    mergetool.editor.cmd = "${bin} --wait $MERGED";
  };
  systemd.services."editor-setup" = {
    description = "Editor setup";
    script = ''
      ${pkgs.substitute {
        src = pkgs.writeScript "editor-setup.sh" ''
          set -eux
          export PATH=${pkgs.lib.makeSearchPath "bin" [pkgs.coreutils]}
          rm -rf "@userDataDir@"
          rm -rf "@extensionsDir@"
          mkdir -p "@userDataDir@"
          mkdir -p "@extensionsDir@"
          cp --dereference --no-preserve=mode,ownership \
            "@settings@" "@userDataDir@/settings.json"
          cp --dereference --no-preserve=mode,ownership -rT \
            "@extensions@/share/vscode/extensions/" "@extensionsDir@"
        '';
        replacements = [
          ["--replace" "@extensions@" extensions]
          ["--replace" "@extensionsDir@" extensionsDir]
          ["--replace" "@settings@" (makes.toFileJson "settings.json" settings)]
          ["--replace" "@userDataDir@" userDataDir]
        ];
        isExecutable = true;
      }}
    '';
    serviceConfig = {
      Group = config.users.users.dsalazar.group;
      Type = "oneshot";
      User = "dsalazar";
    };
  };
}