{
  imports = [
    ./fish.nix
  ];

  time.timeZone = "Europe/Oslo";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "22.11";
}
