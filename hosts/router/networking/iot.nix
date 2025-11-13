{
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

      address = [
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

  networking.nftables.tables."10-iot" = {
    family = "inet";
    content = ''
      chain forward {
        type filter hook forward priority 0; policy drop;

        ct state established,related accept

        iifname "iot" oifname "eth0" accept
      }

      chain input {
        type filter hook input priority 0; policy drop;

        ct state established,related accept

        iifname "iot" udp dport { 53, 67 } accept
        iifname "iot" tcp dport 53 accept
      }
    '';
  };
}
