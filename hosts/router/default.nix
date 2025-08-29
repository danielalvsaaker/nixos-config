{ withSystem, inputs, ... }:

let
  configuration = { config, pkgs, lib, modulesPath, ... }:
    {
      imports = [
        "${modulesPath}/image/repart.nix"
        "${modulesPath}/profiles/image-based-appliance.nix"
        ./filesystems.nix
      ] ++
      (with inputs.self.nixosModules; [
        kernel
        zram
      ]);

      system.image = {
        id = "router";
        version = "1";
      };

      system.activationScripts.usrbinenv = lib.mkForce "";

      boot.initrd.systemd.services = {
        systemd-repart.after = lib.mkForce [ ];
      };

      environment.variables.UPDATED = "success";
      boot.initrd.systemd.emergencyAccess = true;
      systemd.enableEmergencyMode = true;

      system.etc.overlay.enable = true;
      systemd.sysusers.enable = true;
      users.users.root.initialPassword = "a";

      security.sudo.enable = false;

      boot.loader.systemd-boot.enable = true;

      systemd.additionalUpstreamSystemUnits = [
        "systemd-bless-boot.service"
        "boot-complete.target"
      ];

      boot.initrd.compressorArgs = [ "-6" ];

      boot.initrd.availableKernelModules = [ "sd_mod" "sdhci" "dm_mod" "usbhid" "usb_storage" "sdhci_pci" ];
    };
in
{
  flake.nixosConfigurations.router = withSystem "x86_64-linux" ({ system, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [ configuration ];
    });
}
