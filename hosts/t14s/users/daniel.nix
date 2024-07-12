{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-daniel
    home-manager
  ];

  home-manager.users.daniel = { lib, pkgs, ... }: {
    imports = with inputs.self.homeManagerModules; [
      profiles-desktop
      profiles-cli
    ];

    home.packages = [
      pkgs.jetbrains.rider
      pkgs.obsidian
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
