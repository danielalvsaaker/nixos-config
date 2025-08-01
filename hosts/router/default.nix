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
        version = "2";
      };

      # nixpkgs.overlays = [
      #   (final: prev: {
      # systemd = prev.systemd.overrideAttrs {
      #   src = /home/daniel.alvsaker/Dokumenter/systemd;
      # };
      #   })
      # ];
      #
      
      boot.initrd.systemd.package = pkgs.systemd.overrideAttrs {
        src = /home/daniel.alvsaker/Dokumenter/systemd;
      };

      environment.systemPackages = [ pkgs.helix pkgs.vim ];
      environment.variables.UPDATED = "success";
      #
      boot.initrd.systemd.emergencyAccess = true;
      systemd.enableEmergencyMode= true;

      system.etc.overlay.enable = true;
      systemd.sysusers.enable = true;
      users.users.root.initialPassword = "abc";

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
      };

      image.repart =
        let
          efiArch = pkgs.stdenv.hostPlatform.efiArch;
        in
        {
          split = true;
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
                Label = "usr-${config.system.image.version}";
                SplitName = "usr";
              };
            };

            ${partitionIds.store-verity} = {
              repartConfig = {
                # SizeMinBytes = "96M";
                # SizeMaxBytes = "96M";
                Minimize = "guess";
                Label = "verity-${config.system.image.version}";
                SplitName = "verity";
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

        "/var" = {
          device = "/dev/sda6";
          fsType = "ext4";
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
          # SizeMinBytes = "96M";
          # SizeMaxBytes = "96M";
        };

        "22-usr-a" = {
          inherit (config.image.repart.partitions.${partitionIds.store}.repartConfig) Type;

          SizeMinBytes = "1G";
          SizeMaxBytes = "1G";
        };

        "30-usr-verity-b" = {
          inherit (config.image.repart.partitions.${partitionIds.store-verity}.repartConfig) Type;

          # SizeMinBytes = "96M";
          # SizeMaxBytes = "96M";
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

        "40-var" = {
          Type = "var";
          Format = "ext4";
          Label = "persistent";
          SizeMinBytes = "2G";
          SplitName = "-";

          FactoryReset = "yes";
        };
      };

      systemd.sysupdate = {
        enable = true;
        reboot.enable = true;
        transfers = {
          ${partitionIds.esp} = {
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
            Source = {
              Type = "regular-file";
              Path = "/var/updates/";
              MatchPattern = [
                "${config.system.image.id}_@v.verity"
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
            Source = {
              Type = "regular-file";
              Path = "/var/updates/";
              MatchPattern = "${config.system.image.id}_@v.usr";
            };

            Target = {
              Type = "partition";
              Path = "/dev/sda";
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
