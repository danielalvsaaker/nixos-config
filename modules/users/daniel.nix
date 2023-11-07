{
  flake.nixosModules.user-daniel = { pkgs, ... }:
  {
    users.users.daniel = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4+o1LN6oSC3EF6SssSWix1E2rITekaC2GtA8Pb3+TL daniel@t14s"
      ];
    };
  };
}
