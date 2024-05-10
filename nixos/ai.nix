{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    ollama
    aichat
    kdePackages.alpaka
  ];

  services.ollama = {
    enable = true;
    #listenAddress = ...
    #package = ...;
    #acceleration = ...
    #...
  };
}
