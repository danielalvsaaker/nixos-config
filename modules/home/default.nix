{ config, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
in
{
  flake.homeManagerModules = modules // {
    profiles-desktop = {
      imports = with config.flake.homeManagerModules; [
        programs-discord
        programs-firefox
        programs-ptyxis
        services-syncthing
        gnome
      ];

      services.mpris-proxy.enable = true;
    };

    profiles-cli = {
      imports = with config.flake.homeManagerModules; [
        programs-direnv
        programs-fish
        programs-git
        programs-jujutsu
        programs-helix
        programs-starship
        programs-fzf
      ];
    };
  };
}
