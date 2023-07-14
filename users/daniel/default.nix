{ config, pkgs, ... }:
{
  sops.secrets.daniel-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  users.users.daniel = {
    isNormalUser = true;
    description = "daniel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
    # passwordFile = config.sops.secrets.daniel-password.path;
  };
}
