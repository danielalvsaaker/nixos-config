{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-daniel
    home-manager
  ];

  home-manager.users.daniel = { pkgs, ... }: {
    imports = with inputs.self.homeManagerModules; [
      profiles-desktop
      profiles-cli
    ];

    home.packages = [
      pkgs.jetbrains.rider
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
