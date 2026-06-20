{
  config,
  pkgs,
  ...
}:
#let
  #
#in
{

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  networking.firewall = {
    allowedTCPPorts = [
      22000 # incoming/outgoing, sync protocal (TCP), main data transfor pipe. Highly recommended for maximum stability and spee.d
      8384 # for Syncthing Web UI
    ];
    allowedUDPPorts = [
      22000 # incoming/outgoing, sync protocal (QUIC), alternative data transfer via QUI. Greate for mobile connections and data loss recovery.
      21027 # incoming/outgoing, local discovery. Broadcasts data over your local network so devices can find each other instantly without typing IP addresses.
    ];
  };

}
