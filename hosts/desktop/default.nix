{ withSystem, inputs, ... }:

let
  configuration = { pkgs, inputs, config, ... }: {
    imports = (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
    ]) ++
    (with inputs.self.nixosModules; [
      default
      steam
      bluetooth
      kernel
    ]) ++
    [
      ./hardware-configuration.nix
    ];

    system.stateVersion = "22.11";

    services.fwupd.enable = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    boot.kernelModules = [ "zenpower" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    boot.blacklistedKernelModules = [ "k10temp" ];

    boot.supportedFilesystems = [ "bcachefs" ];

    # systemd.network.enable = true;
    networking.hostName = "desktop"; # Define your hostname.

    networking.useDHCP = false;
    systemd.network = {
      enable = true;
      networks."10-enp4s0" = {
        matchConfig.Name = "enp4s0";
        networkConfig.DHCP = "yes";
      };
    };

    time.timeZone = "Europe/Oslo";

    i18n.defaultLocale = "nb_NO.UTF-8";

    hardware.opengl = {
      enable = true;
      driSupport = true;
    };

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

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.polkit.enable = true;
    security.rtkit.enable = true;
    security.pam.services.swaylock = { };
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

      specialArgs = { inherit inputs system; };

      modules = [
        configuration
        ./users
      ];
    }
  );
}
