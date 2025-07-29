{ withSystem, inputs, ... }:

let
  configuration = { config, pkgs, lib, modulesPath, ... }: {
    imports = [
      "${modulesPath}/image/repart.nix"
    ];

    image.repart =
      let
        efiArch = pkgs.stdenv.hostPlatform.efiArch;
        inherit (config.image.repart.verityStore) partitionIds;
      in
      {
        verityStore.enable = true;

        partitions = {
          ${partitionIds.esp} = {
            contents = {
              "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

              "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
            };

            repartConfig = {
              Type = "esp";
              Format = "vfat";
              SizeMinBytes = "256M";
              SplitName = "-";
            };
          };

          ${partitionIds.store} = {
            storePaths = [ config.system.build.toplevel ];
            stripNixStorePrefix = true;
            repartConfig = {
              Type = "linux-generic";
              Label = "store_${config.system.image.version}";
              Format = "squashfs";
              Minimize = "off";
              ReadOnly = "yes";

              SizeMinBytes = "1G";
              SizeMaxBytes = "1G";
              SplitName = "store";
            };
          };

          "store-empty" = {
            repartConfig = {
              Type = "linux-generic";
              Label = "_empty";
              Minimize = "off";
              SizeMinBytes = "1G";
              SizeMaxBytes = "1G";
              SplitName = "-";
            };
          };

          "var" = {
            repartConfig = {
              Type = "var";
              UUID = "4d21b016-b534-45c2-a9fb-5c16e091fd2d";
              Format = "xfs";
              Label = "nixos-persistent";
              Minimize = "off";

              SizeMinBytes = "2G";
              SizeMaxBytes = "2G";
              SplitName = "-";

              FactoryReset = "yes";
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
