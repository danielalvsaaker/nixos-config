{ lib, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault false;
  };
}
