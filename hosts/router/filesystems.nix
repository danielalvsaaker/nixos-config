{ config, pkgs, lib, ... }:
let
  inherit (config.image.repart.verityStore) partitionIds;
in
{
  fileSystems = {
    "/nix/store" = {
      device = "/usr/nix/store";
      options = [ "bind" ];
    };

    "/var" = {
      device = "/dev/disk/by-partlabel/persistent";
      fsType = "ext4";
    };
  };

  boot.initrd.supportedFilesystems = {
    ext4 = true;
    vfat = true;
  };

  # Automount root on tmpfs
  boot.initrd.systemd.root = "tmpfs";
  # Automount usr
  boot.initrd.systemd.additionalUpstreamUnits = [ "initrd-usr-fs.target" ];

  boot.supportedFilesystems = {
    vfat = true;
  };

  image.repart =
    let
      efiArch = pkgs.stdenv.hostPlatform.efiArch;
    in
    {
      split = true;
      verityStore.enable = true;
      mkfsOptions.erofs = [
        "-Efragments,ztailpacking"

        # "-C1048576"
        "-zlz4hc,level=12"
      ];

      partitions = {
        ${partitionIds.esp} = {
          contents = {
            "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
              "${pkgs.systemdUkify}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
          };

          repartConfig = {
            Type = "esp";
            Format = "vfat";
            SizeMinBytes = "100M";
            SizeMaxBytes = "100M";
            SplitName = "-";
          };
        };

        ${partitionIds.store} = {
          repartConfig = {
            Minimize = "guess";
            ReadOnly = 1;
            Label = "usr-${config.system.image.version}";
            SizeMaxBytes = "5G";
            SplitName = "%t.%U";
          };
        };

        ${partitionIds.store-verity} = {
          repartConfig = {
            Weight = 0;
            Label = "verity-${config.system.image.version}";
            SplitName = "%t.%U";
            ReadOnly = 1;
            VerityDataBlockSizeBytes = 512;
            VerityHashBlockSizeBytes = 512;
          };
        };
      };
    };

  boot.initrd.systemd.repart.enable = true;
  systemd.repart.partitions = {
    "10-esp" = {
      Type = "esp";
      Format = "vfat";
      SizeMinBytes = "100M";
    };

    "20-usr-verity-a" = {
      inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type;
    };

    "22-usr-a" = {
      inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type;
      SizeMaxBytes = "5G";
      ReadOnly = 1;
    };

    "30-usr-verity-b" = {
      inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type Verity;

      VerityDataBlockSizeBytes = 512;
      VerityHashBlockSizeBytes = 512;

      VerityMatchKey = "store-b";
      Weight = 0;
      Label = "_empty";
      ReadOnly = 1;
    };

    "32-usr-b" = {
      inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type Verity;

      VerityMatchKey = "store-b";

      SizeMaxBytes = "5G";
      Label = "_empty";
      ReadOnly = 1;
    };

    "40-var" = {
      Type = "var";
      Format = "ext4";
      Label = "persistent";
      SizeMinBytes = "2G";
      SplitName = "-";

      FactoryReset = "yes";
    };
  };
}
