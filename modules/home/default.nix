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
        services-syncthing
      ];

      services.mpris-proxy.enable = true;
    };

    profiles-cli = {
      imports = with config.flake.homeManagerModules; [
        programs-direnv
        programs-fish
        programs-git
        programs-helix
        programs-starship
        programs-fzf
      ];
    };
  };
}
