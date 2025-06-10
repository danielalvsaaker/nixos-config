{ ... }:
{
  users.users.stine = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" ];
  };
}
