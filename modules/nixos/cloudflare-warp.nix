{ pkgs, ... }:
{
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.targets.multi-user.wants = [ "warp-svc.service" ];

  systemd.user.services.warp-taskbar.serviceConfig = {
    TemporaryFileSystem = "/usr:ro";
    BindReadOnlyPaths = [
      "${pkgs.cloudflare-warp}/share/:/usr/share/"
    ];
  };
}
