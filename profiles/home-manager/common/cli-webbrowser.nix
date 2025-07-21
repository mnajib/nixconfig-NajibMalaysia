{ config, nixpkgs, ... }:
{
  home.packages = with pkgs; [
    links2
    lynx
  ];
}
