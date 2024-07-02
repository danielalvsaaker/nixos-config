{ withSystem, inputs, ... }:

let
  configuration = { pkgs, inputs, config, lib, ... }: {
    imports = (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
    ]) ++
    (with inputs.self.nixosModules; [
      default
      steam
      sway
      bluetooth
      plymouth
      gnome
      lact
    ]) ++
    [
      ./hardware-configuration.nix
    ];

    system.stateVersion = "24.11";

    services.fwupd.enable = true;

    # Bootloader.
    boot.loader = {
      systemd-boot.enable = true;
      timeout = 10;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

    };

    boot.kernelModules = [ "zenpower" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    boot.blacklistedKernelModules = [ "k10temp" ];

    networking.hostName = "desktop"; # Define your hostname.

    networking.useDHCP = false;
    systemd.network = {
      enable = true;
      networks."10-enp5s0" = {
        matchConfig.Name = "enp5s0";
        networkConfig.DHCP = "yes";
      };
    };

    time.timeZone = "Europe/Oslo";

    i18n.defaultLocale = "nb_NO.UTF-8";

    hardware.graphics.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
in
{
  flake.nixosConfigurations.desktop = withSystem "x86_64-linux" ({ system, ... }:
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
