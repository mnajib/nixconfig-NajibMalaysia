# ./profile/nixos/hosts/nyxora/services/blocky.nix
#
#
# To list open ports:
#   sudo ss -tulpn | grep -i 53
#   sudo lsof -i -P -n | grep LISTEN
#   sudo lsof -i :53
#   sudo fuser 5353/udp
#   sudo fuser 53/tcp
#
# NOTE on allowlists:
#   A list group that has ONLY allowlists puts Blocky into "ALLOWLIST ONLY"
#   mode (everything not on the list is blocked). To avoid this, allowlist
#   entries live in the SAME group as a denylist (here: "ads"), so they
#   act as exceptions instead of a whitelist-only gate.
#

{ pkgs, ... }:

{
  services.blocky = {
    enable = true;
    settings = {
      # Listen on standard DNS port across all interfaces
      ports.dns = 53;

      # Direct local zone resolution queries to BIND running on port 5353
      conditional = {
        mapping = {
          "localdomain" = "127.0.0.1:5353";
          "0.168.192.in-addr.arpa" = "127.0.0.1:5353";
        };
      };

      # Encrypted upstream resolvers (DNS-over-TLS / DoT) for external domains
      upstreams = {
        groups = {
          default = [
            "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
            "tcp-tls:1.1.1.1:853"
            "tcp-tls:1.0.0.1:853"
            "tcp-tls:8.8.8.8:853"
          ];
        };
      };

      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [ "1.1.1.1" "1.0.0.1" ];
      };

      # Automated Denylist configuration
      blocking = {
        allowlists = {

          # Exceptions for the "ads" group (same group name as the ads denylist,
          # so Blocky does NOT enter allowlist-only mode)
          ads = [
            # Community allowlist
            "https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"

            # Yandex captcha: inline domain definitions
            "yastatic.net"
            "yandex.ru"
            "yandex.com"
            "smartcaptcha.yandexcloud.net"
          ];

        };

        denylists = {

          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://adaway.org/hosts.txt"
          ];

          adult = [
            "https://blocklistproject.github.io/Lists/porn.txt"
          ];

          # Optional regex to drop suspicious TLDs generating background spam
          #suspicious_tlds = [
          #  "regex:.*\\.cfd$"
          #  "regex:.*\\.qpon$"
          #];

        };

        # Define custom groups by mapping client keys directly to list groups
        clientGroupsBlock = {
          default = [
            "ads"
            #"suspicious_tlds"
          ];
          "192.168.0.13,192.168.0.19,192.168.0.18" = [
            "ads"
            "adult"
          ];
        };

        # List loading configuration (replaces the deprecated top-level
        # blocking.refreshPeriod / downloadTimeout / downloadAttempts)
        loading = {
          refreshPeriod = "4h";     # Automatically re-download lists every 4 hours
          downloads = {
            timeout = "4m";         # Fallback timeout per list
            attempts = 3;           # Retries before using cached list
          };
        };
      };

      # Caching & performance tuning
      caching = {
        minTime = "5m";
        maxTime = "24h";
        prefetching = true;       # Auto-refresh frequently queried domains
      };

      # Optional Prometheus metrics for monitoring (e.g., via Grafana)
      #ports.http = 4000;
      #ports.http = 5399;
      ports.http = 8053;
    };
  };
}
