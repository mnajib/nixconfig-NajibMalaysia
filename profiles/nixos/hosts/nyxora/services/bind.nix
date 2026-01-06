# bind.nix
{
  pkgs,
  ...
}:
let

  #
  # NOTE:
  #
  #   dhcpd is configured to give dynamic ip in range from 192.168.0.100 to 192.168.0.200.
  #

  hosts = {
    # Services
    gw                  = "192.168.0.1";
    printer             = "192.168.0.22";
    ns1                 = "192.168.0.11";
    api                 = "192.168.0.11";
    git                 = "192.168.0.11";
    pgadmin             = "192.168.0.11";
    sijilberhenti       = "192.168.0.11";
    devsijilberhenti    = "192.168.0.11";
    #dev.sijilberhenti  = "192.168.0.11";
    #sbdev              = "192.168.0.11";

    # Hosts
    customdesktop   = "192.168.0.10";
    durian          = "192.168.0.10";
    nyxora          = "192.168.0.11";
    taufiq          = "192.168.0.12";
    sumayah         = "192.168.0.13";
    khawlah         = "192.168.0.14";
    keira           = "192.168.0.15";
    maryam          = "192.168.0.16";
    asmak           = "192.168.0.17";
  };

  zoneFile = pkgs.writeText "zone-localdomain" ''
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

    ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: ip: "${name} IN A ${ip}") hosts)}
  '';

  reverseZone = "0.168.192.in-addr.arpa";

  reverseFile = pkgs.writeText "zone-reverse" ''
    $ORIGIN ${reverseZone}.
    $TTL    1h

    @               IN SOA ns1.localdomain. hostmaster.localdomain. (
                        1        ; Serial
                        3h       ; Refresh
                        1h       ; Retry
                        1w       ; Expire
                        1h       ; Negative Cache TTL
                    )

                    IN NS ns1.localdomain.

    ${pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.unique (
        pkgs.lib.mapAttrsToList (name: ip:
          let
            octets = pkgs.lib.splitString "." ip;
            last = builtins.elemAt octets 3;
          in
            "${last} IN PTR ${name}.localdomain."
        ) hosts
      )
    )}
  '';
in
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

      #"localdomain" = {
      #  master = true;
      #  file = pkgs.writeText "zone-localdomain" ''
      #    $ORIGIN localdomain.
      #    $TTL    1h
      #
      #    @               IN SOA ns1.localdomain. hostmaster.localdomain. (
      #                        1        ; Serial
      #                        3h       ; Refresh
      #                        1h       ; Retry
      #                        1w       ; Expire
      #                        1h       ; Negative Cache TTL
      #                    )
      #
      #                    IN NS ns1.localdomain.
      #
      #    ns1             IN A 192.168.0.11
      #    gw              IN A 192.168.0.1
      #    customdesktop   IN A 192.168.0.10
      #    nyxora          IN A 192.168.0.11
      #    printer         IN A 192.168.0.22
      #    taufiq          IN A 192.168.0.12
      #    sumayah         IN A 192.168.0.13
      #  '';
      #}; # End zones."localdomain" = { ... };

      "localdomain" = {
        master = true;
        file = zoneFile;
      };

      "${reverseZone}" = {
        master = true;
        file = reverseFile;
      };

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
