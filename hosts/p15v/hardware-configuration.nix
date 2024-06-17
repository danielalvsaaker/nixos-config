# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a10058bd-5124-4c3f-9f84-be094d9df415";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/a10058bd-5124-4c3f-9f84-be094d9df415";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/a10058bd-5124-4c3f-9f84-be094d9df415";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/B908-4260";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/fb1fa53d-820f-4de5-b80b-b71ee157cc8e"; }];

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/79ad2842-9104-48a8-8070-b739f673e9ca";
    preLVM = true;
    allowDiscards = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
