{ inputs, pkgs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      bitwarden
      clearurls
      decentraleyes
      ublock-origin
    ];
    profiles.daniel = { };
  };
}
