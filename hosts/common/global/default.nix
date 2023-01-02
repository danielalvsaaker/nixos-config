{ inputs, outputs, ... }:
{
  imports = [
    ./fish.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
