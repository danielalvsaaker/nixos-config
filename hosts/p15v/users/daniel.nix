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

  home-manager.users."daniel.alvsaker" = { lib, pkgs, firefox-addons, ... }: {
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
      pkgs.azurite
      # pkgs.azuredatastudio
      pkgs.azure-cli
      pkgs.meld
      pkgs.azure-functions-core-tools
      (with pkgs.dotnetCorePackages; combinePackages [
        sdk_8_0
        aspnetcore_8_0
        sdk_6_0
        aspnetcore_6_0
      ])
    ];

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        show-all-sources = false;
        per-window = true;
        sources = with lib.hm.gvariant; [
          (mkTuple [ "xkb" "us+colemak_dh" ])
          (mkTuple [ "xkb" "us" ])
        ];
      };
    };

    programs.git = {
      userName = "danielalvsaaker";
      userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
    };
  };
}
