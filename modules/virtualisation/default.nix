{config, ...}: {
  virtualisation = {
    docker.enable = true;
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest = {
        enable = true;
        x11 = true;
      };
    };
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
    "i686-linux"
    "i686-windows"
    "mipsel-linux"
    "x86_64-windows"
  ];

  users.groups.docker = {};
  users.users.nixos.extraGroups = ["docker" "vboxusers"];
}
