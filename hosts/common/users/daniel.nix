{ pkgs, ... }:
{
  users.users.daniel = {
    isNormalUser = true;
    description = "daniel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };

}
