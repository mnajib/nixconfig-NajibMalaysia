{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.lutris
  ];
}
