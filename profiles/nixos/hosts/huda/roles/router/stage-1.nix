{ inputs, config, lib, ... }:

{
  imports = [
    inputs.nixos-router.nixosModules.default
  ];

  # Enable routing core
  networking.enableIPv4Forwarding = true;

  # LAN (upstream ISP router still gives internet)
  networking.interfaces.enp3s0.ipv4.addresses = [{
    address = "192.168.0.19";
    prefixLength = 24;
  }];

  # Guest network
  networking.interfaces.enp4s0.ipv4.addresses = [{
    address = "192.168.50.1";
    prefixLength = 24;
  }];

  # DMZ
  networking.interfaces.enp5s0.ipv4.addresses = [{
    address = "192.168.60.1";
    prefixLength = 24;
  }];

  # DHCP
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ "enp4s0" "enp5s0" ];
      dhcp-range = [
        "enp4s0,192.168.50.100,192.168.50.200,12h"
        "enp5s0,192.168.60.100,192.168.60.200,12h"
      ];
    };
  };

  # Firewall isolation
  networking.firewall = {
    enable = true;
    interfaces.enp4s0.allowedTCPPorts = [ ];
    interfaces.enp5s0.allowedTCPPorts = [ ];
  };
}

