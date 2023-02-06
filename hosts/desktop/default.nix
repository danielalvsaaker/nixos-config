# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/global
      ../common/optional/steam.nix
      ../common/optional/kernel.nix
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
  boot.initrd.luks.devices."luks-bf8166af-73cb-497e-a5c1-6f89957ddc3a".device = "/dev/disk/by-uuid/bf8166af-73cb-497e-a5c1-6f89957ddc3a";
  boot.initrd.luks.devices."luks-bf8166af-73cb-497e-a5c1-6f89957ddc3a".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "nb_NO.UTF-8";


  # Configure keymap in X11
  services.xserver = {
    enable = false;
    displayManager.startx.enable = true;
    layout = "us";
    xkbVariant = "colemak_dh";
    libinput.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };


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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
