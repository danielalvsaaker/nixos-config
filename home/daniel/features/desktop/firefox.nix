{ inputs, pkgs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    profiles.daniel = {
      extensions = with addons; [
        bitwarden
        clearurls
        decentraleyes
        ublock-origin
      ];
    };
  };
}
