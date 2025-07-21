{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    #nitter
    #redis
  ];

  services.redis.servers."nitter-redis-server" = {
    enable = true;
  };

  services.nitter = {
    enable = true;
  };

  #~/.nitter.conf

  networking.firewall = {
    allowedTCPPorts = [
      #8888 # jupyter-lab, jupyter-notebook
    ];
  };
}
