{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    #jupyter
    #ihaskell
  ];

  services.invidious = {
    enable = true;
    #port = 3000: # Default: 3000
    #address = ""; Default: if config.services.invidious.nginx.enable then "127.0.0.1" else "0.0.0.0"
    #nginx.enable = true; # Whether to configure nginx as a reverse proxy for Invidious.
  };

  networking.firewall = {
    allowedTCPPorts = [
      #8888 # jupyter-lab, jupyter-notebook
    ];
  };
}
