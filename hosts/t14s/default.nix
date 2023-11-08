{ withSystem, inputs, ... }:

let
  configuration = { pkgs, ... }: {
    imports = [
      ./hardware-configuration.nix
      inputs.self.nixosModules.bluetooth
      inputs.self.nixosModules.kernel
      inputs.self.nixosModules.default
      ./networks/wlan.nix
    ];

    system.stateVersion = "22.11";
    time.timeZone = "Europe/Oslo";

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
  };
in
{
  flake.nixosConfigurations.t14s = withSystem "x86_64-linux" ({ system, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs system; };

      modules = (with inputs.nixos-hardware.nixosModules; [
        lenovo-thinkpad-t14s-amd-gen1
      ]) ++
      [
        configuration
        inputs.self.nixosModules.user-daniel
        inputs.self.nixosModules.home-manager
        {
          home-manager.users.daniel = {
            imports = [
              ../../home/daniel/t14s.nix
              inputs.self.homeManagerModules.program-discord
              inputs.self.homeManagerModules.program-foot
              inputs.self.homeManagerModules.program-firefox
              inputs.self.homeManagerModules.program-element
              inputs.self.homeManagerModules.program-sway
            ];
          };
        }
      ];
    }
  );
}
