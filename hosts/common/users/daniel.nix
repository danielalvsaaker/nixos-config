{ pkgs, config, lib, ... }:

{
  environment.systemPackages = [
    pkgs.oksh
  ];
  users.users.daniel = {
    isNormalUser = true;
    description = "daniel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.oksh;
  };
}
