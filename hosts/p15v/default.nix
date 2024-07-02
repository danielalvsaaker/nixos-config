{ withSystem, inputs, ... }:

let
  configuration = { pkgs, inputs, ... }: {
    imports = (with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop
      common-pc-laptop-ssd
      common-gpu-nvidia-disable
      "${inputs.nixos-hardware}/common/cpu/intel/tiger-lake"
    ]) ++
    (with inputs.self.nixosModules; [
      default
      kernel
      bluetooth
      lanzaboote
      plymouth
      gnome
      fprint
      cloudflare-warp
    ]) ++
    [
      inputs.falcon-sensor-nixos.nixosModules.default
      ./hardware-configuration.nix
      ./networks/wlan.nix
    ];

    system.replaceRuntimeDependencies = [
      ({
        original = pkgs.mesa;
        replacement = inputs.nixpkgs-staging.legacyPackages.x86_64-linux.mesa;
      })

      ({
        original = pkgs.mesa.drivers;
        replacement = inputs.nixpkgs-staging.legacyPackages.x86_64-linux.mesa.drivers;
      })
    ];

    system.stateVersion = "24.05";
    time.timeZone = "Europe/Oslo";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.initrd.systemd.enable = true;

    services.xserver = {
      displayManager.gdm.enable = true;
      videoDrivers = [ "displaylink" "modesetting" ];
    };

    services.fwupd.enable = true;

    networking = {
      hostName = "p15v";
      useDHCP = false;
      wireless.iwd.enable = true;
    };

    systemd.network = {
      enable = true;
    };

    nix.settings.preallocate-contents = false;

    # Select internationalisation properties.
    i18n.defaultLocale = "nb_NO.UTF-8";

    # Enable sound with pipewire.
    sound.enable = true;
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
  flake.nixosConfigurations.p15v = withSystem "x86_64-linux" ({ system, ... }:
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
