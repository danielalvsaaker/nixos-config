{
  systemd.network = {
    enable = true;
    config = {
      networkConfig = {
        SpeedMeter = true;
      };
    };
  };

  systemd.network = {
    netdevs."10-iot" = {
      netdevConfig = {
        Name = "iot";
        Kind = "vlan";
      };

      vlanConfig = {
        Id = 20;
      };
    };

    networks."11-iot" = {
      matchConfig = {
        Name = "iot";
        Type = "vlan";
      };

      address =[
        "10.0.20.1/24"
      ];

      networkConfig = {
        Description = "IoT";

        DHCPServer = true;
        IPv6SendRA = true;
        IPv6AcceptRA = false;
        IPMasquerade = "ipv4";
        DHCPPrefixDelegation = true;
      };
    };
  };

  systemd.network = {
    netdevs."10-lab" = {
      netdevConfig = {
        Name = "lab";
        Kind = "vlan";
      };

      vlanConfig = {
        Id = 10;
      };
    };

    networks."11-lab" = {
      matchConfig = {
        Name = "lab";
        Type = "vlan";
      };

      address = [
        "10.0.10.1/24"
      ];

      networkConfig = {
        Description = "Lab";

        DHCPServer = true;
        IPv6SendRA = true;
        IPv6AcceptRA = false;
        IPMasquerade = "ipv4";
        DHCPPrefixDelegation = true;
      };
    };
  };

  systemd.network = {
    netdevs."10-untrusted" = {
      netdevConfig = {
        Name = "untrusted";
        Kind = "vlan";
      };

      vlanConfig = {
        Id = 30;
      };
    };

    networks."11-untrusted" = {
      matchConfig = {
        Name = "untrusted";
        Type = "vlan";
      };

      address = [
        "10.0.30.1/24"
      ];

      networkConfig = {
        Description = "Untrusted";

        DHCPServer = true;
        IPv6SendRA = true;
        IPv6AcceptRA = false;
        IPMasquerade = "ipv4";
        DHCPPrefixDelegation = true;
      };
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";

    networkConfig = {
      Description = "WAN";
      
      DHCP = true;
      IPv6AcceptRA = true;

      VLAN = [
        "iot"
        "lab"
        "untrusted"
      ];
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
  };
}
