# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, outputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/global
      ../common/users/daniel.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-43cff19d-a693-4065-b6e7-307f82bfca2c".device = "/dev/disk/by-uuid/43cff19d-a693-4065-b6e7-307f82bfca2c";
  boot.initrd.luks.devices."luks-43cff19d-a693-4065-b6e7-307f82bfca2c".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "t14s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "nb_NO.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    desktopManager.xterm.enable = false;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
    enable = true;
    layout = "us";
    libinput.enable = true;
    xkbVariant = "colemak_dh";
  };


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
