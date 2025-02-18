{ withSystem, inputs, ... }:

let
  configuration = { pkgs, inputs, ... }: {
    imports = (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-t14s-amd-gen1
    ]) ++
    (with inputs.self.nixosModules; [
      default
      bluetooth
      lanzaboote
      plymouth
      gnome
      fprint
      steam
    ]) ++
    [
      ./hardware-configuration.nix
    ];

    system.stateVersion = "24.05";
    time.timeZone = "Europe/Oslo";

    networking.firewall.checkReversePath = "loose";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.initrd.systemd.enable = true;

    services.fwupd.enable = true;

    networking = {
      hostName = "t14s";
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    systemd.network = {
      enable = true;
      wait-online.enable = false;
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "nb_NO.UTF-8";

    boot.extraModprobeConfig = ''
      options iwlwifi 11n_disable=8
    '';

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    security.polkit.enable = true;
    hardware.graphics.enable = true;
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
