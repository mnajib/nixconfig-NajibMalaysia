{
  config,
  pkgs,
  ...
}:
{

  # Define a systemd service to download the named.root file
  systemd.services.updateRootHints = {
    description = "Download and update root hints for dnsmasq";
    serviceConfig = {
      ExecStart = "${pkgs.curl}/bin/curl -o /etc/dnsmasq/root.hints https://www.internic.net/domain/named.root";
      User = "nobody";
      #Group = "nobody";
      Group = "nogroup";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Ensure the root hints service runs periodically (e.g., daily)
  systemd.timers.updateRootHints = {
    description = "Periodic update of root hints for dnsmasq";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  services.unbound = {
    enable = true;

    #package = pkgs.unbound-with-systemd;
    #package = pkgs.unbound-full;
    #package = pkgs.unbound;

    #enableRootTrustAnchor = true;

    #stateDir = "/var/lib/unbound";

    settings = {

      server = {

        # location of the trust anchor file that enables DNSSEC
        #auto-trust-anchor-file = "/var/lib/unbound/root.key";

        # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
        # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
        #interface = [ "127.0.0.1" ];
        interface = [
          "0.0.0.0"
          #"::0"
        ];

        #port = 5335; # Default 53
        #port = 53; # Default 53

        # addresses from the IP range that are allowed to connect to the resolver
        #access-control = [ "127.0.0.1 allow" ];
        access-control = [
          "127.0.0.1 allow"
          "192.168.0.0/24 allow"
          #"2001:DB8/64 allow"
        ];

        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;

        # send minimal amount of information to upstream servers to enhance privacy
        qname-minimisation = true;

      }; # End services.unbound.settings.server

      #forward-zone = [
      #  # Example config with quad9
      #  {
      #    name = ".";
      #    forward-addr = [
      #      "9.9.9.9#dns.quad9.net"
      #      "149.112.112.112#dns.quad9.net"
      #    ];
      #    forward-tls-upstream = true;  # Protected DNS
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
    allowedUDPPorts = [
      #5335 # testing
      53  # dns default
    ];
  };

}
