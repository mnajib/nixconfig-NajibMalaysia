{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Modern browsers
    firefox qutebrowser
    brave google-chrome chromium
    luakit

    # Text browsers
    lynx elinks w3m
  ];
}

