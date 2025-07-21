{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.chirp
  ];
}
