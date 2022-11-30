{
  alejandra,
  config,
  editor,
  makes,
  pkgs,
  pythonOnNix,
  ...
}: let
  # For sha256 use:
  # $ nix-prefetch-url \
  # "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
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
      version = "0.4.59";
      sha256 = "1y2dx4jwzifzg11ypgcnihdvgyz4i9vqlhy2gbvhhyaaj7gizmp3";
    }
    {
      name = "github-vscode-theme";
      publisher = "github";
      version = "6.3.2";
      sha256 = "1mzqss2sj8sl0av0px649s26xg3ybiq7djdw5yb092v2hjr5kc89";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "2022.11.804";
      sha256 = "06fivcfszynlynv5khpi5dzwk230jlgh4xmdq7ffhblnwp78j3i1";
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
      version = "0.8.1";
      sha256 = "0lpki26pkam5xyrbaiwp913li679xxxbzc5bpi8vyx9zzmdprvhy";
    }
    {
      name = "terraform";
      publisher = "hashicorp";
      version = "2.24.3";
      sha256 = "121wwdg579yyfcjwl7xvd1l0vv3d4rlr1vj4yd25ah6r5kkq56p7";
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
      version = "1.14.0";
      sha256 = "058z0fil0xpbnay6b5hgd31bgd3k4x3rnfyb8n0a0m198sxrpd5z";
    }
    {
      name = "vscode-graphql-syntax";
      publisher = "GraphQL";
      version = "1.0.4";
      sha256 = "0l2bniz4iq2bpcdxzpfm810i0zqfpx7xjhrvhyky0avi5i285q7v";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "3.4.4";
      sha256 = "0jw38vf3pzplw5dnhs8b9fxqc4z5b198wjw3y3ll14xjzxc5ymns";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2022.19.13121543";
      sha256 = "07k30zs8xkdsq4rp6r06pb749brxn9rlb1g415x1hwqg5sx8dddh";
    }
    {
      name = "vscode-pylance";
      publisher = "ms-python";
      version = "2022.11.11";
      sha256 = "11wzs9gwxdl507k0abhghcdj36dvw1nbpnfyvrhnrjca77sqgwm8";
    }
    {
      name = "jupyter";
      publisher = "ms-toolsai";
      version = "2022.11.1003141027";
      sha256 = "086jds1kx51k33jin9b90j26kk79v1h10vrgp66wgwd2d19q4vdy";
    }
    {
      name = "jupyter-renderers";
      publisher = "ms-toolsai";
      version = "1.0.12";
      sha256 = "12l5z60kpz3nx77l8ck6a6w4qdzyz3xkn6k9670r30w365q9lf0z";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.22.0";
      sha256 = "0irrivfidgjqfd205gh27r2ccj2anvqgvq7lfaaf92wrrc2zvlsk";
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
      version = "2.11.0";
      sha256 = "096y1yiwh5bvlcg3abby9nvwapq0nhx4szcmi9k2qxf5xw4y91k5";
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
