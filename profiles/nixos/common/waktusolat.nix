# profiles/nixos/hosts/asmak/waktusolat.nix
{ config, inputs, ... }:

{
  imports = [
    inputs.waktusolat.nixosModules.default
  ];

  # 1. Enable client daemon with fallback
  services.waktusolat = {
    enable = true;
    zones = [ "SGR01" ];
    #dataDir = "/var/cache/waktusolat";
    #aggregatorTimeout = 3;

    aggregatorUrl = "http://nyxora:8089";

    reminder.enable = true;
  };

  # 2. Export data path for renderers on satellite nodes
  #environment.sessionVariables = {
  #  WAKTUSOLAT_DATA_DIR = "/var/cache/waktusolat";
  #  WAKTUSOLAT_ZONE = "SGR01";
  #};

}
