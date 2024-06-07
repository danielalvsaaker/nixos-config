{ inputs, pkgs, ... }:
{
  imports = with inputs.self.nixosModules; [
    home-manager
  ];

  users.users."daniel.alvsaker" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  home-manager.users."daniel.alvsaker" = { config, pkgs, firefox-addons, ... }: {
    imports = with inputs.self.homeManagerModules; [
      profiles-desktop
      profiles-cli
    ];

    home.packages = [
      pkgs.jetbrains.rider
      pkgs.teams-for-linux
      pkgs.slack
      pkgs.cloudflare-warp
      pkgs.citrix_workspace
      pkgs.azuredatastudio
      pkgs.azure-cli
    ];

    dconf.settings."org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
    };

    programs.git = {
      userName = "danielalvsaaker";
      userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
    };
  };
}
