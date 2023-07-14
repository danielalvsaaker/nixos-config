{ nixos-wsl, ... }:

{
  imports = [
    ../common/global
    ../../users/daniel
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "daniel";
    wslConf.automount.root = "/mnt";
    nativeSystemd = true;
  };
}
