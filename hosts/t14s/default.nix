{ config, pkgs, lib, outputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/global
      ../common/optional/bluetooth.nix
      ../common/optional/steam.nix
      ../common/optional/kernel.nix
      ../../users/daniel
      ./networks/wlan.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.fwupd.enable = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-43cff19d-a693-4065-b6e7-307f82bfca2c".device = "/dev/disk/by-uuid/43cff19d-a693-4065-b6e7-307f82bfca2c";
  boot.initrd.luks.devices."luks-43cff19d-a693-4065-b6e7-307f82bfca2c".keyFile = "/crypto_keyfile.bin";

  networking = {
    hostName = "t14s";
    useDHCP = false;
    wireless.iwd.enable = true;
  };

  systemd.network = {
    enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "nb_NO.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    enable = false;
    layout = "us";
    libinput.enable = true;
    xkbVariant = "colemak_dh";
  };

  services.tlp.settings = {
    DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
  };

  environment.systemPackages = [ pkgs.jetbrains.rider ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pam.services.swaylock = { };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
