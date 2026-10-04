# File: ./profiles/nixos/hosts/nyxora/services/unbound.nix
#
# Recursive resolver used ONLY by Blocky (127.0.0.1:5335).
# Role split:
#   Blocky  :53    -> clients, blocking, caching
#   BIND    :5353  -> authoritative for local zones
#   Unbound :5335  -> recursion for everything else (no third-party resolver)
#
# To check the port is free:
#   sudo ss -tulpn | grep -E ':5335|:5353'
#

{
  config,
  pkgs,
  ...
}:
let
  unboundPort = 5335;
in
{

  # NOTE:
  #  systemctl status unbound.service
  #  journalctl -u unbound.service -f

  # Define a systemd service to download the named.root file
  #systemd.services.updateRootHints = {
  #  description = "Download and update root hints for dnsmasq";
  #  serviceConfig = {
  #    ExecStart = "${pkgs.curl}/bin/curl -o /etc/dnsmasq/root.hints https://www.internic.net/domain/named.root";
  #    User = "nobody";
  #    #Group = "nobody";
  #    Group = "nogroup";
  #  };
  #  wantedBy = [ "multi-user.target" ];
  #};

  ## Ensure the root hints service runs periodically (e.g., daily)
  #systemd.timers.updateRootHints = {
  #  description = "Periodic update of root hints for dnsmasq";
  #  timerConfig = {
  #    OnCalendar = "daily";
  #    Persistent = true;
  #  };
  #  wantedBy = [ "timers.target" ];
  #};

  services.unbound = {
    enable = true;

    #package = pkgs.unbound-with-systemd;
    #package = pkgs.unbound-full;
    #package = pkgs.unbound;

    #enableRootTrustAnchor = true;

    #stateDir = "/var/lib/unbound";

    # Blocky owns system DNS; do not let this module point
    # /etc/resolv.conf at 127.0.0.1 itself.
    resolveLocalQueries = false;

    settings = {

      server = {

        #verbosity = 2; # 0 (no verbosity, only errors) to 5 (logs client identification for cache misses). Default 1.

        # location of the trust anchor file that enables DNSSEC
        #auto-trust-anchor-file = "/var/lib/unbound/root.key";

        # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
        # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
        #interface = [ "127.0.0.1" ];
        interface = [
          #"0.0.0.0"
          #"::0"
          "127.0.0.1" # Set to only this for setup where only Blocky talks to it
          "192.168.0.11"
        ];

        #port = 5335; # Blocky listen on port 53, Bind listen on port 5353
        port = unboundPort; # Blocky listen on port 53, Bind listen on port 5353
        #port = 53; # Default 53

        # addresses from the IP range that are allowed to connect to the resolver
        #access-control = [ "127.0.0.1 allow" ];
        access-control = [
          "127.0.0.1 allow"
          "127.0.0.0/8 allow"
          "192.168.0.0/24 allow" # LAN
          "192.168.1.0/24 allow" #

          ##"192.168.2.0/24 allow" #
          ##"2001:DB8/64 allow"
        ];

        do-ip6 = false; # nyxora has no IPv6 route at least for current setup

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Disable DNSSEC validation for the specific internal zone
        #module-config = "validator iterator";

        # Custom settings
        hide-identity = true;
        hide-version = true;

        # send minimal amount of information to upstream servers to enhance privacy
        qname-minimisation = true;

        domain-insecure = [
          "localdomain."
        ];

      }; # End services.unbound.settings.server

      #local-zone =  "localdomain. static";
      #local-data = [
      #  "gw.localdomain. 10800 IN A 192.168.1.1"
      #  "customdesktop.localdomain. 10800 IN A 192.168.1.10"
      #  "nyxora.localdomain. IN A 192.168.1.11"
      #  "printer.localdomain. IN A 192.168.1.22"
      #  "taufiq.localdomain. IN A 192.168.1.12"
      #];

      #forward-zone = [
      #  # # Example config with quad9
      #  # {
      #  #   name = ".";
      #  #   forward-addr = [
      #  #     "9.9.9.9#dns.quad9.net"
      #  #     "149.112.112.112#dns.quad9.net"
      #  #   ];
      #  #   forward-tls-upstream = true;  # Protected DNS
      #  # }
      #
      #  # Upstream for everything else
      #  {
      #    name = ".";
      #    forward-addr = [
      #       "1.1.1.1"
      #       "1.0.0.1"
      #       #"8.8.8.8"
      #       #"8.8.4.4"
      #       #"9.9.9.9"
      #     ];
      #  }
      #
      #  #{
      #  #  name = "localdomain.";
      #  #  forward-addr = [
      #  #    "192.168.0.15"
      #  #  ];
      #  #  #forward-first = true;
      #  #  #do-not-query-localhost = false;
      #  #  #dnssec-bogus-addr = "0.0.0.0";
      #  #  #dnssec-check-unsigned = true; # Allow responses without DNSSEC validation
      #  #}
      #
      #]; # End services.unbound.settings.forward-zone
      #
      #forward-zone = [
      #  {
      #    name = ".";
      #    forward-addr = [
      #       "1.1.1.1"
      #       "1.0.0.1"
      #       #"8.8.8.8"
      #       #"8.8.4.4"
      #       #"9.9.9.9"
      #     ];
      #  }
      #];

      # allows controlling unbound using "unbound-control"
      remote-control.control-enable = true;

    }; # End services.unbound.settings

  }; # End services.unbound

  services.resolved.domains = [
    "localdomain"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      # 5335
      unboundPort
      # 53  # dns default
    ];
    allowedUDPPorts = [
      # 5335
      unboundPort
      # 53  # dns default
    ];
  };

}
