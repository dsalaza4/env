{
  alejandra,
  config,
  editor,
  makes,
  pkgs,
  pythonOnNix,
  ...
}: let
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "terraform";
      publisher = "4ops";
      version = "0.2.5";
      sha256 = "0ciagyhxcxikfcvwi55bhj0gkg9p7p41na6imxid2mxw2a7yb4nb";
    }
    {
      name = "cucumberautocomplete";
      publisher = "alexkrechik";
      version = "2.15.2";
      sha256 = "1kaxvszpj5cami7k52ddzd9fc108pzz1ga5hhi78b468azplkl1i";
    }
    {
      name = "nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "systemd-unit-file";
      publisher = "coolbear";
      version = "1.0.6";
      sha256 = "0sc0zsdnxi4wfdlmaqwb6k2qc21dgwx6ipvri36x7agk7m8m4736";
    }
    {
      name = "rasi";
      publisher = "dlasagno";
      version = "1.0.0";
      sha256 = "1yg9n2gsma5m0l76gch0m9mj2r0k2594cv4w90dx0w7px2aimbdk";
    }
    {
      name = "vscode-jest-runner";
      publisher = "firsttris";
      version = "0.4.60";
      sha256 = "sha256-7FJlK9Bb+60ErlcfHm8LoCT1aqWFiL4Z9pwxIi1EwY4=";
    }
    {
      name = "github-vscode-theme";
      publisher = "github";
      version = "6.3.3";
      sha256 = "sha256-fN9ljeZlbbSNW9qggLEz5HOLZlPhHmTHNi1VsZo7Uxk=";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "2023.2.1204";
      sha256 = "sha256-FurYfkw+mOjyymR1VCGf0jJ2JCZJ8eGb1J7zD2peBjw=";
    }
    {
      name = "gc-excelviewer";
      publisher = "grapecity";
      version = "4.2.56";
      sha256 = "1fcy4q6y8z0nzyi473dmisc7s2s6710vkx9krjb8n3lgmb2s9cln";
    }
    {
      name = "vscode-graphql";
      publisher = "graphql";
      version = "0.8.5";
      sha256 = "sha256-hmMD3+Om1SPBST1wnyHRwvJESLbpYl2aaiNZPYmYRNQ=";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.25.2";
      sha256 = "sha256-mF/GHt2VOoJyEbIC9wj//FJXeGVg12MY6YJzjv470bM=";
      arch = "linux-x64";
    }
    {
      name = "custom-local-formatters";
      publisher = "jkillian";
      version = "0.0.6";
      sha256 = "1xvz4kxws7d7snd6diidrsmz0c5mm9iz8ihiw1vg65r2x8xf900m";
    }
    {
      name = "alejandra";
      publisher = "kamadorueda";
      version = "1.0.0";
      sha256 = "1ncjzhrc27c3cwl2cblfjvfg23hdajasx8zkbnwx5wk6m2649s88";
    }
    {
      name = "bash-ide-vscode";
      publisher = "mads-hartmann";
      version = "1.33.0";
      sha256 = "sha256-MlNUoTgDBbDcsKjCXrb17jirHiR8iNpq8ldJ6OKrYas=";
    }
    {
      name = "vscode-graphql-syntax";
      publisher = "GraphQL";
      version = "1.0.6";
      sha256 = "sha256-OScAXEchvHsCn3sjWcm9641yzgT+7iwO40rOAeHlmVw=";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "3.5.0";
      sha256 = "sha256-q2DdFc7Q4MYr03+mDyMtYr3+5Fy4oPq7c69LIkTZz8I=";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2023.3.10411009";
      sha256 = "sha256-/a1AWEZzVRmq5JS2L6CS6ULpvRAA4wR3Rw5Dap9MNO0=";
    }
    {
      name = "vscode-pylance";
      publisher = "ms-python";
      version = "2023.2.21";
      sha256 = "sha256-JJxTfSm5nJwB0jWK+jJ7SqNMt/4fu1ILHJYyobNO2WY=";
    }
    {
      name = "jupyter";
      publisher = "ms-toolsai";
      version = "2023.2.1000451018";
      sha256 = "sha256-gQntEA2O9jiSk1Im2oEIoEgxukQ5kn7TPDDGz+3hMiE=";
    }
    {
      name = "jupyter-renderers";
      publisher = "ms-toolsai";
      version = "1.0.15";
      sha256 = "sha256-JR6PunvRRTsSqjSGGAn/1t1B+Ia6X0MgqahehcuSNYA=";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.24.0";
      sha256 = "sha256-hJy+ymnlF9a2vvN/HhJ5N75lIc2afzkq+S0Cv/KnD3M=";
    }
    {
      name = "autodocstring";
      publisher = "njpwerner";
      version = "0.6.1";
      sha256 = "11vsvr3pggr6xn7hnljins286x6f5am48lx4x8knyg8r7dp1r39l";
    }
    {
      name = "trailing-spaces";
      publisher = "shardulm94";
      version = "0.4.1";
      sha256 = "15i1xcd7p6xfb8kj90irznf4xw48mmwzc528zrk3kiniy9nkbcd4";
    }
    {
      name = "just";
      publisher = "skellock";
      version = "2.0.0";
      sha256 = "1ph869zl757a11f8iq643f79h8gry7650a9i03mlxyxlqmspzshl";
    }
    {
      name = "code-spell-checker";
      publisher = "streetsidesoftware";
      version = "2.16.0";
      sha256 = "sha256-Qr4cYAEvAkvvE6KytVeInJzcMQJZqr/e/KPfelVzjUA=";
    }
    {
      name = "even-better-toml";
      publisher = "tamasfe";
      version = "0.19.0";
      sha256 = "0xfnprgbafy7sfdqwdw92lr8k3h3fbylvhq1swgv31akndm9191j";
    }
  ];
  userSettings = {
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
            #! ${pkgs.zsh}/bin/zsh
            ${pythonOnNix.black-latest-python39-bin}/bin/black \
              --config \
              ${makes}/src/evaluator/modules/format-python/settings-black.toml \
              - \
              | \
            ${pythonOnNix.isort-latest-python39-bin}/bin/isort \
              --settings-path \
              ${makes}/src/evaluator/modules/format-python/settings-isort.toml \
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
            #! ${pkgs.zsh}/bin/zsh
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
      "${makes}/src/evaluator/modules/lint-python/settings-mypy.cfg"
    ];
    "python.linting.mypyEnabled" = true;
    "python.linting.mypyPath" = "${pythonOnNix.mypy-latest-python39-bin}/bin/mypy";
    "python.linting.prospectorArgs" = [
      "--profile"
      "${makes}/src/evaluator/modules/lint-python/settings-prospector.yaml"
    ];
    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
    "python.linting.prospectorEnabled" = true;
    "python.linting.prospectorPath" = "${pythonOnNix.prospector-latest-python39-bin}/bin/prospector";
    "python.linting.pylintEnabled" = false;
    "security.workspace.trust.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "window.zoomLevel" = 1;
    "window.menuBarVisibility" = "toggle";
    "workbench.activityBar.visible" = true;
    "workbench.editor.enablePreview" = true;
    "workbench.editor.enablePreviewFromQuickOpen" = true;
    "workbench.editor.focusRecentEditorAfterClose" = false;
    "workbench.editor.openPositioning" = "last";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
    "workbench.colorTheme" = "GitHub Dark";
  };
in {
  environment.variables.EDITOR = "${editor}/bin/code --wait";
  home-manager.users.nixos.programs.vscode = {
    enable = true;
    package = editor;
    mutableExtensionsDir = false;
    inherit extensions;
    inherit userSettings;
  };
}
