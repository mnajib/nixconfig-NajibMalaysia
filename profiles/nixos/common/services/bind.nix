# bind.nix
{
  pkgs,
  ...
}:
{
  services.bind = {
    enable = true;

    listenOn = [
      #"lo"
      #"eno1"
      "any" # Default
    ];

    listenOnPort = 53; # Default: 53

    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
      "192.168.0.0/24"
      "192.168.1.0/24"
    ];

    forwarders = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    #directory = "/var/lib/bind"; # Default: "/run/named"

    # Authoritative zone for localdomain
    zones = {
      "localdomain" = {
        master = true;
        file = pkgs.writeText "zone-localdomain" ''
          $ORIGIN localdomain.
          $TTL    1h

          @               IN SOA ns1.localdomain. hostmaster.localdomain. (
                              1        ; Serial
                              3h       ; Refresh
                              1h       ; Retry
                              1w       ; Expire
                              1h       ; Negative Cache TTL
                          )

                          IN NS ns1.localdomain.

          ns1             IN A 192.168.0.11
          gw              IN A 192.168.0.1
          customdesktop   IN A 192.168.0.10
          nyxora          IN A 192.168.0.11
          printer         IN A 192.168.0.22
          taufiq          IN A 192.168.0.12
          sumayah         IN A 192.168.0.13
        '';
      }; # End zones."localdomain" = { ... };
    };

    # Extra options for recursion and forwarding
    extraOptions = ''
      //directory "/var/lib/bind";

      // Allow recursion for your LAN
      recursion yes;
      allow-recursion {
        192.168.0.0/24;
        127.0.0.1;
      };

      // Forward external queries to upstream resolvers
      //forwarders {
      //  1.1.1.1;
      //  8.8.8.8;
      //};
    ''; # End services.bind.extraOptions = "";

  }; # End service.bind = { ... };

  #networking.searchDomains = [ "localdomain" ];
  #networking.nameservers = [ "192.168.1.1" ];

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
