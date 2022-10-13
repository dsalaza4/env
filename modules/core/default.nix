{config, lib, pkgs, ...}:
{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = let
      packages = pkgs.linuxPackages_latest;
    in
      builtins.trace "Linux: ${packages.kernel.version}" packages;
  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.package = let
    package = pkgs.nixUnstable;
  in
    builtins.trace "Nix: ${package.version}" package;
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}