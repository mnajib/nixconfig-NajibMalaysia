{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.mame
    pkgs.mame-tools
  ];
}
