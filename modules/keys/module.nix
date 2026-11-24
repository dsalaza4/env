{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.keys;
  keyNames = lib.types.enum [
    "main"
    "github-work"
  ];
  pub = name: ./. + "/${name}.pub";
in
{
  options.programs.keys = {
    enable = lib.mkEnableOption "keys — SSH logins and commit signing through 1Password";

    hosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hostname = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            key = lib.mkOption { type = keyNames; };
          };
        }
      );
      default = { };
      description = "SSH hosts and the 1Password key each one logs in with";
    };

    signing = {
      key = lib.mkOption { type = keyNames; };
      github = lib.mkOption {
        type = lib.types.nullOr keyNames;
        default = null;
        description = "signing key for repos with a github.com remote";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        includes = [ "~/.colima/ssh_config" ];
        settings =
          lib.mapAttrs (
            _: host:
            lib.optionalAttrs (host.hostname != null) { HostName = host.hostname; }
            // {
              # The .pub only picks which key the 1Password agent signs with.
              IdentityFile = "${pub host.key}";
              IdentitiesOnly = true;
            }
          ) cfg.hosts
          // {
            "*".IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
          };
      };

      git = {
        signing = {
          format = "ssh";
          signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          key = lib.fileContents (pub cfg.signing.key);
          signByDefault = true;
          allowedSigners =
            lib.concatMapStrings
              (name: ''
                * namespaces="git" ${lib.fileContents (pub name)}
              '')
              (lib.unique ([ cfg.signing.key ] ++ lib.optional (cfg.signing.github != null) cfg.signing.github));
        };
        includes = lib.optionals (cfg.signing.github != null) (
          map
            (url: {
              condition = "hasconfig:remote.*.url:${url}";
              contents.user.signingKey = lib.fileContents (pub cfg.signing.github);
            })
            [
              "git@github.com:*/**"
              "https://github.com/**"
            ]
        );
      };
    };
  };
}
