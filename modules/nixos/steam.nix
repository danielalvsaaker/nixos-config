{
  flake.nixosModules.steam = { config, pkgs, ... }:
    {
      config = {
        nixpkgs.config.allowUnfree = true;
        hardware.opengl = {
          enable = true;
          driSupport = true;
        };

        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
