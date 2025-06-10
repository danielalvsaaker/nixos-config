{ ... }:
{
  services.cloudflare-warp.enable = true;

  services.resolved.extraConfig = ''
    ResolveUnicastSingleLabel=yes
  '';
}
