{ inputs, ... }:
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];

    optimise = {
      dates = [ "weekly" ];
      automatic = true;
    };

    gc = {
      dates = "weekly";
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
