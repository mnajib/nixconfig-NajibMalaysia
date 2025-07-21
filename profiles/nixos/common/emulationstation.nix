{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.emulationstation
  ];
}
