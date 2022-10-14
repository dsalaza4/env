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
  userDataDir = "/home/dsalazar/.config/Code/User";
  bin = "${pkgs.vscode}/bin/code";
  extensions = pkgs.symlinkJoin {
    name = "extensions";
    paths = [
      pkgs.vscode-extensions._4ops.terraform
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.coolbear.systemd-unit-file
      pkgs.vscode-extensions.eamodio.gitlens
      pkgs.vscode-extensions.grapecity.gc-excelviewer
      pkgs.vscode-extensions.hashicorp.terraform
      pkgs.vscode-extensions.jkillian.custom-local-formatters
      pkgs.vscode-extensions.kamadorueda.alejandra
      pkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.vscode-pylance # unfree
      pkgs.vscode-extensions.ms-toolsai.jupyter
      pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
      pkgs.vscode-extensions.njpwerner.autodocstring
      pkgs.vscode-extensions.shardulm94.trailing-spaces
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      pkgs.vscode-extensions.tamasfe.even-better-toml
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
    "editor.defaultFormatter" = "jkillian.custom-local-formatters";
    "editor.bracketPairColorization.enabled" = true;
    "editor.formatOnPaste" = false;
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.fontFamily" = "monospace";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 12;
    "editor.minimap.enabled" = true;
    "editor.minimap.maxColumn" = 80;
    "editor.minimap.renderCharacters" = true;
    "editor.minimap.showSlider" = "always";
    "editor.minimap.side" = "right";
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
    "window.zoomLevel" = 1.5;
    "workbench.activityBar.visible" = true;
    "workbench.editor.enablePreview" = false;
    "workbench.editor.focusRecentEditorAfterClose" = false;
    "workbench.editor.openPositioning" = "last";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
    "terminal.integrated.defaultLocation" = "editor";
    "terminal.integrated.fontSize" = 12;
    "terminal.integrated.shellIntegration.history" = 10000;
    "terminal.integrated.confirmOnExit" = "hasChildProcesses";
    "terminal.integrated.fontFamily" = "monospace";
    "terminal.integrated.scrollback" = 100000;
  };
in {
  environment.variables.EDITOR = bin;
  environment.systemPackages = [pkgs.vscode];
  programs.git = {
    enable = true;
    config = {
      core.editor = "${bin} --wait";
      diff.tool = bin;
      difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
      merge.tool = bin;
      mergetool.editor.cmd = "${bin} --wait $MERGED";
    };
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
    restartIfChanged = true;
  };
}
