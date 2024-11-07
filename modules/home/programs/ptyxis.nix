{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.ptyxis ];

  dconf.settings =
    let
      default-profile-uuid = "20fc255d892e0a7de2fe1155669f94ce";
    in
    {
      "org/gnome/Ptyxis" = {
        inherit default-profile-uuid;
        profile-uuids = [ default-profile-uuid ];

        cursor-shape = "block";
        interface-style = "system";
      };

      "org/gnome/Ptyxis/Profiles/${default-profile-uuid}" = {
        "palette" = "gnome";
        "bold-is-bright" = true;
      };
    };
}
