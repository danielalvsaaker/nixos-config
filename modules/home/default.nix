{ config, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
in
{
  flake.homeManagerModules = modules // {
    profiles-desktop = {
      imports = with config.flake.homeManagerModules; [
        programs-discord
        programs-foot
        programs-firefox
        programs-element
        programs-sway
        services-syncthing
      ];

      services = {
        mpris-proxy.enable = true;
        playerctld.enable = true;
      };
    };

    profiles-cli = {
      imports = with config.flake.homeManagerModules; [
        programs-helix
        programs-git
        programs-fish
        programs-starship
        programs-fzf
      ];
    };
  };
}
