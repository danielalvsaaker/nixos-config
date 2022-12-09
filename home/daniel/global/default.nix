{ inputs, pkgs, config, ... }:

{
  imports = [
    ../features/cli/git.nix
    ../features/nvim
    ../features/helix
    ../features/alacritty
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  home.packages = with pkgs; [
    ibm-plex
  ];
  
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "daniel";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };
}
