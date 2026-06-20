{
  config,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    jami
  ];

  networking.firewall = {
    # DHT network, SIP communication, and audio/video data transfer
    allowedTCPPorts = [
      5060
    ];
    allowedUDPPorts = [
      4222  # OpenDHT (4222): A Distributed Hash Table (DHT) is a decentralized,
            # peer-to-peer system that provides a lookup service similar to a
            # traditional directory.
            # Jami uses this to find other devices without a central server.

      5060  # SIP (5060): Session Initiation Protocol (SIP) is a signaling
            # protocol used for initiating, maintaining, and terminating
            # real-time sessions like voice and video calls.

      7999
      5004
    ];
  };

}
