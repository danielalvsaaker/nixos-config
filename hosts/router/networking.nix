{
  imports = [
    ./networking/iot.nix
    ./networking/lab.nix
  ];

  networking.useNetworkd = true;
  networking.useDHCP = false;
  services.resolved.enable = false;
  
  systemd.network = {
    enable = true;
    config = {
      networkConfig = {
        IPv6Forwarding = true;
        SpeedMeter = true;
      };
    };
  };

  systemd.network = {
    netdevs."10-home" = {
      netdevConfig = {
        Name = "home";
        Kind = "vlan";
      };

      vlanConfig = {
        Id = 20;
      };
    };

    networks."11-home" = {
      matchConfig = {
        Name = "home";
        Type = "vlan";
      };

      address = [
        "10.0.20.1/24"
      ];

      networkConfig = {
        Description = "Home";

        DHCPServer = true;
        IPv6SendRA = true;
        IPv6AcceptRA = false;
        IPMasquerade = "ipv4";
        DHCPPrefixDelegation = true;
      };
    };

    netdevs."10-untrusted" = {
      netdevConfig = {
        Name = "untrusted";
        Kind = "vlan";
      };

      vlanConfig = {
        Id = 40;
      };
    };

    networks."11-untrusted" = {
      matchConfig = {
        Name = "untrusted";
        Type = "vlan";
      };

      address = [
        "10.0.40.1/24"
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

      VLAN = [
        "home"
        "iot"
        "lab"
        "untrusted"
      ];
    };
  };
}
