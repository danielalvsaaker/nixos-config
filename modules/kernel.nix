{
  flake.nixosModules.kernel = { lib, pkgs, ... }: {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
