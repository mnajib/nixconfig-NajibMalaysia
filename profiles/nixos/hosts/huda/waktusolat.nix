# profiles/nixos/hosts/asmak/waktusolat.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.waktusolat.nixosModules.client
  ];

  # 1. Enable client daemon with fallback
  services.waktusolatClient = {
    enable = true;
    aggregatorUrl = "http://nyxora:8089";
    zones = [ "SGR01" ];
    dataDir = "/var/cache/waktusolat";
    aggregatorTimeout = 3;
  };

  # 2. Export data path for renderers on satellite nodes
  environment.sessionVariables = {
    WAKTUSOLAT_DATA_DIR = "/var/cache/waktusolat";
    WAKTUSOLAT_ZONE = "SGR01";
  };

}
