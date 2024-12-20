{
  config,
  pkgs,
  #inputs,
  #outputs,
  lib,
  hostname,
  ...
}:
let
  barrierConfigDir = ./src/.config/barrier;

  # Map hostnames to their corresponding Barrier config files
  barrierConfigMap = {
    "khadijah" = "${barrierConfigDir}/barrier-khadijah.conf";
    "zahrah" = "${barrierConfigDir}/barrier-zahrah.conf";
  };

  # Default config file if hostname does not match
  defaultConfig = "${barrierConfigDir}/default.conf";

  # Retrieve the current hostname using builtins.getEnv
  #currentHostname = builtins.getEnv "HOSTNAME";
  #
  # Determine which config file to use based on the current hostname
  #barrierConfigFile = lib.getAttrDefault config.networking.hostname defaultConfig barrierConfigMap;
  #barrierConfigFile = lib.attrByPath [config.networking.hostname] defaultConfig barrierConfigMap;
  #barrierConfigFile = lib.attrByPath [currentHostname] defaultConfig barrierConfigMap;
  barrierConfigFile = lib.attrByPath [hostname] defaultConfig barrierConfigMap;
in {
  # Ensure directory exists
  #home.file.".config/barrier".source = barrierConfigDir;

  # Create the Barrier.conf symlink
  home.file.".config/barrier/barrier.conf".source = barrierConfigFile;
}
