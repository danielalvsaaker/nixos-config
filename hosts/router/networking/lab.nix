{
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

  networking.nftables.tables."lab" = {
    enable = false;
    family = "inet";
    content = ''
      chain forward {
        type filter hook forward priority 0; policy drop;

        ct state established,related accept

        iifname "lab" oifname "eth0" accept
        iifname "lab" oifname "lab" accept
        iifname "eth1" oifname "lab" accept
      }

      chain input {
        type filter hook input priority 0; policy drop;

        ct state established,related accept

        iifname "lab" udp dport { 53, 67 } accept
        iifname "lab" tcp dport 53 accept
      }
    '';
  };
}
