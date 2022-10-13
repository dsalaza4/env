{lib, ...}: {
  networking.hostName = "nixos";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  users.users.dsalazar.extraGroups = ["networkmanager"];
}
