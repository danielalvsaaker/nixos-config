{ withSystem, inputs, ... }:

let
  configuration = { pkgs, inputs, ... }: {
    imports = (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-t14s-amd-gen1
    ]) ++
    (with inputs.self.nixosModules; [
      default
      sway
      bluetooth
      lanzaboote
      plymouth
      gnome
      fprint
    ]) ++
    [
      ./hardware-configuration.nix
      ./networks/wlan.nix
    ];

    system.stateVersion = "24.05";
    time.timeZone = "Europe/Oslo";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.initrd.systemd.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    services.fwupd.enable = true;

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

    services.tlp.settings = {
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    security.polkit.enable = true;
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
in
{
  flake.nixosConfigurations.t14s = withSystem "x86_64-linux" ({ system, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        configuration
        ./users
      ];
    }
  );
}
