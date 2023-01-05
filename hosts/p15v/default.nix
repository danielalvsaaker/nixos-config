{ inputs, ... }:

let
  inherit (inputs) nixos-wsl;

in
{
  imports = [
    ../common/global
    ../common/users/daniel.nix
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "daniel";
    wslConf.automount.root = "/mnt";
    nativeSystemd = true;
  };
}
