{ withSystem, inputs, ... }:

let
  configuration = { config, pkgs, lib, modulesPath, ... }:
    let
      inherit (config.image.repart.verityStore) partitionIds;
    in
    {
      imports = [
        "${modulesPath}/image/repart.nix"
        "${modulesPath}/profiles/image-based-appliance.nix"
      ] ++
      (with inputs.self.nixosModules; [
        kernel
        zram
      ]);

      system.image = {
        id = "router";
        version = "1";
      };

      environment.systemPackages = [
        pkgs.syncthing
        pkgs.helix
        pkgs.vim
        pkgs.starship
        pkgs.fish
        # pkgs.bcachefs-tools
      ];

      system.activationScripts.usrbinenv = lib.mkForce "";

      # nixpkgs.overlays = [
      #   (final: prev: {
      # systemd = prev.systemd.overrideAttrs {
      #   src = /home/daniel.alvsaker/Dokumenter/systemd;
      # };
      #   })
      # ];
      #
      
      # boot.initrd.systemd.package = pkgs.systemd.overrideAttrs {
      #   src = /home/daniel.alvsaker/Dokumenter/systemd;
      # };
      #
      boot.initrd.systemd.services = {
        systemd-repart.after = lib.mkForce [ ];
      };

      environment.variables.UPDATED = "success";
      #
      boot.initrd.systemd.emergencyAccess = true;
      boot.initrd.systemd.root = "tmpfs";
      systemd.enableEmergencyMode= true;

      system.etc.overlay.enable = true;
      systemd.sysusers.enable = true;
      users.users.root.initialPassword = "a";

      security.sudo.enable = false;

      boot.loader.systemd-boot.enable = true;

      boot.initrd.systemd.additionalUpstreamUnits = [ "initrd-usr-fs.target" ];

      systemd.additionalUpstreamSystemUnits = [
        "systemd-bless-boot.service"
        "boot-complete.target"
        # "systemd-firstboot.service"
      ];

      boot.initrd.supportedFilesystems = {
        ext4 = true;
        vfat = true;
      };

      boot.supportedFilesystems = {
        vfat = true;
      };

      boot.kernelParams = [ "systemd.log_level=debug" ];

      boot.initrd.compressorArgs = [ "-6" ];

      image.repart =
        let
          efiArch = pkgs.stdenv.hostPlatform.efiArch;
        in
        {
          split = true;
          verityStore.enable = true;
          mkfsOptions.erofs = [ "-Efragments,ztailpacking -zlz4hc,12 -C65536" ];

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
                Minimize = "best";
                ReadOnly = 1;
                Label = "usr-${config.system.image.version}";
                # Label = "%M_%A";
                SplitName = "%t.%U";
              };
            };

            ${partitionIds.store-verity} = {
              repartConfig = {
                # SizeMinBytes = "96M";
                # SizeMaxBytes = "96M";
                Minimize = "guess";
                Label = "verity-${config.system.image.version}";
                # Label = "%M_%A_verity";
                SplitName = "%t.%U";
                ReadOnly = 1;
              };
            };
          };
        };

      fileSystems = {
        # "/" = {
        #   fsType = "tmpfs";
        #   options = [ "mode=0755" ];
        # };

        "/nix/store" = {
          device = "/usr/nix/store";
          options = [ "bind" ];
        };

        "/var" = {
          device = "/dev/disk/by-partlabel/persistent";
          fsType = "ext4";
        };
      };

      boot.initrd.systemd.repart.enable = true;

      systemd.repart.partitions = {
        "10-esp" = {
          Type = "esp";
          Format = "vfat";
          SizeMinBytes = "100M";
          # SizeMaxBytes = "96M";
          # CopyFiles = "/boot/:/";
        };

        # "10-xbootldr" = {
        #   Type = "xbootldr";
        #   Format = "vfat";
        #   SizeMinBytes = "1G";
        #   SizeMaxBytes = "1G";
        #   SupplementFor = "10-esp";
        # };

        "20-usr-verity-a" = {
          inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type Verity;
          VerityMatchKey = "store-a";
          VerityHashBlockSizeBytes = 4096;
          VerityDataBlockSizeBytes = 4096;
        };

        "22-usr-a" = {
          inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type Verity;

          VerityMatchKey = "store-a";
          # Minimize = "guess";

          # SizeMinBytes = "1G";
          SizeMaxBytes = "5G";

          # CopyBlocks = "auto";
        };

        "30-usr-verity-b" = {
          # inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type;
          inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type Verity;

          VerityMatchKey = "store-b";

          # SizeMinBytes = "96M";
          # SizeMaxBytes = "96M";
          VerityHashBlockSizeBytes = 4096;
          VerityDataBlockSizeBytes = 4096;
          Label = "_empty";
          Minimize = "guess";
          # ReadOnly = 1;
        };

        "32-usr-b" = {
          # inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type;
          inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type Verity;

          VerityMatchKey = "store-b";
          # Minimize = "guess";

          # SizeMinBytes = "1G";
          SizeMaxBytes = "5G";
          Label = "_empty";
          ReadOnly = 1;
        };

        "40-var" = {
          Type = "var";
          Format = "ext4";
          Label = "persistent";
          SizeMinBytes = "2G";
          # Encrypt = "tpm2";
          SplitName = "-";

          FactoryReset = "yes";
        };
      };

      systemd.sysupdate = {
        enable = true;
        reboot.enable = true;
        transfers = {
          ${partitionIds.esp} = {
            Transfer = {
              ProtectVersion = "%A";
            };
            
            Source = {
              Type = "regular-file";
              Path = "/var/updates/";

              MatchPattern = [
                "${config.boot.uki.name}_@v.efi"
              ];
            };

            Target = {
              Type = "regular-file";
              Path = "/EFI/Linux";
              MatchPattern = "${config.boot.uki.name}_@v.efi";
              PathRelativeTo = "esp";
            };
          };

          ${partitionIds.store-verity} = {
            Transfer = {
              ProtectVersion = "%A";
            };

            Source = {
              Type = "regular-file";
              Path = "/var/updates/";
              MatchPattern = [
                "${config.system.image.id}_@v.usr-%a-verity.@u.raw"
              ];
            };

            Target = {
              Type = "partition";
              Path = "auto";
              MatchPattern = "verity-@v";
              MatchPartitionType = "usr-verity";
              ReadOnly = 1;
            };
          };

          ${partitionIds.store} = {
            Transfer = {
              ProtectVersion = "%A";
            };

            Source = {
              Type = "regular-file";
              Path = "/var/updates/";
              MatchPattern = "${config.system.image.id}_@v.usr-%a.@u.raw";
            };

            Target = {
              Type = "partition";
              Path = "auto";
              MatchPattern = "usr-@v";
              MatchPartitionType = "usr";
              ReadOnly = 1;
            };
          };
        };
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
