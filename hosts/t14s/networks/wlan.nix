{
  systemd.network.networks."10-wlan0" = {
    matchConfig.Name = "wlan0";
    networkConfig = {
      DHCP = "yes";
      IgnoreCarrierLoss = "3s";
    };
  };

  networking.wireless.iwd.enable = true;
}
