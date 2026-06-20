{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-router.nixosModules.default
  ];

  networking.enableIPv4Forwarding = true;

  # WAN trunk
  networking.interfaces.enp2s0.useDHCP = false;

  networking.vlans = {
    wan = {
      id = 500;
      interface = "enp2s0";
    };
  };

  networking.interfaces.wan.useDHCP = true;

  # LAN
  networking.interfaces.enp3s0.ipv4.addresses = [{
    address = "192.168.1.1";
    prefixLength = 24;
  }];

  # NAT
  networking.nat = {
    enable = true;
    externalInterface = "wan";
    internalInterfaces = [ "enp3s0" "enp4s0" "enp5s0" ];
  };

  services.dnsmasq.enable = true;
}

