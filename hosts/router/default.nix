{ withSystem, inputs, ... }:

let
  configuration = { config, pkgs, lib, modulesPath, ... }:
  let
        inherit (config.image.repart.verityStore) partitionIds;
  in {
    imports = [
      "${modulesPath}/image/repart.nix"
      "${modulesPath}/profiles/image-based-appliance.nix"
    ] ++
    (with inputs.self.nixosModules; [
      zram
    ]);

    system.image = {
      id = "router";
      version = "1";
    };

    nixpkgs.overlays = [
      (final: prev: {
        systemd = prev.systemd.overrideAttrs {
          src = /home/daniel.alvsaker/Dokumenter/systemd;
        };
      })
    ];

    system.etc.overlay.enable = true;
    systemd.sysusers.enable = true;
    users.users.root.initialPassword = "abc";

    security.sudo.enable = false;

    boot.loader.systemd-boot.enable = true;

    boot.initrd.systemd.additionalUpstreamUnits = [ "initrd-usr-fs.target" ];

    image.repart =
      let
        efiArch = pkgs.stdenv.hostPlatform.efiArch;
      in
      {
        verityStore.enable = true;

        partitions = {
          ${partitionIds.esp} = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemdUkify}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
            };

            repartConfig = {
              Type = "esp";
              Format = "vfat";
              SizeMinBytes = "96M";
              SizeMaxBytes = "96M";
              SplitName = "-";
            };
          };

          ${partitionIds.store} = {
            repartConfig = {
              Minimize = "best";
              ReadOnly = 1;
            };
          };

          ${partitionIds.store-verity} = {
            repartConfig = {
              Minimize = "best";
              ReadOnly = 1;
            };
          };
        };
      };

    fileSystems = {
      "/" = {
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };
      
      "/nix/store" = {
        device = "/usr/nix/store";
        options = [ "bind" ];
      };
    };

    boot.initrd.systemd.repart.enable = true;

    systemd.repart.partitions = {
      "10-esp" = {
        Type = "esp";
        Format = "vfat";
        SizeMinBytes = "96M";
        SizeMaxBytes = "96M";
      };

      "20-usr-verity-a" = {
        inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type;
        SizeMinBytes = "96M";
        SizeMaxBytes = "96M";
      };

      "22-usr-a" = {
        inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type;

        SizeMinBytes = "1G";
        SizeMaxBytes = "1G";
      };

      "30-usr-verity-b" = {
        inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type;

        SizeMinBytes = "96M";
        SizeMaxBytes = "96M";
        Label = "_empty";
        ReadOnly = 1;
      };

      "32-usr-b" = {
        inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type;
        SizeMinBytes = "1G";
        SizeMaxBytes = "1G";
        Label = "_empty";
        ReadOnly = 1;
      };

      # "40-var" = {
      #     Type = "var";
      #     Format = "xfs";
      #     Label = "persistent";
      #     SizeMinBytes = "2G";
      #     SplitName = "-";

      #     FactoryReset = "yes";
      # };
    };
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
