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
        denylists = {

          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://adaway.org/hosts.txt"
          ];

          adult = [
            "https://blocklistproject.github.io/Lists/porn.txt"
          ];

        };
        clientGroupsBlock = {
          default = [ "ads" ];
          kids-ipad = ["ads" "adult"];
        };

        # In-memory dynamic refresh configuration
        refreshPeriod = "4h";     # Automatically re-download lists every 4 hours
        downloadTimeout = "4m";   # Fallback timeout per list
        downloadAttempts = 3;     # Retries before using cached list
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
