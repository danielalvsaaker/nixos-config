{ lib, users, ... }:
let
  gpuIds = [
    "10de:1c03" # Video
    "10de:10f1" # Audio
  ];
in
{
  virtualisation.libvirtd.enable = true;
  users.users."daniel".extraGroups = [ "libvirtd" ];

  #options.vfio.enable = mkEnableOption "Configure machine for VFIO";

  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    kernelParams = [
      "amd_iommu=on"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIds)
    ];
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
