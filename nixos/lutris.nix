{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
    dxvk
  ];
}
