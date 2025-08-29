{ config, ... }:

let
  inherit (config.image.repart.verityStore) partitionIds;
in
{
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
}
