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
      pkgs.meld
    ];

    dconf.settings = {
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/ring-l.jxl";
        picture-uri-dark = "${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/ring-d.jxl";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    programs.git = {
      userName = "danielalvsaaker";
      userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
    };
  };
}
