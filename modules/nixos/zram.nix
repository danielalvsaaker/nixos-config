{ lib, ... }:
{
  services.zram-generator = {
    enable = true;

    settings.zram0 = {
      zram-size = "ram";
      compression-algorithm = lib.mkDefault "zstd";
    };
  };


  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

}
