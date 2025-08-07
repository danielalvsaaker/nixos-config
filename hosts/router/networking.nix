{
  systemd.network = {
    enable = true;
    config = {
      networkConfig = {
        SpeedMeter = true;
      };
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";

    networkConfig = {
      Description = "WAN";
      
      DHCP = true;
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      UseDNS = "no";
    };

    dhcpV6Config = {
      DUIDType = "link-layer";
      PrefixDelegationHint = "::/48";
      UseDNS = "no";
    };
  };

  systemd.network.networks."20-lan" = {
    matchConfig.Name = "enp2s0";

    address = [
      "10.0.0.1/24"
    ];

    networkConfig = {
      Description = "LAN";
      
      DHCPServer = true;
      IPv6SendRA = true;
      IPv6AcceptRA = false;
      IPMasquerade = "ipv4";
      DHCPPrefixDelegation = true;
      MulticastDNS = true;
    };

    ipv6Prefixes = [
      {
        ipv6PrefixConfig = {
          Prefix = "::/64";
        };
      }
    ];
  };
}
