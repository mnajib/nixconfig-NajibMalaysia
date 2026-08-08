# profiles/nixos/hosts/nyxora/services/waktusolat-aggregator.nix

#
# NOTE:
#   nyxora runs only the Aggregator service, omitting the Client service
#   entirely to prevent duplicate fetch loops.
#

{ config, inputs, ... }:

let
  networkPort = 8089;
  zones = [ "SGR01" ];
in
{
  # 1. Import the Aggregator module (origin node for your LAN)
  imports = [
    inputs.waktusolat.nixosModules.default
  ];

  # 2. Enable & configure the Aggregator daemon and HTTP file server
  services.waktusolat = {
    enable = true;

    #zones = [ "SGR01" ];
    #zones = zones;
    inherit zones;

    #dataDir = "/var/lib/waktusolat";
    #logLevel = "INFO";

    aggregator = {
      enable = true;
      port = networkPort;
      openFirewallPort = true;
    };

    reminder.enable = true;
  };

}
